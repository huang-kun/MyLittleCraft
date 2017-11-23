//
//  MYMusicDetailTransitionAnimator.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/23.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MYMusicDetailTransitionAnimator.h"
#import "MYTitleLabelOwnerable.h"

@interface MYMusicDetailTransitionAnimator ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation MYMusicDetailTransitionAnimator

- (instancetype)init {
    self = [super init];
    if (self) {
        _titleLabel = [UILabel new];
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    
    CGRect screenBounds = UIScreen.mainScreen.bounds;
    CGRect sourceOffsetFrame = CGRectOffset(screenBounds, -90, 0);
    CGRect presentedOffScreenFrame = CGRectOffset(screenBounds, screenBounds.size.width, 0);
    
    UIView *container = transitionContext.containerView;
    
    if (self.isPresentation) {
        [container addSubview:_presentedOwner.view];
    } else {
        [container insertSubview:_sourceOwner.view atIndex:0];
    }
    
    // Animation
    if (self.isPresentation) {
        self.presentedOwner.view.frame = presentedOffScreenFrame;
    } else {
        self.sourceOwner.view.frame = sourceOffsetFrame;
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.7 options:0 animations:^{
        
        if (self.isPresentation) {
            self.sourceOwner.view.frame = sourceOffsetFrame;
            self.presentedOwner.view.frame = screenBounds;
        } else {
            self.sourceOwner.view.frame = screenBounds;
            self.presentedOwner.view.frame = presentedOffScreenFrame;
        }
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

@end
