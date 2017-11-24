//
//  MYMusicSearchTransitioner.h
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/23.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MYSearchBarTransitionAnimator, MYMusicCardTransitionAnimator, MYMusicTitleTransitionAnimator;

@interface MYMusicSearchTransitioner : NSObject <UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, readonly, strong) MYSearchBarTransitionAnimator *searchBarTransitionAnimator;
@property (nonatomic, readonly, strong) MYMusicCardTransitionAnimator *musicCardTransitionAnimator;
@property (nonatomic, readonly, strong) MYMusicTitleTransitionAnimator *musicTitleTransitionAnimator;

@end
