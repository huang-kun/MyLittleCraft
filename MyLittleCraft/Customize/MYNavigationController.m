//
//  MYNavigationController.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/17.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MYNavigationController.h"

@interface MYNavigationController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) MYFullScreenPanGestureRecognizer *my_interactivePopGestureRecognizer;
@property (nonatomic, strong) id defaultPopGestureTarget;
@property (nonatomic, assign) SEL defaultPopGestureAction;
@end

@implementation MYNavigationController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Disable system default pop gesture
    self.interactivePopGestureRecognizer.enabled = NO;
    
    // Retrieve the default pop gesture target and handling action
    _defaultPopGestureTarget = self.interactivePopGestureRecognizer.delegate;
    _defaultPopGestureAction = NSSelectorFromString(@"handleNavigationTransition:");
    
    // Add custom pop gesture
    self.my_interactivePopGestureRecognizer = [[MYFullScreenPanGestureRecognizer alloc] initWithTarget:_defaultPopGestureTarget action:_defaultPopGestureAction];
    self.my_interactivePopGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.my_interactivePopGestureRecognizer];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.viewControllers.count > 1;
}

#pragma mark - Public

- (void)replacePopGestureTarget:(id)target action:(SEL)action {
    // remove all target and actions
    [self.my_interactivePopGestureRecognizer removeTarget:nil
                                                   action:nil];
    // add new target and action
    [self.my_interactivePopGestureRecognizer addTarget:target
                                                action:action];
}

- (void)resetPopGestureDefaultTargetWithAction {
    // remove all target and actions
    [self.my_interactivePopGestureRecognizer removeTarget:nil
                                                   action:nil];
    // add default target and action
    [self.my_interactivePopGestureRecognizer addTarget:_defaultPopGestureTarget
                                                action:_defaultPopGestureAction];
}

@end
