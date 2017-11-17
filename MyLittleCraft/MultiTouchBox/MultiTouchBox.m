//
//  MultiTouchBox.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/8.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MultiTouchBox.h"
#import "MYBoxView.h"
#import "MYNavigationController.h"

@interface MultiTouchBox () <UINavigationControllerDelegate>
@property (nonatomic, strong) MYBoxView *boxView;
@property (nonatomic, strong) UITextView *textView;
@end

@implementation MultiTouchBox

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    
    UISwitch *switcher = [UISwitch new];
    [switcher addTarget:self action:@selector(handleDebugSwitcher:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:switcher];
    
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

- (void)handleDebugSwitcher:(UISwitch *)sender {
    if (sender.tag == 0) {
        sender.tag = 1;
        _boxView.debug = YES;
    } else {
        sender.tag = 0;
        _boxView.debug = NO;
    }
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(MYNavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isKindOfClass:self.class]) {
        navigationController.my_interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)navigationController:(MYNavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (![viewController isKindOfClass:self.class]) {
        navigationController.my_interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark - Helper

- (NSString *)demoText {
    return @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda. Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
}

@end
