//
//  BBSAdvertiser.m
//  BluetoothBackupDemo
//
//  Created by Alexander Snegursky on 9/11/16.
//  Copyright © 2016 Alexander Snegursky. All rights reserved.
//


#import "BBSAdvertiser.h"
#import "MCSession+Utilities.h"
#import "BBSConstants.h"
#import "BBSCommand.h"


@interface BBSAdvertiser () <MCSessionDelegate>

@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;

- (NSString *)backupDirectoryPath;

- (void)processCommand:(BBSCommand *)command
           withSession:(MCSession *)session
              fromPeer:(MCPeerID *)peer;
@end


@implementation BBSAdvertiser


#pragma mark - Public Methods


+ (instancetype)sharedInstance {
    static BBSAdvertiser *_sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[BBSAdvertiser alloc]init];
    });
    
    return _sharedInstance;
}


- (void)start {
    [self stop];
    
    self.advertiser = [[MCAdvertiserAssistant alloc]initWithServiceType:BBSConstantsServiceType
                                                          discoveryInfo:nil
                                                                session:[MCSession sessionWithDelegate:self]];
    [_advertiser start];
    
    NSLog(@"ADVERTISER HAS BEEN STARTED");
}


- (void)stop {
    [_advertiser stop];
    self.advertiser = nil;
    
    NSLog(@"ADVERTISER HAS BEEN STOPPED");
}


- (BOOL)hasConnectedPeers {
    return _advertiser.session.connectedPeers > 0;
}


#pragma mark - MCSessionDelegate


- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"ADVERTISER'S SESSION STATE CHANGED TO %@", [MCSession stringWithSessionState:state]);
        
        for (id<BBSAdvertiserDelegate> delegate in self.delegates) {
            if ([delegate respondsToSelector:@selector(advertiser:didChangeState:session:peer:)]) {
                [delegate advertiser:self didChangeState:state session:session peer:peerID];
            }
        }
    });
}


- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    id obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (obj && [obj isKindOfClass:[BBSCommand class]]) {
        BBSCommand *command = (BBSCommand *)obj;
        
        [self processCommand:command withSession:session fromPeer:peerID];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"ADVERTISER RECEIVED COMMAND WITH NAME: %@, PAYLOAD: %@", command.name, command.payload);
            
            for (id<BBSAdvertiserDelegate> delegate in self.delegates) {
                if ([delegate respondsToSelector:@selector(advertiser:didReceiveCommand:session:peer:)]) {
                    [delegate advertiser:self didReceiveCommand:command session:session peer:peerID];
                }
            }
        });
    }
}


- (void)    session:(MCSession *)session
   didReceiveStream:(NSInputStream *)stream
           withName:(NSString *)streamName
           fromPeer:(MCPeerID *)peerID {}


- (void)                    session:(MCSession *)session
  didStartReceivingResourceWithName:(NSString *)resourceName
                           fromPeer:(MCPeerID *)peerID
                       withProgress:(NSProgress *)progress {
    NSLog(@"ADVERTISER HAS STARTED RECEIVING RESOURCE WITH NAME: %@", resourceName);
}


- (void)                    session:(MCSession *)session
 didFinishReceivingResourceWithName:(NSString *)resourceName
                           fromPeer:(MCPeerID *)peerID
                              atURL:(NSURL *)localURL
                          withError:(nullable NSError *)error {
    NSLog(@"ADVERTISER HAS FINISHED RECEIVING RESOURCE WITH NAME: %@. ERROR: %@", resourceName, error.localizedDescription);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"dd-MM-yyyy_HH:mm:ss";
    NSString *fileName = [NSString stringWithFormat:@"backup_%@", [dateFormatter stringFromDate:[NSDate date]]];
    
    NSString *destinationPath = [[self backupDirectoryPath]stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:destinationPath]) {
        [fileManager removeItemAtPath:destinationPath error:nil];
    }
    
    if ([fileManager copyItemAtURL:localURL
                             toURL:[NSURL fileURLWithPath:destinationPath]
                             error:nil]) {
        NSLog(@"BACKUP HAS BEEN SAVED AT PATH: %@", destinationPath);
    }
}


#pragma mark - Internal Logic


- (NSString *)backupDirectoryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths.firstObject stringByAppendingPathComponent:@"Backups"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:path] == NO) {
        [fileManager createDirectoryAtPath:path
               withIntermediateDirectories:NO
                                attributes:nil
                                     error:nil];
    }
    
    return path;
}


- (void)processCommand:(BBSCommand *)command
           withSession:(MCSession *)session
              fromPeer:(MCPeerID *)peer {
    if ([command.name isEqualToString:BBSCommandBackupsListRequest]) {
        NSArray<NSString *> *files = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:[self backupDirectoryPath]
                                                                                        error:nil];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self BEGINSWITH 'backup'"];
        files = [files filteredArrayUsingPredicate:predicate];
        
        BBSCommand *command = [BBSCommand backupsListResponseCommandWithFileNames:files];
        
        NSError *error = nil;
        
        [_advertiser.session sendData:[command data]
                              toPeers:_advertiser.session.connectedPeers
                             withMode:MCSessionSendDataReliable
                                error:&error];
        if (error) {
            NSLog(@"SEND BACKUP LIST RESPONSE ERROR: %@", error.localizedDescription);
        }
    }
}

@end
