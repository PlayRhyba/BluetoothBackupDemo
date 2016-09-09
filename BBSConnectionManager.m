//
//  BBSConnectionManager.m
//  BluetoothBackupDemo
//
//  Created by Alexander Snegursky on 9/9/16.
//  Copyright © 2016 Alexander Snegursky. All rights reserved.
//


#import "BBSConnectionManager.h"


@implementation BBSConnectionManager


#pragma mark - Public Methods


+ (instancetype)sharedInstance {
    static BBSConnectionManager *_sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[BBSConnectionManager alloc]init];
    });
    
    return _sharedInstance;
}
@end
