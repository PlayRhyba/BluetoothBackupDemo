//
//  BBSFileInfo.m
//  BluetoothBackupDemo
//
//  Created by Alexander Snigurskyi on 2016-09-12.
//  Copyright © 2016 Alexander Snegursky. All rights reserved.
//


#import "BBSFileInfo.h"


@interface BBSFileInfo ()

@property (nonatomic, strong, readwrite) NSString *name;
@property (nonatomic, strong, readwrite) NSString *path;
@property (nonatomic, strong, readwrite) NSDate *creationDate;
@property (nonatomic, strong, readwrite) NSNumber *size;

@end


@implementation BBSFileInfo


#pragma mark - NSCoding


- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_name forKey:NSStringFromSelector(@selector(name))];
    [aCoder encodeObject:_path forKey:NSStringFromSelector(@selector(path))];
    [aCoder encodeObject:_creationDate forKey:NSStringFromSelector(@selector(creationDate))];
    [aCoder encodeObject:_size forKey:NSStringFromSelector(@selector(size))];
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _name = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(name))];
        _path = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(path))];
        _creationDate = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(creationDate))];
        _size = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(size))];
    }
    
    return self;
}


#pragma mark - NSObject


- (NSString *)description {
    NSDictionary *info = @{NSStringFromSelector(@selector(name)) : _name ?: @"",
                           NSStringFromSelector(@selector(path)) : _path ?: @"",
                           NSStringFromSelector(@selector(creationDate)) : _creationDate ?: [NSNull null],
                           NSStringFromSelector(@selector(size)) : _size ?: @0};
    
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
