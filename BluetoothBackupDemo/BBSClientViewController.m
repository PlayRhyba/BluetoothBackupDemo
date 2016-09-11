//
//  BBSClientViewController.m
//  BluetoothBackupDemo
//
//  Created by Alexander Snegursky on 9/9/16.
//  Copyright © 2016 Alexander Snegursky. All rights reserved.
//


#import "BBSClientViewController.h"
#import "BBSBrowser.h"
#import <SVProgressHUD/SVProgressHUD.h>


@interface BBSClientViewController () <UITableViewDataSource, UITableViewDelegate, BBSBrowserDelegate>

@property (nonatomic, weak) IBOutlet UIView *statusView;
@property (nonatomic, weak) IBOutlet UIButton *connectButton;
@property (nonatomic, weak) IBOutlet UIButton *disconnectButton;
@property (nonatomic, weak) IBOutlet UIButton *requestBackupsListButton;
@property (nonatomic, weak) IBOutlet UIButton *sendBackupButton;
@property (nonatomic, weak) IBOutlet UITableView *backupsListTableView;
@property (nonatomic, strong) NSMutableArray *backupsList;

- (IBAction)connectButtonClicked:(UIButton *)sender;
- (IBAction)disconnectButtonClicked:(UIButton *)sender;
- (IBAction)requestBackupsListButtonClicked:(UIButton *)sender;
- (IBAction)sendBackupButtonClicked:(UIButton *)sender;
- (void)adjustUIState;

@end


@implementation BBSClientViewController


#pragma mark - Getters/Setters


- (NSMutableArray *)backupsList {
    if (_backupsList == nil) {
        _backupsList = [NSMutableArray array];
    }
    
    return _backupsList;
}


#pragma mark - Lifecycle Methods


- (void)viewDidLoad {
    [super viewDidLoad];
    [[BBSBrowser sharedInstance]addDelegate:self];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self adjustUIState];
}


- (void)dealloc {
    [[BBSBrowser sharedInstance]removeDelegate:self];
}


#pragma mark - IBAction


- (IBAction)connectButtonClicked:(UIButton *)sender {
    [[BBSBrowser sharedInstance]browseWithViewController:self];
}


- (IBAction)disconnectButtonClicked:(UIButton *)sender {
    [[BBSBrowser sharedInstance]disconnect];
}


- (IBAction)requestBackupsListButtonClicked:(UIButton *)sender {
    BBSBrowser *browser = [BBSBrowser sharedInstance];
    
    if ([browser hasConnectedPeers]) {
        [browser requestBackupsList];
    }
}


- (IBAction)sendBackupButtonClicked:(UIButton *)sender {
    BBSBrowser *browser = [BBSBrowser sharedInstance];
    
    if ([browser hasConnectedPeers]) {
        NSInteger number = arc4random_uniform(3);
        NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@(number).stringValue ofType:@"png"];
        
        if (bundlePath) {
            NSString *status = @"Uploading backup...";
            
            [SVProgressHUD showWithStatus:status];
            
            [[BBSBrowser sharedInstance]sendResourceAtURL:[NSURL fileURLWithPath:bundlePath]
                                        completionHandler:^(NSError *error) {
                                            if (error) {
                                                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                            }
                                            else {
                                                [SVProgressHUD dismiss];
                                            }
                                        } progressHandler:^(double progress) {
                                            [SVProgressHUD showProgress:progress status:status];
                                        }];
        }
    }
}


#pragma mark - UITableViewDataSource, UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.backupsList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"_cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"_cell"];
    }
    
    cell.textLabel.text = self.backupsList[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - BBSBrowserDelegate


- (void)browser:(BBSBrowser *)browser
 didChangeState:(MCSessionState)state
        session:(MCSession *)session
           peer:(MCPeerID *)peerID {
    if (state == MCSessionStateConnected) {
        [[BBSBrowser sharedInstance]dismissBrowserViewController];
    }
}


- (void)   browser:(BBSBrowser *)advertiser
 didReceiveCommand:(BBSCommand *)command
           session:(MCSession *)session
              peer:(MCPeerID *)peerID {
    if ([command.name isEqualToString:BBSCommandBackupsListResponse]) {
        [self.backupsList removeAllObjects];
        [self.backupsList addObjectsFromArray:(NSArray *)command.payload];
        [_backupsListTableView reloadData];
    }
}


#pragma mark - Internal Logic


- (void)adjustUIState {
    
}

@end
