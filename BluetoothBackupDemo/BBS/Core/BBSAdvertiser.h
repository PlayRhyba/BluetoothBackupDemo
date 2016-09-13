//
//  BBSAdvertiser.h
//  BluetoothBackupDemo
//
//  Created by Alexander Snegursky on 9/11/16.
//  Copyright © 2016 Alexander Snegursky. All rights reserved.
//


#import "BBSMulticastSender.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>


@class BBSAdvertiser;
@class BBSCommand;


@protocol BBSAdvertiserDelegate <NSObject>

@optional

- (void)advertiser:(BBSAdvertiser *)advertiser
    didChangeState:(MCSessionState)state
           session:(MCSession *)session
              peer:(MCPeerID *)peerID;

- (void)advertiser:(BBSAdvertiser *)advertiser
 didReceiveCommand:(BBSCommand *)command
           session:(MCSession *)session
              peer:(MCPeerID *)peerID;
@end


@interface BBSAdvertiser : BBSMulticastSender

+ (instancetype)sharedInstance;
- (void)start;
- (void)stop;
- (BOOL)hasConnectedPeers;
- (BOOL)isStarted;

@end
