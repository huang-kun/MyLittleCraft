//
//  MYSearchTransitionAnimator.h
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/15.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MYSearchBar;

@interface MYSearchTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, readonly, strong) UIView *backgroundView;
@property (nonatomic, readonly, strong) MYSearchBar *searchBar;

@property (nonatomic, assign) BOOL reversed;
@property (nonatomic, assign) CGRect searchBarInitialFrame;
@property (nonatomic, assign) CGRect searchBarFinalFrame;

@end
