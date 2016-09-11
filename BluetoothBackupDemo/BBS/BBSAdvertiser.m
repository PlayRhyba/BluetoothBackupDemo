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


@interface BBSAdvertiser () <MCSessionDelegate>

@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;

- (NSString *)backupDirectoryPath;

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
    
    NSString *destinationPath = [[self backupDirectoryPath]stringByAppendingPathComponent:resourceName];
    
    [[NSFileManager defaultManager]copyItemAtURL:localURL
                                           toURL:[NSURL fileURLWithPath:destinationPath]
                                           error:nil];
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

@end
