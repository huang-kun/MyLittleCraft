//
//  MYMusicDetailTransitionAnimator.h
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/18.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYArtworkCardView.h"
#import "MYMusicBar.h"

@class MYMusicDetailTransitionAnimator;

/**
 
 If you call -[UIViewController presentViewController:animated:completion:],
 the source vc will not get -[UIViewController viewWillDisappear:] callback,
 because the root view of source vc is not removed from view hierarchy.
 
 Using MYMusicDetailTransitionAnimatorDelegate can track the presenting
 animation state if needed.
 
 */
@protocol MYMusicDetailTransitionAnimatorDelegate <NSObject>
@optional
- (void)musicDetailTransitionAnimatorWillBeginAnimation:(MYMusicDetailTransitionAnimator *)animator;
- (void)musicDetailTransitionAnimatorDidCompleteAnimation:(MYMusicDetailTransitionAnimator *)animator;
@end


@interface MYMusicDetailTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign, getter=isPresentation) BOOL presentation;
@property (nonatomic, readonly, getter=isAnimating) BOOL animating;

@property (nonatomic, weak) id <MYMusicBarOwnerable> sourceOwner;
@property (nonatomic, weak) id <MYArtworkCardOwnerable> presentedOwner;
@property (nonatomic, weak) id <MYMusicDetailTransitionAnimatorDelegate> delegate;

/// The initial vertical distance from screen bottom for starting presentation.
@property (nonatomic, assign) CGFloat initialPresentationDistanceFromBottom;

/// The tap gesture is added to background of presented view, without any target and action.
@property (nonatomic, readonly, strong) UITapGestureRecognizer *backgroundTapGestureRecognizer;

@end
