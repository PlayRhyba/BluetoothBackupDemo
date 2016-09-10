//
//  NSString+Utilities.h
//  BluetoothBackupDemo
//
//  Created by Alexander Snegursky on 9/10/16.
//  Copyright © 2016 Alexander Snegursky. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>


@interface NSString (Utilities)

+ (NSString *)stringWithSessionState:(MCSessionState)state;

@end
