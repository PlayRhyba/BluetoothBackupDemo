//
//  BBSCommand.h
//  BluetoothBackupDemo
//


#import <Foundation/Foundation.h>


extern NSString * const BBSCommandBackupsListRequest;
extern NSString * const BBSCommandBackupsListResponse;


@interface BBSCommand : NSObject <NSCoding>

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) id payload;

+ (BBSCommand *)backupsListRequestCommand;
+ (BBSCommand *)backupsListResponseCommandWithFileNames:(NSArray *)fileNames;
- (instancetype)initWithName:(NSString *)name payload:(id)payload;
- (NSData *)data;

@end
