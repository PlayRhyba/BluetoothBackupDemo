//
//  BBSCommand.m
//  BluetoothBackupDemo
//


#import "BBSCommand.h"


NSString * const BBSCommandBackupsListRequest = @"BBSCommandBackupsListRequest";
NSString * const BBSCommandBackupsListResponse = @"BBSCommandBackupsListResponse";
NSString * const BBSCommandRequestBackup = @"BBSCommandRequestBackup";


@interface BBSCommand ()

@property (nonatomic, strong, readwrite) NSString *name;
@property (nonatomic, strong, readwrite) id payload;

@end


@implementation BBSCommand


#pragma mark - NSCoding


- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_name forKey:NSStringFromSelector(@selector(name))];
    [aCoder encodeObject:_payload forKey:NSStringFromSelector(@selector(payload))];
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _name = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(name))];
        _payload = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(payload))];
    }
    
    return self;
}


#pragma mark - Public Methods


+ (BBSCommand *)backupsListRequestCommand {
    return [[BBSCommand alloc]initWithName:BBSCommandBackupsListRequest payload:nil];
}


+ (BBSCommand *)backupsListResponseCommandWithFiles:(NSArray <BBSFileInfo *> *)files {
    return [[BBSCommand alloc]initWithName:BBSCommandBackupsListResponse payload:files];
}


+ (BBSCommand *)requestBackupCommandWithFileInfo:(BBSFileInfo *)info {
    return [[BBSCommand alloc]initWithName:BBSCommandRequestBackup payload:info];
}


- (instancetype)initWithName:(NSString *)name payload:(id)payload {
    if (self = [super init]) {
        _name = name;
        _payload = payload;
    }
    
    return self;
}


- (NSData *)data {
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

@end
