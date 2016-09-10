//
//  BBSClientViewController.m
//  BluetoothBackupDemo
//
//  Created by Alexander Snegursky on 9/9/16.
//  Copyright © 2016 Alexander Snegursky. All rights reserved.
//


#import "BBSClientViewController.h"
#import "BBSConnectionManager.h"


@interface BBSClientViewController () <UITableViewDataSource, UITableViewDelegate, BBSConnectionManagerDelegate>

@property (nonatomic, weak) IBOutlet UIView *statusView;
@property (nonatomic, weak) IBOutlet UIButton *connectButton;
@property (nonatomic, weak) IBOutlet UIButton *disconnectButton;
@property (nonatomic, weak) IBOutlet UIButton *requestBackupsListButton;
@property (nonatomic, weak) IBOutlet UIButton *sendBackupButton;
@property (nonatomic, weak) IBOutlet UITableView *backupsListTableView;

- (IBAction)connectButtonClicked:(UIButton *)sender;
- (IBAction)disconnectButtonClicked:(UIButton *)sender;
- (IBAction)requestBackupsListButtonClicked:(UIButton *)sender;
- (IBAction)sendBackupButtonClicked:(UIButton *)sender;
- (void)adjustUIState;

@end


@implementation BBSClientViewController


#pragma mark - Lifecycle Methods


- (void)viewDidLoad {
    [super viewDidLoad];
    [[BBSConnectionManager sharedInstance]addDelegate:self];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self adjustUIState];
}


- (void)dealloc {
    [[BBSConnectionManager sharedInstance]removeDelegate:self];
}


#pragma mark - IBAction


- (IBAction)connectButtonClicked:(UIButton *)sender {
    [[BBSConnectionManager sharedInstance]connectWithViewController:self];
}


- (IBAction)disconnectButtonClicked:(UIButton *)sender {
    [[BBSConnectionManager sharedInstance]disconnect];
}


- (IBAction)requestBackupsListButtonClicked:(UIButton *)sender {
    
}


- (IBAction)sendBackupButtonClicked:(UIButton *)sender {
    
}


#pragma mark - UITableViewDataSource, UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - BBSConnectionManagerDelegate


- (void)connectionManager:(BBSConnectionManager *)manager
           didChangeState:(MCSessionState)state
            clientSession:(MCSession *)session
                     peer:(MCPeerID *)peerID {
}


#pragma mark - Internal Logic


- (void)adjustUIState {
    
}

@end
