//
//  NSString+Utilities.m
//  BluetoothBackupDemo
//
//  Created by Alexander Snegursky on 9/10/16.
//  Copyright © 2016 Alexander Snegursky. All rights reserved.
//


#import "NSString+Utilities.h"


@implementation NSString (Utilities)


+ (NSString *)stringWithSessionState:(MCSessionState)state {
    switch (state) {
        case MCSessionStateConnected: return @"CONNECTED";
        case MCSessionStateConnecting: return @"CONNECTING";
        case MCSessionStateNotConnected: return @"DISCONNECTED";
    }
}

@end
