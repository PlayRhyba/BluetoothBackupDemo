//
//  BBSClientViewController.m
//  BluetoothBackupDemo
//
//  Created by Alexander Snegursky on 9/9/16.
//  Copyright © 2016 Alexander Snegursky. All rights reserved.
//


#import "BBSClientViewController.h"
#import "BBSBrowser.h"


@interface BBSClientViewController () <UITableViewDataSource, UITableViewDelegate, BBSBrowserDelegate>

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
    
}


- (IBAction)sendBackupButtonClicked:(UIButton *)sender {
    NSInteger number = arc4random_uniform(3);
    NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@(number).stringValue ofType:@"png"];
    
    if (bundlePath) {
        [[BBSBrowser sharedInstance]sendResourceAtURL:[NSURL fileURLWithPath:bundlePath]
                                    completionHandler:^(NSError *error) {
                                        NSLog(@"");
                                    } progressHandler:^(float progress) {
                                        
                                    }];
    }
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


#pragma mark - BBSBrowserDelegate


- (void)browser:(BBSBrowser *)browser
 didChangeState:(MCSessionState)state
        session:(MCSession *)session
           peer:(MCPeerID *)peerID {
    
}


#pragma mark - Internal Logic


- (void)adjustUIState {
    
}

@end
