//
//  BBSConnectionManager.h
//  BluetoothBackupDemo
//
//  Created by Alexander Snegursky on 9/9/16.
//  Copyright © 2016 Alexander Snegursky. All rights reserved.
//


#import "BBSMulticastSender.h"


@interface BBSConnectionManager : BBSMulticastSender

+ (instancetype)sharedInstance;

@end
