//
//  BBSMulticastSender.m
//  BluetoothBackupDemo
//
//  Created by Alexander Snegursky on 9/9/16.
//  Copyright © 2016 Alexander Snegursky. All rights reserved.
//


#import "BBSMulticastSender.h"


@interface BBSMulticastSender ()

@property (nonatomic, strong, readwrite) NSHashTable *delegates;

@end


@implementation BBSMulticastSender


#pragma mark - Getters/Setters


- (NSHashTable *)delegates {
    if (_delegates == nil) {
        _delegates = [NSHashTable weakObjectsHashTable];
    }
    
    return _delegates;
}


#pragma mark - Public Methods


- (void)addDelegate:(id)delegate {
    if (delegate) {
        [self.delegates addObject:delegate];
    }
}


- (void)removeDelegate:(id)delegate {
    if (delegate) {
        [self.delegates removeObject:delegate];
    }
}


- (void)removeAllDelegates {
    [self.delegates removeAllObjects];
}


- (BOOL)shouldSendMessageToDelegate:(id)delegate {
    if ([delegate isKindOfClass:[UIViewController class]]) {
        UIViewController *vc = (UIViewController *)delegate;
        return vc.isViewLoaded && vc.view.window;
    }
    
    return YES;
}

@end
