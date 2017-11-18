//
//  MYSearchTransitionAnimator.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/15.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MYSearchTransitionAnimator.h"

@interface MYSearchTransitionAnimator()
@property (nonatomic, strong) MYSearchBar *searchBar;
@property (nonatomic, strong) UIView *sourceCoverView;
@property (nonatomic, strong) UIView *presentedCoverView;
@property (nonatomic, assign) NSTimeInterval normalTransitioningDuration;
@property (nonatomic, assign) NSTimeInterval additionalTransitioningDuration;
@end

@implementation MYSearchTransitionAnimator

#pragma mark -

- (instancetype)init {
    self = [super init];
    if (self) {
        _searchBar = [MYSearchBar new];
        _normalTransitioningDuration = 0.5;
        _additionalTransitioningDuration = 0.2;
        
        _sourceCoverView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
        _sourceCoverView.backgroundColor = UIColor.whiteColor;
        
        _presentedCoverView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
        _presentedCoverView.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    if (self.isPresenting) {
        return _normalTransitioningDuration + _additionalTransitioningDuration;
    }
    return _normalTransitioningDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *container = transitionContext.containerView;
    
    // Note:
    // 1. When presenting happens, UITransitionContextFromViewControllerKey is not sourceOwner, it's a navigation controller.
    // 2. Don't add fromView to containerView, otherwise fromView will be out of original view hierarchy.
    
    [_sourceOwner.view addSubview:_sourceCoverView];
    [_presentedOwner.view addSubview:_presentedCoverView];
    
    if (self.isPresenting) {
        [container addSubview:_presentedOwner.view];
    }
    
    [container addSubview:_searchBar];
    
    // Calculation
    CGRect screenBounds = UIScreen.mainScreen.bounds;
    CGRect offScreenFrame = CGRectOffset(screenBounds, screenBounds.size.width, 0);
    
    CGRect sourceSearchBarFrame = [_sourceOwner.view convertRect:_sourceOwner.searchBar.frame
                                                        fromView:_sourceOwner.searchBar.superview];
    
    CGRect presentedSearchBarFrame = [_presentedOwner.view convertRect:_presentedOwner.searchBar.frame
                                                              fromView:_presentedOwner.searchBar.superview];
    
    // Animation
    _sourceOwner.searchBar.hidden = YES;
    _presentedOwner.searchBar.hidden = YES;
    
    if (self.isPresenting) {
        _searchBar.frame = sourceSearchBarFrame;
        _presentedOwner.view.frame = offScreenFrame;
        
        _searchBar.alpha = 1;
        _sourceCoverView.alpha = 0;
        _presentedCoverView.alpha = 1;
    }
    // Dismiss
    else {
        _searchBar.frame = presentedSearchBarFrame;
        _presentedOwner.view.frame = offScreenFrame;
        
        _searchBar.alpha = 1;
        _sourceCoverView.alpha = 1;
    }
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:(self.isPresenting ? _normalTransitioningDuration : duration) delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.8 options:0 animations:^{
        
        if (self.isPresenting) {
            self.searchBar.frame = presentedSearchBarFrame;
            self.sourceCoverView.alpha = 1;
        } else {
            self.searchBar.frame = sourceSearchBarFrame;
            self.sourceCoverView.alpha = 0;
        }
        
    } completion:^(BOOL finished) {
        
        if (self.isPresenting) {
            self.presentedOwner.view.frame = [transitionContext finalFrameForViewController:(id)_presentedOwner];
            self.presentedCoverView.alpha = 1;

            [UIView animateWithDuration:self.additionalTransitioningDuration delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.5 options:0 animations:^{
                self.presentedCoverView.alpha = 0;
            } completion:^(BOOL finished) {
                [self completeTransition:transitionContext];
            }];
            
        } else {
            [self completeTransition:transitionContext];
        }
        
    }];
    
}

- (void)completeTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    self.sourceOwner.searchBar.hidden = NO;
    self.presentedOwner.searchBar.hidden = NO;
    [self.searchBar removeFromSuperview];
    [self.sourceCoverView removeFromSuperview];
    [self.presentedCoverView removeFromSuperview];
    [transitionContext completeTransition:YES];
}

@end
