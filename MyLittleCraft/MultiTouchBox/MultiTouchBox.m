//
//  MultiTouchBox.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/8.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MultiTouchBox.h"
#import "MYBoxView.h"

@interface MultiTouchBox ()
@property (nonatomic, strong) MYBoxView *boxView;
@end

@implementation MultiTouchBox

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *debugSwitcher = [[UIBarButtonItem alloc] initWithTitle:@"Debug On" style:UIBarButtonItemStylePlain target:self action:@selector(handleDebugSwitcher:)];
    debugSwitcher.tag = 0;
    self.navigationItem.rightBarButtonItem = debugSwitcher;
    
    _boxView = [[MYBoxView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_boxView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _boxView.frame = self.view.bounds;
    [_boxView resetBoxFrame];
}

- (void)handleDebugSwitcher:(UIBarButtonItem *)sender {
    if (sender.tag == 0) {
        sender.tag = 1;
        sender.title = @"Debug Off";
        _boxView.debug = YES;
    } else {
        sender.tag = 0;
        sender.title = @"Debug On";
        _boxView.debug = NO;
    }
}

@end
