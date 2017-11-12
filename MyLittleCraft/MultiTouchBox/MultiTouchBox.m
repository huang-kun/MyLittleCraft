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
@property (nonatomic, strong) UITextView *textView;
@end

@implementation MultiTouchBox

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *debugSwitcher = [[UIBarButtonItem alloc] initWithTitle:@"Debug On" style:UIBarButtonItemStylePlain target:self action:@selector(handleDebugSwitcher:)];
    debugSwitcher.tag = 0;
    self.navigationItem.rightBarButtonItem = debugSwitcher;
    
    _textView = [UITextView new];
    _textView.textColor = UIColor.lightGrayColor;
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.text = [self demoText];
    [self.view addSubview:_textView];
    
    _boxView = [[MYBoxView alloc] initWithFrame:self.view.bounds];
    _boxView.boxColor = UIColor.redColor;
    [self.view addSubview:_boxView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _textView.frame = self.view.bounds;
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

- (NSString *)demoText {
    return @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda. Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
}

@end
