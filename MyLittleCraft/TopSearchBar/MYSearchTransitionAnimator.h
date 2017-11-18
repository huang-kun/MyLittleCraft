//
//  MYSearchTransitionAnimator.h
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/15.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYSearchBar.h"

@interface MYSearchTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign, getter=isPresenting) BOOL presenting;

@property (nonatomic, weak) id <MYSearchBarOwnerable> sourceOwner;
@property (nonatomic, weak) id <MYSearchBarOwnerable> presentedOwner;

@end
