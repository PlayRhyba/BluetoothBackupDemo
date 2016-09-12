//
//  BBSPreviewViewController.m
//  BluetoothBackupDemo
//
//  Created by Alexander Snigurskyi on 2016-09-12.
//  Copyright © 2016 Alexander Snegursky. All rights reserved.
//


#import "BBSPreviewViewController.h"


@interface BBSPreviewViewController ()

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

- (void)dismiss;

@end


@implementation BBSPreviewViewController


#pragma mark - Lifecycle Methods


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _nameLabel.text = _name;
    
    NSData *data = [[NSData alloc]initWithContentsOfURL:_url];
    _imageView.image = [UIImage imageWithData:data];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                   action:@selector(dismiss)];
    [_imageView addGestureRecognizer:tapRecognizer];
}


#pragma mark - Internal Logic


- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
