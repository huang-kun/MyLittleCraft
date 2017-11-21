//
//  MusicSearchListViewController.h
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/13.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MYMusicBar, MYSearchBarTransitionAnimator, MYMusicDetailTransitionAnimator;

@interface MusicSearchListViewController : UIViewController

@property (nonatomic, readonly, strong) MYMusicBar *musicBar;
@property (nonatomic, readonly, strong) MYSearchBarTransitionAnimator *searchBarTransitionAnimator;
@property (nonatomic, readonly, strong) MYMusicDetailTransitionAnimator *musicDetailTransitionAnimator;

@end
