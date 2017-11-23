//
//  MYSearchViewController.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/13.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MYSearchViewController.h"
#import "MYSearchContainer.h"
#import "MYSearchConsts.h"
#import "MYSearchBar.h"
#import "UIView+Pin.h"

@interface MYSearchViewController () <MYSearchBarOwnerable>
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
    
    UIEdgeInsets searchContainerInsets = UIEdgeInsetsZero;
    searchContainerInsets.top = MY_SEARCH_BAR_TOP_INSET - kMYSearchBarMargin;
    searchContainerInsets.bottom = INFINITY;
    
    [_searchContainer pinEdgesWithInsets:searchContainerInsets];
    [_tipLabel pinCenter];
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
