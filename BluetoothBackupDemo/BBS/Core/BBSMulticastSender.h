//
//  BBSMulticastSender.h
//  BluetoothBackupDemo
//
//  Created by Alexander Snegursky on 9/9/16.
//  Copyright © 2016 Alexander Snegursky. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface BBSMulticastSender : NSObject

@property (nonatomic, strong, readonly) NSHashTable *delegates;

- (void)addDelegate:(id)delegate;
- (void)removeDelegate:(id)delegate;
- (void)removeAllDelegates;
- (BOOL)shouldSendMessageToDelegate:(id)delegate;

@end
