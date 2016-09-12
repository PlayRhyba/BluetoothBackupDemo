//
//  BBSCommand.h
//  BluetoothBackupDemo
//


#import <Foundation/Foundation.h>


extern NSString * const BBSCommandBackupsListRequest;
extern NSString * const BBSCommandBackupsListResponse;
extern NSString * const BBSCommandRequestBackup;


@class BBSFileInfo;


@interface BBSCommand : NSObject <NSCoding>

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) id payload;

+ (BBSCommand *)backupsListRequestCommand;
+ (BBSCommand *)backupsListResponseCommandWithFiles:(NSArray <BBSFileInfo *> *)files;
+ (BBSCommand *)requestBackupCommandWithFileInfo:(BBSFileInfo *)info;
- (instancetype)initWithName:(NSString *)name payload:(id)payload;
- (NSData *)data;

@end
