//
//  MYMusicCardTransitionAnimator.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/18.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MYMusicCardTransitionAnimator.h"
#import "UIView+Pin.h"

static CGFloat const kMYMusicCardCornerRadius = 4;

@interface MYMusicCardTransitionAnimator()

@property (nonatomic, assign) CGFloat presentationTopInset;
@property (nonatomic, assign, getter=isAnimating) BOOL animating;

@property (nonatomic, strong) MYArtworkCardView *artworkCardView;
@property (nonatomic, assign) CGRect sourceArtworkCardFrame;
@property (nonatomic, assign) CGRect presentedArtworkCardFrame;

@property (nonatomic, strong) MYMusicBar *musicBar;
@property (nonatomic, strong) UIView *musicBarContainer; // for activate music bar's constraints
@property (nonatomic, assign) CGRect sourceMusicBarFrame;
@property (nonatomic, assign) CGRect presentedMusicBarFrame;

@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) UIVisualEffectView *blurView;
@property (nonatomic, strong) CAShapeLayer *sourceCornerLayer;
@property (nonatomic, strong) CAShapeLayer *presentedCornerLayer;

@property (nonatomic, assign) UIWindow *window;
@property (nonatomic, strong) UIColor *defaultWindowColor;

@end

@implementation MYMusicCardTransitionAnimator

