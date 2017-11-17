//
//  MYSearchTransitionAnimator.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/15.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MYSearchTransitionAnimator.h"
#import "MYSearchBar.h"

@interface MYSearchTransitionAnimator()
@end

@implementation MYSearchTransitionAnimator

#pragma mark -

- (instancetype)init {
    self = [super init];
    if (self) {
        _backgroundView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
        _backgroundView.backgroundColor = UIColor.whiteColor;
        
        _searchBar = [MYSearchBar new];
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *container = transitionContext.containerView;
    
    // Final state
    // Present
    if (_presenting) {
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
        toVC.view.frame = finalFrame;
        
        [container addSubview:toVC.view];
    }
    // Dismiss
    else {
        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        CGRect finalFrame = [transitionContext finalFrameForViewController:fromVC];
        fromVC.view.frame = finalFrame;
        
        if ([container.subviews containsObject:fromVC.view]) {
            fromVC.view.hidden = YES;
        }
    }
    
    [container addSubview:_backgroundView];
    [_backgroundView addSubview:_searchBar];
    
    // Animation
    _searchBar.frame = _searchBarInitialFrame;
    _searchBar.alpha = 1.0;
    _backgroundView.alpha = 1.0;
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    NSTimeInterval percent = 0.7;
    UIViewKeyframeAnimationOptions options = UIViewKeyframeAnimationOptionCalculationModeLinear;
    
    [UIView animateKeyframesWithDuration:duration delay:0 options:options animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:percent animations:^{
            _searchBar.frame = _searchBarFinalFrame;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:percent relativeDuration:(1 - percent) animations:^{
            _searchBar.alpha = 0.0;
            _backgroundView.alpha = 0.0;
        }];
        
    } completion:^(BOOL finished) {
        [_searchBar removeFromSuperview];
        [_backgroundView removeFromSuperview];
        [transitionContext completeTransition:finished];
    }];
}

@end
