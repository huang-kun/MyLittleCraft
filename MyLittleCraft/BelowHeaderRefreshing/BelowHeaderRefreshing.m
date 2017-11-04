//
//  BelowHeaderRefreshing.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/4.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "BelowHeaderRefreshing.h"
#import <MJRefresh/MJRefresh.h>

static NSString *const kBelowHeaderRefreshingCellReuseId = @"kBelowHeaderRefreshingCellReuseId";

@interface BelowHeaderRefreshing () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableHeaderContainerView;
@property (nonatomic, strong) UIView *tableHeaderContentView;
@property (nonatomic, strong) UIView *refreshContainerView;
@property (nonatomic, assign) CGFloat topInset;
@property (nonatomic, assign) BOOL didSetupMainFrames;
@end

@implementation BelowHeaderRefreshing

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSStringFromClass(self.class);
    
    // Setup Table View
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView registerClass:UITableViewCell.class  forCellReuseIdentifier:kBelowHeaderRefreshingCellReuseId];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    // Setup Table Header
    UIColor *lavenderBlushColor = [UIColor colorWithRed:255.0/255.0 green:240.0/255.0 blue:245.0/255.0 alpha:1];
    UIColor *lightSkyBlueColor = [UIColor colorWithRed:135.0/255.0 green:206.0/255.0 blue:250.0/255.0 alpha:1];

    _tableHeaderContainerView = [UIView new];
    _tableHeaderContainerView.backgroundColor = lavenderBlushColor;
    _tableView.tableHeaderView = _tableHeaderContainerView;
    
    _tableHeaderContentView = [UIView new];
    _tableHeaderContentView.backgroundColor = lightSkyBlueColor;
    [_tableHeaderContainerView addSubview:_tableHeaderContentView];
    
    // Setup MJ Header Refresh (Great 3rd-party refresh control)
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(handleHeaderRefresh)];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.hidden = YES;
    _tableView.mj_header = refreshHeader;
    
    // Tricks:
    // 1. Hack to view hierarchy and transfer all view components from mj_header to refreshContainerView
    // 2. Add refreshContainerView to tableHeaderContainerView, below tableHeaderContentView, so it will hide in between.
    // 3. Position refreshContainerView to the bottom of tableHeaderContainerView, when user pulling down the table, the refresh control will reveal below table header.
    
    _refreshContainerView = [[UIView alloc] initWithFrame:_tableView.mj_header.bounds];
    for (UIView *component in _tableView.mj_header.subviews) {
        [_refreshContainerView addSubview:component];
    }
    [_tableHeaderContainerView insertSubview:_refreshContainerView atIndex:0];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Use this flag to prevent multiple times setup by user scrolling.
    // If using Auto-layout instead, all manual layout code from here can be removed.
    if (!_didSetupMainFrames) {
        
        // Layout Table View
        CGRect bounds = self.view.bounds;
        _tableView.frame = bounds;
        
        // Layout Table Header
        CGRect headerFrame = (CGRect){ 0, 0, bounds.size.width, 200 };
        _tableHeaderContainerView.frame = headerFrame;
        _tableHeaderContentView.frame = headerFrame;
        
        // Layout Refresh control
        CGRect refresherFrame = _refreshContainerView.frame;
        refresherFrame.origin.y = _tableHeaderContainerView.frame.size.height - refresherFrame.size.height;
        refresherFrame.origin.x = _tableHeaderContainerView.frame.size.width / 2 - refresherFrame.size.width / 2;
        _refreshContainerView.frame = refresherFrame;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _didSetupMainFrames = YES;
    
    // If we have navigation bar, then we need topInset
    if (self.navigationController) {
        CGFloat statusBarHeight = UIApplication.sharedApplication.statusBarFrame.size.height;
        CGFloat navBarHeight = self.navigationController.navigationBar.bounds.size.height;
        _topInset = statusBarHeight + navBarHeight;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBelowHeaderRefreshingCellReuseId forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"Cell Item: %@", @(indexPath.row)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat inset = -self.topInset;
    _tableHeaderContentView.transform = CGAffineTransformMakeTranslation(0, MIN(offsetY, inset));
}

#pragma mark - Target Actions

- (void)handleHeaderRefresh {
    [self.tableView.mj_header beginRefreshing];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
}

@end
