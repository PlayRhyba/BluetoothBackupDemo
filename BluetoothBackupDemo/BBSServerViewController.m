//
//  BBSServerViewController.m
//  BluetoothBackupDemo
//
//  Created by Alexander Snegursky on 9/9/16.
//  Copyright © 2016 Alexander Snegursky. All rights reserved.
//


#import "BBSServerViewController.h"
#import "BBSAdvertiser.h"


@interface BBSServerViewController () <UITableViewDataSource, UITableViewDelegate, BBSAdvertiserDelegate>

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
    [[BBSAdvertiser sharedInstance]addDelegate:self];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self adjustUIState];
}


- (void)dealloc {
    [[BBSAdvertiser sharedInstance]removeDelegate:self];
}


#pragma mark - IBAction


- (IBAction)startButtonClicked:(UIButton *)sender {
    [[BBSAdvertiser sharedInstance]start];
    [self adjustUIState];
}


- (IBAction)stopButtonClicked:(UIButton *)sender {
    [[BBSAdvertiser sharedInstance]stop];
    [self adjustUIState];
}


#pragma mark - UITableViewDataSource, UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.connectedDevices.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"_cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"_cell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.connectedDevices[indexPath.row];
    
    return cell;
}


#pragma mark - BBSAdvertiserDelegate


- (void)advertiser:(BBSAdvertiser *)advertiser
    didChangeState:(MCSessionState)state
           session:(MCSession *)session
              peer:(MCPeerID *)peerID {
    if (state != MCSessionStateConnecting) {
        [self.connectedDevices removeAllObjects];
        
        if (state == MCSessionStateConnected) {
            for (MCPeerID *peer in session.connectedPeers) {
                [self.connectedDevices addObject:peer.displayName];
            }
        }
        
        [_connectedDevicesTableView reloadData];
    }
}


#pragma mark - Internal Logic


- (void)adjustUIState {
    BOOL isStarted = [[BBSAdvertiser sharedInstance]isStarted];
    
    if (isStarted) {
        _startButton.enabled = NO;
        _stopButton.enabled = YES;
    }
    else {
        _startButton.enabled = YES;
        _stopButton.enabled = NO;
        
        [self.connectedDevices removeAllObjects];
        [_connectedDevicesTableView reloadData];
    }
    
    _statusView.backgroundColor = isStarted ? [UIColor greenColor] : [UIColor clearColor];
}

@end
