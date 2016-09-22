# BluetoothBackupDemo

Some ideas about task of managing backups among iOS devices when the network connection is unavailable. Connection is established via Bluetooth by using the MultipeerConnectivity framework.

For simplest case only 3 task should be performed by “backup server”:
- receiving backups
- retrieving of list of stored backups
- retrieving of the backup by some qualifier

So interfaces for Browser (Client) and Advertiser (Server) can be implemented as

Browser:

```objc
- (void)browseWithViewController:(UIViewController *)vc;
- (void)disconnect;
- (BOOL)hasConnectedPeers;

- (void)sendResourceAtURL:(NSURL *)resourceURL
        completionHandler:(void(^)(NSError *))completion
          progressHandler:(BBSProgressBlock)progress;

- (void)requestBackupsList;
- (void)requestBackupWithFileInfo:(BBSFileInfo *)info;
```

Advertiser:

```objc
- (void)start;
- (void)stop;
- (BOOL)hasConnectedPeers;
- (BOOL)isStarted;
```
