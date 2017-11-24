//
//  MYMusicTitleTransitionAnimator.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/23.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MYMusicTitleTransitionAnimator.h"
#import "MYTitleLabelOwnerable.h"
#import "MYTintLabel.h"

@interface MYMusicTitleTransitionAnimator ()
@property (nonatomic, strong) MYTintLabel *titleLabel;
@property (nonatomic, assign) UIWindow *window;
@property (nonatomic, assign, getter=isSourceTitleBold) BOOL sourceTitleBold;
@end

@implementation MYMusicTitleTransitionAnimator

- (instancetype)init {
    self = [super init];
    if (self) {
        _window = UIApplication.sharedApplication.keyWindow;
    }
    return self;
}

- (void)setSourceOwner:(id<MYTitleLabelOwnerable>)sourceOwner {
    _sourceOwner = sourceOwner;
    
    // Make a copy of title label
    NSData *labelData = [NSKeyedArchiver archivedDataWithRootObject:sourceOwner.titleLabel];
    _titleLabel = [NSKeyedUnarchiver unarchiveObjectWithData:labelData];
    
    if (_titleLabel.font.fontDescriptor.symbolicTraits & UIFontDescriptorTraitBold) {
        _sourceTitleBold = YES;
    }
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    
    // Calculation
    CGRect screenBounds = UIScreen.mainScreen.bounds;
    CGRect sourceOffsetFrame = CGRectOffset(screenBounds, -90, 0);
    CGRect presentedOffScreenFrame = CGRectOffset(screenBounds, screenBounds.size.width, 0);
    
    if (self.isPresentation) {
        [_presentedOwner.view layoutIfNeeded];
    }
    
    // View heirarchy
    UIView *container = transitionContext.containerView;
    
    if (self.isPresentation) {
        [container addSubview:_presentedOwner.view];
    } else {
        [container insertSubview:_sourceOwner.view atIndex:0];
    }
    
    // Navigation Animation
    if (self.isPresentation) {
        _presentedOwner.view.frame = presentedOffScreenFrame;
    } else {
        _sourceOwner.view.frame = sourceOffsetFrame;
    }
    
    // Additional custom animation
    if (!_onlyDriveNavigationTransition) {
        // Add title label on window, not container. Otherwise title label will animate below navigation bar.
        [_window addSubview:_titleLabel];
        
        _sourceOwner.titleLabel.hidden = YES;
        _presentedOwner.titleLabel.hidden = YES;
        
        if (self.isPresentation) {
            _titleLabel.transform = CGAffineTransformIdentity;
            [self applyTitleEffectFromLabel:_sourceOwner.titleLabel];
        } else {
            [self applyTitleEffectFromLabel:_presentedOwner.titleLabel];
        }
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.7 options:0 animations:^{
        
        // Navigation Animation
        if (self.isPresentation) {
            _sourceOwner.view.frame = sourceOffsetFrame;
            _presentedOwner.view.frame = screenBounds;
        } else {
            _sourceOwner.view.frame = screenBounds;
            _presentedOwner.view.frame = presentedOffScreenFrame;
        }
        
        // Additional custom animation
        if (!_onlyDriveNavigationTransition) {
            if (self.isPresentation) {
                
                CGFloat scaleX = _presentedOwner.titleLabel.frame.size.width / _titleLabel.frame.size.width;
                CGFloat scaleY = _presentedOwner.titleLabel.frame.size.height / _titleLabel.frame.size.height;
                
                _titleLabel.transform = CGAffineTransformMakeScale(scaleX, scaleY);
                [self applyTitleEffectFromLabel:_presentedOwner.titleLabel];
            } else {
                _titleLabel.transform = CGAffineTransformIdentity;
                [self applyTitleEffectFromLabel:_sourceOwner.titleLabel];
            }
        }
        
    } completion:^(BOOL finished) {
        BOOL completed = !transitionContext.transitionWasCancelled;
        
        if (completed && !_onlyDriveNavigationTransition) {
            _sourceOwner.titleLabel.hidden = NO;
            _presentedOwner.titleLabel.hidden = NO;
            [_titleLabel removeFromSuperview];
        }
        
        [transitionContext completeTransition:completed];
    }];
}

- (void)applyTitleEffectFromLabel:(MYTintLabel *)label {
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    CGPoint center = [window convertPoint:label.center fromView:label.superview];
    
    _titleLabel.text = label.text;
    _titleLabel.center = center;
    _titleLabel.tintColor = label.tintColor;
}

@end
