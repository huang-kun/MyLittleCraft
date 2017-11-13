//
//  SwipeToDismissKeyboard.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/13.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "SwipeToDismissKeyboard.h"

@interface SwipeToDismissKeyboard () <UIScrollViewDelegate>
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView *backgroundView; // for shadow effect
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UISwitch *switcher;
@property (nonatomic, assign) BOOL didSetupFrame;
@property (nonatomic, assign) BOOL fixed;
@end

@implementation SwipeToDismissKeyboard

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollView = [UIScrollView new];
    _scrollView.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1];
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    _backgroundView = [UIView new];
    _backgroundView.layer.cornerRadius = 6;
    _backgroundView.layer.shadowColor = UIColor.lightGrayColor.CGColor;
    _backgroundView.layer.shadowOffset = CGSizeMake(0, 3);
    _backgroundView.layer.shadowOpacity = 0.3;
    _backgroundView.layer.shadowRadius = 6;
    _backgroundView.clipsToBounds = NO;
    [_scrollView addSubview:_backgroundView];
    
    _textView = [UITextView new];
    _textView.backgroundColor = UIColor.whiteColor;
    _textView.font = [UIFont systemFontOfSize:17];
    _textView.textColor = UIColor.darkTextColor;
    _textView.text = [self tips];
    _textView.layer.cornerRadius = 6;
    _textView.clipsToBounds = YES;
    [_backgroundView addSubview:_textView];
    
    _switcher = [UISwitch new];
    [_switcher addTarget:self action:@selector(handleSwitcher:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *switchBarButton = [[UIBarButtonItem alloc] initWithCustomView:_switcher];
    self.navigationItem.rightBarButtonItem = switchBarButton;
    
    self.fixed = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self setupFrames];
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    [self setupFrames];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_textView becomeFirstResponder];
}

- (void)setupFrames {
    if (_didSetupFrame) {
        return;
    }
    _didSetupFrame = YES;
    
    // Manual adjustment
    [self adjustTopHeight];
    
    // Layout scroll view
    _scrollView.frame = self.view.bounds;
    
    // Layout text view
    CGRect textViewFrame;
    textViewFrame.origin.x = 20;
    textViewFrame.origin.y = 20;
    textViewFrame.size.width = _scrollView.frame.size.width - 40;
    textViewFrame.size.height = _scrollView.bounds.size.height / 2;
    
    _backgroundView.frame = textViewFrame;
    _textView.frame = _backgroundView.bounds;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_fixed && scrollView == _scrollView) {
        CGFloat offsetY = scrollView.contentOffset.y;
        _textView.transform = CGAffineTransformMakeTranslation(0, offsetY);
    }

    if (_textView.isFirstResponder) {
        [_textView resignFirstResponder];
    }
}

#pragma mark - Target / Action

- (void)handleSwitcher:(UISwitch *)sender {
    if (sender.tag == 0) {
        sender.tag = 1;
        self.fixed = NO;
    } else {
        sender.tag = 0;
        self.fixed = YES;
    }
}

#pragma mark - Helper

- (void)adjustTopHeight {
    if (@available(iOS 11, *)) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    CGFloat topHeight = 0;
    topHeight += UIApplication.sharedApplication.statusBarFrame.size.height;
    topHeight += self.navigationController.navigationBar.frame.size.height;
    
    UIEdgeInsets insets = UIEdgeInsetsZero;
    insets.top = topHeight;
    
    _scrollView.contentInset = insets;
}

- (NSString *)tips {
    return @"Swipe up or down on text view to dismiss keyboard. \n\nYou can toggle switcher in the navigation bar to determine whether text view should respond your scrolling movement.";
}

@end
