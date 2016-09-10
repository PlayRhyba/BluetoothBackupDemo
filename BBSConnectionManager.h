//
//  BBSConnectionManager.h
//  BluetoothBackupDemo
//
//  Created by Alexander Snegursky on 9/9/16.
//  Copyright © 2016 Alexander Snegursky. All rights reserved.
//


#import "BBSMulticastSender.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>


@class BBSConnectionManager;


@protocol BBSConnectionManagerDelegate <NSObject>

@optional

- (void)connectionManager:(BBSConnectionManager *)manager
           didChangeState:(MCSessionState)state
            serverSession:(MCSession *)session
                     peer:(MCPeerID *)peerID;

- (void)connectionManager:(BBSConnectionManager *)manager
           didChangeState:(MCSessionState)state
            clientSession:(MCSession *)session
                     peer:(MCPeerID *)peerID;
@end


@interface BBSConnectionManager : BBSMulticastSender

+ (instancetype)sharedInstance;
- (void)startServer;
- (void)stopServer;
- (void)connectWithViewController:(UIViewController *)vc;
- (void)disconnect;

@end
