//
//  BBSProgressTracker.h
//  BluetoothBackupDemo
//
//  Created by Alexander Snigurskyi on 2016-09-13.
//  Copyright © 2016 Alexander Snegursky. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "BBSConstants.h"


@interface BBSProgressTracker : NSObject

@property (nonatomic, strong, readonly) NSProgress *progress;

- (instancetype)initWithProgress:(NSProgress *)progress
                   trackingBlock:(BBSProgressBlock)trackingBlock;
@end
