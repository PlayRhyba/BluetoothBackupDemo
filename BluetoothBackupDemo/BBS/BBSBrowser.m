//
//  BBSBrowser.m
//  BluetoothBackupDemo
//
//  Created by Alexander Snegursky on 9/11/16.
//  Copyright © 2016 Alexander Snegursky. All rights reserved.
//


#import "BBSBrowser.h"
#import "MCSession+Utilities.h"


static NSString * const kFractionCompletedKeyPath = @"fractionCompleted";


@interface BBSBrowser () <MCSessionDelegate, MCBrowserViewControllerDelegate>

@property (nonatomic, readwrite) MCSessionState sessionState;
@property (nonatomic, strong) MCBrowserViewController *browserVC;
@property (nonatomic, strong) MCSession *clientSession;
@property (nonatomic, copy) BBSProgressBlock backupUploadingProgressBlock;

@end


@implementation BBSBrowser


#pragma mark - Public Methods


+ (instancetype)sharedInstance {
    static BBSBrowser *_sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[BBSBrowser alloc]init];
    });
    
    return _sharedInstance;
}


- (instancetype)init {
    if (self = [super init]) {
        _sessionState = MCSessionStateNotConnected;
    }
    
    return self;
}


- (void)browseWithViewController:(UIViewController *)vc {
    [self disconnect];
    
    self.clientSession = [MCSession sessionWithDelegate:self];
    
    self.browserVC = [[MCBrowserViewController alloc]initWithServiceType:BBSConstantsServiceType
                                                                 session:_clientSession];
    _browserVC.delegate = self;
    
    [vc presentViewController:_browserVC animated:YES completion:nil];
}


- (void)disconnect {
    [self dismissBrowserViewController];
    
    [_clientSession disconnect];
    self.clientSession = nil;
}


- (BOOL)hasConnectedPeers {
    return _clientSession.connectedPeers.count > 0;
}


- (void)dismissBrowserViewController {
    [_browserVC dismissViewControllerAnimated:YES completion:nil];
}


- (void)sendResourceAtURL:(NSURL *)resourceURL
        completionHandler:(void(^)(NSError *))completion
          progressHandler:(BBSProgressBlock)progress {
    __typeof (self) __weak weakSelf = self;
    
    NSProgress *p = [_clientSession sendResourceAtURL:resourceURL
                                             withName:resourceURL.absoluteString.lastPathComponent
                                               toPeer:_clientSession.connectedPeers.firstObject
                                withCompletionHandler:^(NSError * _Nullable error) {
                                    weakSelf.backupUploadingProgressBlock = nil;
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        if (completion) {
                                            completion(error);
                                        }
                                    });
                                }];
    if (progress) {
        self.backupUploadingProgressBlock = progress;
        
        [p addObserver:self
            forKeyPath:kFractionCompletedKeyPath
               options:NSKeyValueObservingOptionNew
               context:nil];
    }
}


- (void)requestBackupsList {
    if ([self hasConnectedPeers]) {
        BBSCommand *command = [BBSCommand backupsListRequestCommand];
        
        NSError *error = nil;
        
        [_clientSession sendData:[command data]
                         toPeers:_clientSession.connectedPeers
                        withMode:MCSessionSendDataReliable
                           error:&error];
        if (error) {
            NSLog(@"BROWSER: REQUEST BUCKUPS LIST ERROR: %@", error.localizedDescription);
        }
    }
}


- (void)requestBackupWithFileInfo:(BBSFileInfo *)info {
    if ([self hasConnectedPeers]) {
        BBSCommand *command = [BBSCommand requestBackupCommandWithFileInfo:info];
        
        NSError *error = nil;
        
        [_clientSession sendData:[command data]
                         toPeers:_clientSession.connectedPeers
                        withMode:MCSessionSendDataReliable
                           error:&error];
        if (error) {
            NSLog(@"BROWSER: REQUEST BACKUP ERROR: %@", error.localizedDescription);
        }
    }
}


#pragma mark - MCSessionDelegate


- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    NSLog(@"BROWSER: SESSION STATE CHANGED TO %@", [MCSession stringWithSessionState:state]);
    
    self.sessionState = state;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<BBSBrowserDelegate> delegate in self.delegates) {
            if ([delegate respondsToSelector:@selector(browser:didChangeState:session:peer:)]) {
                [delegate browser:self didChangeState:state session:session peer:peerID];
            }
        }
    });
}


- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    id obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (obj && [obj isKindOfClass:[BBSCommand class]]) {
        BBSCommand *command = (BBSCommand *)obj;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            for (id<BBSBrowserDelegate> delegate in self.delegates) {
                if ([delegate respondsToSelector:@selector(browser:didReceiveCommand:session:peer:)]) {
                    [delegate browser:self didReceiveCommand:command session:session peer:peerID];
                }
            }
        });
        
        NSLog(@"BROWSER: RECEIVED COMMAND WITH NAME: %@, PAYLOAD: %@", command.name, command.payload);
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
    NSLog(@"BROWSER: START RECEIVING RESOURCE WITH NAME: %@", resourceName);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<BBSBrowserDelegate> delegate in self.delegates) {
            if ([delegate respondsToSelector:@selector(browser:didStartReceivingResourceWithName:withSession:fromPeer:progress:)]) {
                [delegate browser:self
didStartReceivingResourceWithName:resourceName
                      withSession:session
                         fromPeer:peerID
                         progress:progress];
            }
        }
    });
}


- (void)                    session:(MCSession *)session
 didFinishReceivingResourceWithName:(NSString *)resourceName
                           fromPeer:(MCPeerID *)peerID
                              atURL:(NSURL *)localURL
                          withError:(nullable NSError *)error {
    NSLog(@"BROWSER: FINISH RECEIVING RESOURCE WITH NAME: %@. ERROR: %@", resourceName, error.localizedDescription);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<BBSBrowserDelegate> delegate in self.delegates) {
            if ([delegate respondsToSelector:@selector(browser:didFinishReceivingResourceWithName:withSession:fromPeer:atURL:withError:)]) {
                [delegate browser:self
didFinishReceivingResourceWithName:resourceName
                      withSession:session
                         fromPeer:peerID
                            atURL:localURL
                        withError:error];
            }
        }
    });
}


#pragma mark - MCBrowserViewControllerDelegate


- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    [self dismissBrowserViewController];
}


- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    [self dismissBrowserViewController];
}


#pragma mark - KVO


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if (keyPath == kFractionCompletedKeyPath) {
        NSProgress *progress = (NSProgress *)object;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_backupUploadingProgressBlock) {
                _backupUploadingProgressBlock(progress.fractionCompleted);
            }
        });
    }
}

@end
