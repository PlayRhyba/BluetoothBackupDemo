//
//  BBSFileInfo.h
//  BluetoothBackupDemo
//
//  Created by Alexander Snigurskyi on 2016-09-12.
//  Copyright © 2016 Alexander Snegursky. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface BBSFileInfo : NSObject <NSCoding>

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *path;
@property (nonatomic, strong, readonly) NSDate *creationDate;
@property (nonatomic, strong, readonly) NSNumber *size;

- (instancetype)initWithPath:(NSString *)path;

@end
