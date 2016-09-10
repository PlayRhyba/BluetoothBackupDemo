//
//  BBSConnectionManager.m
//  BluetoothBackupDemo
//
//  Created by Alexander Snegursky on 9/9/16.
//  Copyright © 2016 Alexander Snegursky. All rights reserved.
//


#import "BBSConnectionManager.h"
#import "NSString+Utilities.h"


static NSString * const kServiceType = @"backup-demo";


@interface BBSConnectionManager () <MCSessionDelegate, MCBrowserViewControllerDelegate>

@property (nonatomic, strong) MCBrowserViewController *browserVC;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, strong) MCSession *clientSession;

- (MCSession *)createSession;
- (void)dismissBrowser;

@end


@implementation BBSConnectionManager


#pragma mark - Public Methods


+ (instancetype)sharedInstance {
    static BBSConnectionManager *_sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[BBSConnectionManager alloc]init];
    });
    
    return _sharedInstance;
}


- (void)startServer {
    [self stopServer];
    
    self.advertiser = [[MCAdvertiserAssistant alloc]initWithServiceType:kServiceType
                                                          discoveryInfo:nil
                                                                session:[self createSession]];
    [_advertiser start];
    
    NSLog(@"SERVER HAS BEEN STARTED");
}


- (void)stopServer {
    [_advertiser stop];
    self.advertiser = nil;
    
    NSLog(@"SERVER HAS BEEN STOPPED");
}


- (void)connectWithViewController:(UIViewController *)vc {
    [self disconnect];
    
    self.clientSession = [self createSession];
    
    self.browserVC = [[MCBrowserViewController alloc]initWithServiceType:kServiceType
                                                                 session:_clientSession];
    _browserVC.delegate = self;
    
    [vc presentViewController:_browserVC animated:YES completion:nil];
}


- (void)disconnect {
    [self dismissBrowser];
    
    [_clientSession disconnect];
    self.clientSession = nil;
}


#pragma mark - MCSessionDelegate


- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    if (session == _clientSession) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"CLIENT'S SESSION STATE CHANGED TO %@", [NSString stringWithSessionState:state]);
            
            for (id<BBSConnectionManagerDelegate> delegate in self.delegates) {
                if ([delegate respondsToSelector:@selector(connectionManager:didChangeState:clientSession:peer:)]) {
                    [delegate connectionManager:self
                                 didChangeState:state
                                  clientSession:session
                                           peer:peerID];
                }
            }
        });
    }
    else if (session == _advertiser.session) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"SERVER'S SESSION STATE CHANGED TO %@", [NSString stringWithSessionState:state]);
            
            for (id<BBSConnectionManagerDelegate> delegate in self.delegates) {
                if ([delegate respondsToSelector:@selector(connectionManager:didChangeState:serverSession:peer:)]) {
                    [delegate connectionManager:self
                                 didChangeState:state
                                  serverSession:session
                                           peer:peerID];
                }
            }
        });
    }
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
    
}


- (void)                    session:(MCSession *)session
 didFinishReceivingResourceWithName:(NSString *)resourceName
                           fromPeer:(MCPeerID *)peerID
                              atURL:(NSURL *)localURL
                          withError:(nullable NSError *)error {
    
}


#pragma mark - MCBrowserViewControllerDelegate


- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    [self dismissBrowser];
}


- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    [self dismissBrowser];
}


#pragma mark - Internal Logic


- (MCSession *)createSession {
    NSString *deviceName = [UIDevice currentDevice].name;
    MCPeerID *peerID = [[MCPeerID alloc]initWithDisplayName:deviceName];
    MCSession *session = [[MCSession alloc]initWithPeer:peerID];
    session.delegate = self;
    
    return session;
}


- (void)dismissBrowser {
    [_browserVC dismissViewControllerAnimated:YES completion:nil];
}

@end
