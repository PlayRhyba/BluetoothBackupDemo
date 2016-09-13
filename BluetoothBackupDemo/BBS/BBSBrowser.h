//
//  BBSBrowser.h
//  BluetoothBackupDemo
//
//  Created by Alexander Snegursky on 9/11/16.
//  Copyright © 2016 Alexander Snegursky. All rights reserved.
//


#import "BBSMulticastSender.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "BBSConstants.h"
#import "BBSCommand.h"


@class BBSBrowser;


@protocol BBSBrowserDelegate <NSObject>

@optional

- (void)browser:(BBSBrowser *)browser
 didChangeState:(MCSessionState)state
        session:(MCSession *)session
           peer:(MCPeerID *)peerID;

- (void)   browser:(BBSBrowser *)browser
 didReceiveCommand:(BBSCommand *)command
           session:(MCSession *)session
              peer:(MCPeerID *)peerID;

- (void)                   browser:(BBSBrowser *)browser
 didStartReceivingResourceWithName:(NSString *)resourceName
                       withSession:(MCSession *)session
                          fromPeer:(MCPeerID *)peerID
                          progress:(NSProgress *)progress;

- (void)                    browser:(BBSBrowser *)browser
 didFinishReceivingResourceWithName:(NSString *)resourceName
                        withSession:(MCSession *)session
                           fromPeer:(MCPeerID *)peerID
                              atURL:(NSURL *)localURL
                          withError:(NSError *)error;
@end


@interface BBSBrowser : BBSMulticastSender

@property (nonatomic, readonly) MCSessionState sessionState;

+ (instancetype)sharedInstance;
- (void)browseWithViewController:(UIViewController *)vc;
- (void)dismissBrowserViewController;
- (void)disconnect;
- (BOOL)hasConnectedPeers;

- (void)sendResourceAtURL:(NSURL *)resourceURL
        completionHandler:(void(^)(NSError *))completion
          progressHandler:(BBSProgressBlock)progress;

- (void)requestBackupsList;
- (void)requestBackupWithFileInfo:(BBSFileInfo *)info;

@end
