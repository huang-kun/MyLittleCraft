//
//  MYMusicSearchDetailViewController.h
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/23.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYMusicSearchDetailViewController : UIViewController

@property (nonatomic, readonly, strong) UIPercentDrivenInteractiveTransition *dismissalInteractor;
@property (nonatomic, assign) BOOL customTransitionFailed;

@end
