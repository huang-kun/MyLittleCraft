//
//  MYMusicTitleTransitionAnimator.h
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/23.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MYTitleLabelOwnerable;

@interface MYMusicTitleTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign, getter=isPresentation) BOOL presentation;
@property (nonatomic, assign) BOOL onlyDriveNavigationTransition; // ignore title label

@property (nonatomic, weak) id <MYTitleLabelOwnerable> sourceOwner;
@property (nonatomic, weak) id <MYTitleLabelOwnerable> presentedOwner;

@end
