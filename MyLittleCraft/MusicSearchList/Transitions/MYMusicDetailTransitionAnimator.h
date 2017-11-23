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

@interface MYMusicDetailTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign, getter=isPresentation) BOOL presentation;
@property (nonatomic, readonly, getter=isAnimating) BOOL animating;

@property (nonatomic, weak) id <MYMusicBarOwnerable> sourceOwner;
@property (nonatomic, weak) id <MYArtworkCardOwnerable> presentedOwner;

/// The initial vertical distance from screen bottom for starting presentation.
@property (nonatomic, assign) CGFloat initialPresentationDistanceFromBottom;

/// The tap gesture is added to background of presented view, without any target and action.
@property (nonatomic, readonly, strong) UITapGestureRecognizer *backgroundTapGestureRecognizer;

@end
