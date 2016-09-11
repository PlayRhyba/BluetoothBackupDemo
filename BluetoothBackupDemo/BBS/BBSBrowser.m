//
//  BBSBrowser.m
//  BluetoothBackupDemo
//
//  Created by Alexander Snegursky on 9/11/16.
//  Copyright © 2016 Alexander Snegursky. All rights reserved.
//


#import "BBSBrowser.h"
#import "MCSession+Utilities.h"
#import "BBSConstants.h"


@interface BBSBrowser () <MCSessionDelegate, MCBrowserViewControllerDelegate>

@property (nonatomic, strong) MCBrowserViewController *browserVC;
@property (nonatomic, strong) MCSession *clientSession;

- (void)dismissBrowser;

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


- (void)browseWithViewController:(UIViewController *)vc {
    [self disconnect];
    
    self.clientSession = [MCSession sessionWithDelegate:self];
    
    self.browserVC = [[MCBrowserViewController alloc]initWithServiceType:BBSConstantsServiceType
                                                                 session:_clientSession];
    _browserVC.delegate = self;
    
    [vc presentViewController:_browserVC animated:YES completion:nil];
}


- (void)disconnect {
    [self dismissBrowser];
    
    [_clientSession disconnect];
    self.clientSession = nil;
}


- (void)sendResourceAtURL:(NSURL *)resourceURL
        completionHandler:(void(^)(NSError *))completion
          progressHandler:(void(^)(float progress))progress {
    NSProgress *p = [_clientSession sendResourceAtURL:resourceURL
                                             withName:resourceURL.absoluteString.lastPathComponent
                                               toPeer:_clientSession.connectedPeers.firstObject
                                withCompletionHandler:completion];
    
    
    //TODO: Track progress
    
    
}


#pragma mark - MCSessionDelegate


- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"BROWSER'S SESSION STATE CHANGED TO %@", [MCSession stringWithSessionState:state]);
        
        for (id<BBSBrowserDelegate> delegate in self.delegates) {
            if ([delegate respondsToSelector:@selector(browser:didChangeState:session:peer:)]) {
                [delegate browser:self didChangeState:state session:session peer:peerID];
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


- (void)dismissBrowser {
    [_browserVC dismissViewControllerAnimated:YES completion:nil];
}

@end
