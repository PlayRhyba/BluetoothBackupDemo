//
//  BBSCommand.m
//  BluetoothBackupDemo
//


#import "BBSCommand.h"


NSString * const BBSCommandBackupsListRequest = @"BBSCommandBackupsListRequest";
NSString * const BBSCommandBackupsListResponse = @"BBSCommandBackupsListResponse";


static NSString * const kName = @"name";
static NSString * const kPayload = @"payload";


@interface BBSCommand ()

@property (nonatomic, strong, readwrite) NSString *name;
@property (nonatomic, strong, readwrite) id payload;

@end


@implementation BBSCommand


#pragma mark - NSCoding


- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_name forKey:kName];
    [aCoder encodeObject:_payload forKey:kPayload];
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _name = [aDecoder decodeObjectForKey:kName];
        _payload = [aDecoder decodeObjectForKey:kPayload];
    }
    
    return self;
}


#pragma mark - Public Methods


+ (BBSCommand *)backupsListRequestCommand {
    return [[BBSCommand alloc]initWithName:BBSCommandBackupsListRequest payload:nil];
}


+ (BBSCommand *)backupsListResponseCommandWithFileNames:(NSArray *)fileNames {
    return [[BBSCommand alloc]initWithName:BBSCommandBackupsListResponse payload:fileNames];
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
