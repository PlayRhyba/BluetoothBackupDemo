//
//  BBSBrowser.h
//  BluetoothBackupDemo
//
//  Created by Alexander Snegursky on 9/11/16.
//  Copyright © 2016 Alexander Snegursky. All rights reserved.
//


#import "BBSMulticastSender.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>


@class BBSBrowser;


@protocol BBSBrowserDelegate <NSObject>

- (void)browser:(BBSBrowser *)browser
 didChangeState:(MCSessionState)state
        session:(MCSession *)session
           peer:(MCPeerID *)peerID;
@end


@interface BBSBrowser : BBSMulticastSender

+ (instancetype)sharedInstance;
- (void)browseWithViewController:(UIViewController *)vc;
- (void)disconnect;

- (void)sendResourceAtURL:(NSURL *)resourceURL
        completionHandler:(void(^)(NSError *))completion
          progressHandler:(void(^)(float progress))progress;
@end