- (instancetype)init {
    self = [super init];
    if (self) {
        _presentationTopInset = 40;
        
        _window = UIApplication.sharedApplication.keyWindow;
        _defaultWindowColor = _window.backgroundColor;

        _artworkCardView = [MYArtworkCardView new];
        _musicBar = [MYMusicBar new];
        
        _musicBarContainer = [UIView new];
        _musicBarContainer.backgroundColor = UIColor.clearColor;
        [_musicBarContainer addSubview:_musicBar];
        [_musicBar pinAllEdges];
        
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
    
    if ([self.delegate respondsToSelector:@selector(musicDetailTransitionAnimatorWillBeginAnimation:)]) {
        [self.delegate musicDetailTransitionAnimatorWillBeginAnimation:self];
    }
    
    CGRect screenBounds = UIScreen.mainScreen.bounds;
    CGRect screenFrameWithTopInset = CGRectOffset(screenBounds, 0, _presentationTopInset);
    CGRect screenFrameWithLargeOffset = CGRectOffset(screenBounds, 0, screenBounds.size.height - _initialPresentationDistanceFromBottom);
    
    UIView *container = transitionContext.containerView;
    
    if (!_dimmingView.superview) {
        _dimmingView.frame = screenBounds;
        [container addSubview:_dimmingView];
    }
    
    // The presented card frame is changing by user scrolling, so it must be re-calculated before both presentation and dismissal.
    _presentedArtworkCardFrame = [_window convertRect:_presentedOwner.artworkCardView.frame
                                             fromView:_presentedOwner.artworkCardView.superview];
    
    // These should only setup in presentation. The source view controller after presentation is applied new scale transform. So the source card frame calculation from dismissal is no longer the same as before.
    if (self.isPresentation) {
        _sourceArtworkCardFrame = [_window convertRect:_sourceOwner.musicBar.artworkCardView.frame
                                              fromView:_sourceOwner.musicBar.artworkCardView.superview];
        
        _sourceMusicBarFrame = [_window convertRect:_sourceOwner.musicBar.frame
                                           fromView:_sourceOwner.musicBar.superview];
        // sync with presentation offset
        _presentedArtworkCardFrame.origin.y += _presentationTopInset;
        
        _presentedMusicBarFrame = screenFrameWithTopInset;
        _presentedMusicBarFrame.size.height = _sourceMusicBarFrame.size.height;
        
        // Add presented view
        [container addSubview:_presentedOwner.view];
    } else {
        _presentedMusicBarFrame = [_window convertRect:_presentedOwner.view.frame fromView:nil];
        _presentedMusicBarFrame.size.height = _sourceMusicBarFrame.size.height;
    }
    
    [container addSubview:_musicBarContainer];
    [container addSubview:_artworkCardView];

    // Transfer image
    _artworkCardView.image = _presentedOwner.artworkCardView.image ?: _sourceOwner.musicBar.artworkCardView.image;
    // Transfer music bar's content
    _musicBar.titleLabel.text = _sourceOwner.musicBar.titleLabel.text;
    
    _musicBar.artworkCardView.hidden = YES;
    _presentedOwner.artworkCardView.hidden = YES;
    _sourceOwner.musicBar.artworkCardView.hidden = YES;
    
    if (self.isPresentation) {
        _window.backgroundColor = UIColor.clearColor;
        _dimmingView.alpha = 0;
        _musicBarContainer.frame = _sourceMusicBarFrame;
        [_musicBarContainer layoutIfNeeded];
        
        _artworkCardView.frame = _sourceArtworkCardFrame;
        _presentedOwner.view.frame = screenFrameWithLargeOffset;
        _sourceOwner.view.layer.mask = _sourceCornerLayer;
        _presentedOwner.view.layer.mask = _presentedCornerLayer;
        
        _musicBar.backgroundColor = UIColor.whiteColor;
//        _presentedOwner.view.backgroundColor = UIColor.clearColor;
    } else {
        _musicBar.alpha = 0;
        _musicBarContainer.frame = _presentedMusicBarFrame;
        _artworkCardView.frame = _presentedArtworkCardFrame;
        _sourceOwner.view.layer.mask = nil;
//        _presentedOwner.view.backgroundColor = UIColor.whiteColor;
        _musicBar.backgroundColor = UIColor.clearColor;
    }
    
    _animating = YES;
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:duration / 4 delay:(self.isPresentation ? 0 : duration / 2) usingSpringWithDamping:1 initialSpringVelocity:0.7 options:0 animations:^{
        
        if (self.isPresentation) {
            self.musicBar.alpha = 0;
        } else {
            self.musicBar.alpha = 1;
        }
        
    } completion:nil];
    
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.7 options:0 animations:^{
        
        if (self.isPresentation) {
            self.dimmingView.alpha = 0.4;
            self.musicBarContainer.frame = _presentedMusicBarFrame;
            self.artworkCardView.frame = _presentedArtworkCardFrame;
            self.presentedOwner.view.frame = screenFrameWithTopInset;
            self.sourceOwner.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
//            self.presentedOwner.view.backgroundColor = UIColor.whiteColor;
        } else {
            self.dimmingView.alpha = 0;
            self.musicBarContainer.frame = _sourceMusicBarFrame;
            self.presentedOwner.view.frame = screenFrameWithLargeOffset;
            self.artworkCardView.frame = _sourceArtworkCardFrame;
            self.sourceOwner.view.transform = CGAffineTransformIdentity;
//            self.presentedOwner.view.backgroundColor = UIColor.clearColor;
        }
        
    } completion:^(BOOL finished) {
        
        self.animating = NO;
        
        self.sourceOwner.musicBar.artworkCardView.hidden = NO;
        self.presentedOwner.artworkCardView.hidden = NO;
        
        [self.musicBarContainer removeFromSuperview];
        [self.artworkCardView removeFromSuperview];
        
        if (!self.isPresentation) {
            [self.dimmingView removeFromSuperview];
            self.window.backgroundColor = self.defaultWindowColor;
            self.presentedOwner.view.layer.mask = nil;
        }
        
        BOOL completed = !transitionContext.transitionWasCancelled;
        
        [transitionContext completeTransition:completed];
        
        if (completed) {
            if ([self.delegate respondsToSelector:@selector(musicDetailTransitionAnimatorDidCompleteAnimation:)]) {
                [self.delegate musicDetailTransitionAnimatorDidCompleteAnimation:self];
            }
        }
    }];
}

@end
