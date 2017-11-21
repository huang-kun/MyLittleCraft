//
//  MYMusicDetailTransitionAnimator.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/18.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MYMusicDetailTransitionAnimator.h"

static CGFloat const kMYMusicCardCornerRadius = 8;

@interface MYMusicDetailTransitionAnimator()

@property (nonatomic, assign) CGFloat presentationTopInset;
@property (nonatomic, assign, getter=isAnimating) BOOL animating;

@property (nonatomic, assign) CGRect sourceArtworkCardFrame;
@property (nonatomic, assign) CGRect presentedArtworkCardFrame;

@property (nonatomic, strong) MYArtworkCardView *artworkCardView;
@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) CAShapeLayer *sourceCornerLayer;
@property (nonatomic, strong) CAShapeLayer *presentedCornerLayer;

@property (nonatomic, assign) UIWindow *window;
@property (nonatomic, strong) UIColor *defaultWindowColor;

@end

@implementation MYMusicDetailTransitionAnimator

- (instancetype)init {
    self = [super init];
    if (self) {
        _presentationTopInset = 40;
        
        _window = UIApplication.sharedApplication.keyWindow;
        _defaultWindowColor = _window.backgroundColor;

        _artworkCardView = [MYArtworkCardView new];
        
        _dimmingView = [UIView new];
        _dimmingView.backgroundColor = UIColor.blackColor;
        
        _sourceCornerLayer = [CAShapeLayer new];
        _presentedCornerLayer = [CAShapeLayer new];
        
        // Apply rounded corner effect like card edges
        CGRect halfCorneredRect = UIScreen.mainScreen.bounds;
        halfCorneredRect.size.height = 9999;
        
        CGSize radii = CGSizeMake(kMYMusicCardCornerRadius, kMYMusicCardCornerRadius);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:halfCorneredRect
                                                   byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                         cornerRadii:radii];
        _sourceCornerLayer.path = path.CGPath;
        _presentedCornerLayer.path = path.CGPath;
        
        // Add tap gesture at background
        _backgroundTapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
        [_dimmingView addGestureRecognizer:_backgroundTapGestureRecognizer];
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    CGRect screenBounds = UIScreen.mainScreen.bounds;
    CGRect offsetScreenFrame = CGRectOffset(screenBounds, 0, _presentationTopInset);
    CGRect underScreenFrame = CGRectOffset(screenBounds, 0, screenBounds.size.height);
    
    UIView *container = transitionContext.containerView;
    
    if (!_dimmingView.superview) {
        _dimmingView.frame = screenBounds;
        [container addSubview:_dimmingView];
    }
    
    // The presented card frame is changing by user scrolling, so it must be re-calculated before both presentation and dismissal.
    _presentedArtworkCardFrame = [_window convertRect:_presentedOwner.artworkCardView.frame
                                             fromView:_presentedOwner.artworkCardView.superview];
    
    // These should only setup in presentation. The source view controller after presentation is applied new scale transform. So the source card frame calculation from dismissal is no longer the same as before.
    if (self.isPresenting) {
        _sourceArtworkCardFrame = [_window convertRect:_sourceOwner.artworkCardView.frame
                                              fromView:_sourceOwner.artworkCardView.superview];
        // sync with presentation offset
        _presentedArtworkCardFrame.origin.y += _presentationTopInset;
        // Add presented view
        [container addSubview:_presentedOwner.view];
    }
    
    [container addSubview:_artworkCardView];

    // Transfer image
    _artworkCardView.image = _presentedOwner.artworkCardView.image ?: _sourceOwner.artworkCardView.image;
    
    _sourceOwner.artworkCardView.hidden = YES;
    _presentedOwner.artworkCardView.hidden = YES;
    
    if (self.isPresenting) {
        _window.backgroundColor = UIColor.clearColor;
        _dimmingView.alpha = 0;
        _presentedOwner.view.frame = underScreenFrame;
        _artworkCardView.frame = _sourceArtworkCardFrame;
        _sourceOwner.view.layer.mask = _sourceCornerLayer;
        _presentedOwner.view.layer.mask = _presentedCornerLayer;
    } else {
        _artworkCardView.frame = _presentedArtworkCardFrame;
        _sourceOwner.view.layer.mask = nil;
    }
    
    _animating = YES;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.7 options:0 animations:^{
        
        if (self.isPresenting) {
            self.dimmingView.alpha = 0.4;
            self.presentedOwner.view.frame = offsetScreenFrame;
            self.artworkCardView.frame = _presentedArtworkCardFrame;
            self.sourceOwner.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } else {
            self.dimmingView.alpha = 0;
            self.presentedOwner.view.frame = underScreenFrame;
            self.artworkCardView.frame = _sourceArtworkCardFrame;
            self.sourceOwner.view.transform = CGAffineTransformIdentity;
        }
        
    } completion:^(BOOL finished) {
        
        self.animating = NO;
        
        self.sourceOwner.artworkCardView.hidden = NO;
        self.presentedOwner.artworkCardView.hidden = NO;
        [self.artworkCardView removeFromSuperview];
        
        if (!self.isPresenting) {
            [self.dimmingView removeFromSuperview];
            self.window.backgroundColor = self.defaultWindowColor;
            self.presentedOwner.view.layer.mask = nil;
        }
        
        [transitionContext completeTransition:YES];
    }];
}

@end
