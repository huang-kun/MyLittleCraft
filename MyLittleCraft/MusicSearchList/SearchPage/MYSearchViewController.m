//
//  MYSearchViewController.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/13.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MYSearchViewController.h"
#import "MYSearchContainer.h"
#import "MYMusicSearchConsts.h"
#import "MYSearchBar.h"
#import "UIView+Pin.h"

@interface MYSearchViewController () <MYSearchBarOwnerable>
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@end

@implementation MYSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:_panGesture];
    
    _searchContainer = [MYSearchContainer new];
    [_searchContainer.cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_searchContainer];
    
    _tipLabel = [UILabel new];
    _tipLabel.textColor = UIColor.lightGrayColor;
    _tipLabel.text = @"Slowly drag down to dismiss.";
    [_tipLabel sizeToFit];
    [self.view addSubview:_tipLabel];
    
    UIEdgeInsets searchContainerInsets = UIEdgeInsetsZero;
    searchContainerInsets.top = MY_SEARCH_BAR_TOP_INSET - kMYSearchBarMargin;
    searchContainerInsets.bottom = INFINITY;
    
    [_searchContainer pinEdgesWithInsets:searchContainerInsets];
    [_tipLabel pinCenterWithOffset:(UIOffset){ 0, -80 }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_searchContainer.searchBar becomeFirstResponder];
}

- (void)dismiss {
    if (_searchContainer.searchBar.isFirstResponder) {
        [_searchContainer.searchBar resignFirstResponder];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Target / action

// Drag down to interactively dismiss
- (void)handlePanGesture:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:pan.view];
    CGFloat progress = translation.y / (pan.view.bounds.size.height / 4);
    
    if (progress < 0) {
        progress = 0;
    }
    if (progress > 1) {
        progress = 1;
    }
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            _searchBarDismissalInteractor = [UIPercentDrivenInteractiveTransition new];
            [self dismiss];
            break;
        case UIGestureRecognizerStateChanged:
            [_searchBarDismissalInteractor updateInteractiveTransition:progress];
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            if (progress < 0.25) {
                [_searchBarDismissalInteractor cancelInteractiveTransition];
            } else {
                [_searchBarDismissalInteractor finishInteractiveTransition];
            }
            break;
        default:
            break;
    }
    
}

#pragma mark - MYSearchBarOwnerable

- (MYSearchBar *)searchBar {
    return _searchContainer.searchBar;
}

@end
