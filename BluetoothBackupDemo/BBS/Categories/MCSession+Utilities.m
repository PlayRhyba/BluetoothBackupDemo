//
//  MCSession+Utilities.m
//  BluetoothBackupDemo
//
//  Created by Alexander Snegursky on 9/11/16.
//  Copyright © 2016 Alexander Snegursky. All rights reserved.
//


#import "MCSession+Utilities.h"


@implementation MCSession (Utilities)


+ (MCSession *)sessionWithDelegate:(id<MCSessionDelegate>)delegate  {
    NSString *deviceName = [UIDevice currentDevice].name;
    MCPeerID *peerID = [[MCPeerID alloc]initWithDisplayName:deviceName];
    MCSession *session = [[MCSession alloc]initWithPeer:peerID];
    session.delegate = delegate;
    
    return session;
}


+ (NSString *)stringWithSessionState:(MCSessionState)state {
    switch (state) {
        case MCSessionStateConnected: return @"CONNECTED";
        case MCSessionStateConnecting: return @"CONNECTING";
        case MCSessionStateNotConnected: return @"DISCONNECTED";
    }
}


+ (UIColor *)colorWithSessionState:(MCSessionState)state {
    switch (state) {
        case MCSessionStateConnected: return [UIColor greenColor];
        case MCSessionStateConnecting: return [UIColor yellowColor];
        case MCSessionStateNotConnected: return [UIColor clearColor];
    }
}

@end
