//
//  BBSServerViewController.m
//  BluetoothBackupDemo
//
//  Created by Alexander Snegursky on 9/9/16.
//  Copyright © 2016 Alexander Snegursky. All rights reserved.
//


#import "BBSServerViewController.h"


@interface BBSServerViewController ()

@property (nonatomic, weak) IBOutlet UIView *statusView;
@property (nonatomic, weak) IBOutlet UIButton *startButton;
@property (nonatomic, weak) IBOutlet UIButton *stopButton;

- (IBAction)startButtonClicked:(UIButton *)sender;
- (IBAction)stopButtonClicked:(UIButton *)sender;
- (void)adjustUIState;

@end


@implementation BBSServerViewController


#pragma mark - Lifecycle Methods


- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self adjustUIState];
}


#pragma mark - IBAction


- (IBAction)startButtonClicked:(UIButton *)sender {
    
}


- (IBAction)stopButtonClicked:(UIButton *)sender {
    
}


#pragma mark - Internal Logic


- (void)adjustUIState {
    
}

@end
