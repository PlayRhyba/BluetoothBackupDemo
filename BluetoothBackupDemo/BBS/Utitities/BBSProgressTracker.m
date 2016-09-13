//
//  BBSProgressTracker.m
//  BluetoothBackupDemo
//
//  Created by Alexander Snigurskyi on 2016-09-13.
//  Copyright © 2016 Alexander Snegursky. All rights reserved.
//


#import "BBSProgressTracker.h"


static void * ProgressObserverContext = &ProgressObserverContext;


@interface BBSProgressTracker ()

@property (nonatomic, copy) BBSProgressBlock trackingBlock;
@property (nonatomic, strong, readwrite) NSProgress *progress;

@end


@implementation BBSProgressTracker


#pragma mark - Public Methods


- (instancetype)initWithProgress:(NSProgress *)progress
                   trackingBlock:(BBSProgressBlock)trackingBlock {
    if (self = [super init]) {
        _progress = progress;
        _trackingBlock = [trackingBlock copy];
        
        if (_progress && _trackingBlock) {
            [_progress addObserver:self
                        forKeyPath:NSStringFromSelector(@selector(fractionCompleted))
                           options:NSKeyValueObservingOptionNew
                           context:ProgressObserverContext];
        }
    }
    
    return self;
}


#pragma mark - Lifecycle Methods


- (void)dealloc {
    [_progress removeObserver:self
                   forKeyPath:NSStringFromSelector(@selector(fractionCompleted))
                      context:ProgressObserverContext];
}


#pragma mark - KVO


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if (context == ProgressObserverContext) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_trackingBlock) {
                _trackingBlock ([(NSProgress *)object fractionCompleted]);
            }
        });
    }
}

@end
