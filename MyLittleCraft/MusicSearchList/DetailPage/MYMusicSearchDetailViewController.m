//
//  MYMusicSearchDetailViewController.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/23.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MYMusicSearchDetailViewController.h"
#import "MYMusicSearchConsts.h"
#import "MYTitleLabelOwnerable.h"

@interface MYMusicSearchDetailViewController () <MYTitleLabelOwnerable>

@end

@implementation MYMusicSearchDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

#pragma mark - MYTitleLabelOwnerable

- (UILabel *)titleLabel {
    return nil;
}

@end
