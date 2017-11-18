//
//  MYSearchViewController.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/13.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MYSearchViewController.h"
#import "MYSearchContainer.h"
#import "UIView+Pin.h"

@interface MYSearchViewController ()

@end

@implementation MYSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    _searchContainer = [MYSearchContainer new];
    [_searchContainer.cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_searchContainer];
    
    _tipLabel = [UILabel new];
    _tipLabel.textColor = UIColor.lightGrayColor;
    _tipLabel.text = @"Just a demo.";
    [_tipLabel sizeToFit];
    [self.view addSubview:_tipLabel];
    
    [_searchContainer pinEdgesToSuperviewWithInsets:(UIEdgeInsets){ 0, 0, INFINITY, 0 }];
    [_tipLabel pinCenterToSuperview];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_searchContainer.searchBar becomeFirstResponder];
}

- (void)cancel:(UIButton *)sender {
    if (_searchContainer.searchBar.isFirstResponder) {
        [_searchContainer.searchBar resignFirstResponder];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MYSearchBarOwnerable

- (MYSearchBar *)searchBar {
    return _searchContainer.searchBar;
}

@end
