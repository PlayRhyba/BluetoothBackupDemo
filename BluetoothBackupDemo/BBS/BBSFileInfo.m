//
//  BBSFileInfo.m
//  BluetoothBackupDemo
//
//  Created by Alexander Snigurskyi on 2016-09-12.
//  Copyright © 2016 Alexander Snegursky. All rights reserved.
//


#import "BBSFileInfo.h"


static NSString * const kName = @"name";
static NSString * const kPath = @"path";
static NSString * const kCreationDate = @"creationDate";
static NSString * const kSize = @"size";


@interface BBSFileInfo ()

@property (nonatomic, strong, readwrite) NSString *name;
@property (nonatomic, strong, readwrite) NSString *path;
@property (nonatomic, strong, readwrite) NSDate *creationDate;
@property (nonatomic, strong, readwrite) NSNumber *size;

@end


@implementation BBSFileInfo


#pragma mark - NSCoding


- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_name forKey:kName];
    [aCoder encodeObject:_path forKey:kPath];
    [aCoder encodeObject:_creationDate forKey:kCreationDate];
    [aCoder encodeObject:_size forKey:kSize];
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _name = [aDecoder decodeObjectForKey:kName];
        _path = [aDecoder decodeObjectForKey:kPath];
        _creationDate = [aDecoder decodeObjectForKey:kCreationDate];
        _size = [aDecoder decodeObjectForKey:kSize];
    }
    
    return self;
}


#pragma mark - NSObject


- (NSString *)description {
    NSDictionary *info = @{kName : _name ?: @"",
                           kPath : _path ?: @"",
                           kCreationDate : _creationDate ?: [NSNull null],
                           kSize : _size ?: @0};
    
    return [info description];
}


#pragma mark - Public Methods


- (instancetype)initWithPath:(NSString *)path {
    NSError *error = nil;
    NSDictionary *attributes = [[NSFileManager defaultManager]attributesOfItemAtPath:path error:&error];
    
    if (attributes && error == nil) {
        if (self = [super init]) {
            _name = [path lastPathComponent];
            _path = path;
            _creationDate = attributes[NSFileCreationDate];
            _size = attributes[NSFileSize];
        }
        
        return self;
    }
    
    return nil;
}

@end
