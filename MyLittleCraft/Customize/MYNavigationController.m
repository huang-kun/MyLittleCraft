//
//  MYNavigationController.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/17.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MYNavigationController.h"

@interface MYNavigationController () <UIGestureRecognizerDelegate>
@property (nonatomic, readwrite, strong) MYFullScreenPanGestureRecognizer *my_interactivePopGestureRecognizer;
@end

@implementation MYNavigationController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Disable system default pop gesture
    self.interactivePopGestureRecognizer.enabled = NO;
    
    // Retrieve the default pop gesture target and handling action
    id defaultTarget = self.interactivePopGestureRecognizer.delegate;
    SEL defaultAction = NSSelectorFromString(@"handleNavigationTransition:");
    
    // Add custom pop gesture
    self.my_interactivePopGestureRecognizer = [[MYFullScreenPanGestureRecognizer alloc] initWithTarget:defaultTarget action:defaultAction];
    self.my_interactivePopGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.my_interactivePopGestureRecognizer];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.viewControllers.count > 1;
}

@end
