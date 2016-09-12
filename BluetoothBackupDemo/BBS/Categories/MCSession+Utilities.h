//
//  MCSession+Utilities.h
//  BluetoothBackupDemo
//
//  Created by Alexander Snegursky on 9/11/16.
//  Copyright © 2016 Alexander Snegursky. All rights reserved.
//


#import <MultipeerConnectivity/MultipeerConnectivity.h>


@interface MCSession (Utilities)

+ (MCSession *)sessionWithDelegate:(id<MCSessionDelegate>)delegate;
+ (NSString *)stringWithSessionState:(MCSessionState)state;
+ (UIColor *)colorWithSessionState:(MCSessionState)state;

@end
