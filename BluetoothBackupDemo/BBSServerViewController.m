//
//  BBSServerViewController.m
//  BluetoothBackupDemo
//
//  Created by Alexander Snegursky on 9/9/16.
//  Copyright © 2016 Alexander Snegursky. All rights reserved.
//


#import "BBSServerViewController.h"
#import "BBSConnectionManager.h"


static NSString * const kCellReuseIdentifier = @"_cell";


@interface BBSServerViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UIView *statusView;
@property (nonatomic, weak) IBOutlet UIButton *startButton;
@property (nonatomic, weak) IBOutlet UIButton *stopButton;
@property (nonatomic, weak) IBOutlet UITableView *connectedDevicesTableView;
@property (nonatomic, strong) NSMutableArray *connectedDevices;

- (IBAction)startButtonClicked:(UIButton *)sender;
- (IBAction)stopButtonClicked:(UIButton *)sender;
- (void)adjustUIState;

@end


@implementation BBSServerViewController


#pragma mark - Getters/Setters


- (NSMutableArray *)connectedDevices {
    if (_connectedDevices == nil) {
        _connectedDevices = [NSMutableArray array];
    }
    
    return _connectedDevices;
}


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


- (IBAction)startButtonClicked:(UIButton *)sender {
    [[BBSConnectionManager sharedInstance]startServer];
}


- (IBAction)stopButtonClicked:(UIButton *)sender {
    [[BBSConnectionManager sharedInstance]stopServer];
}


#pragma mark - UITableViewDataSource, UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.connectedDevices.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellReuseIdentifier];
    }
    
    cell.textLabel.text = self.connectedDevices[indexPath.row];
    
    return cell;
}


#pragma mark - BBSConnectionManagerDelegate


- (void)connectionManager:(BBSConnectionManager *)manager
           didChangeState:(MCSessionState)state
            serverSession:(MCSession *)session
                     peer:(MCPeerID *)peerID {
    if (state != MCSessionStateConnecting) {
        [self.connectedDevices removeAllObjects];
        
        if (state == MCSessionStateNotConnected) {
            for (MCPeerID *peer in session.connectedPeers) {
                [self.connectedDevices addObject:peer.displayName];
            }
        }
        
        [_connectedDevicesTableView reloadData];
    }
}


#pragma mark - Internal Logic


- (void)adjustUIState {
    
}

@end
