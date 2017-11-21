//
//  MYMusicDetailTransitionAnimator.h
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/18.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYArtworkCardView.h"

@interface MYMusicDetailTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign, getter=isPresenting) BOOL presenting;
@property (nonatomic, readonly, getter=isAnimating) BOOL animating;

@property (nonatomic, weak) id <MYArtworkCardOwnerable> sourceOwner;
@property (nonatomic, weak) id <MYArtworkCardOwnerable> presentedOwner;

/// The tap gesture is added to background of presented view, without any target and action.
@property (nonatomic, readonly, strong) UITapGestureRecognizer *backgroundTapGestureRecognizer;

@end
