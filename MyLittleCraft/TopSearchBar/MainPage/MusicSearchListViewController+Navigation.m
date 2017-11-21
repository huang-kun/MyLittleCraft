//
//  MusicSearchListViewController+Navigation.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/20.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MusicSearchListViewController+Navigation.h"
#import "MYNavigationController.h"

@implementation MusicSearchListViewController (Navigation)

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(MYNavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // Hide navigation bar in self
    BOOL showSelf = [viewController isKindOfClass:self.class];
    [navigationController setNavigationBarHidden:showSelf animated:animated];
}

- (void)navigationController:(MYNavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    NSAssert([navigationController isKindOfClass:MYNavigationController.class], @"Must initialize %@ class inside of MYNavigationController.", self.class);
    
    // Change default edge distance from pop gesture
    MYFullScreenPanGestureRecognizer *popGesture = navigationController.my_interactivePopGestureRecognizer;
    popGesture.interactiveDistanceFromEdge = UIScreen.mainScreen.bounds.size.width / 2;
    
    BOOL showSelf = [viewController isKindOfClass:self.class];
    if (!showSelf) {
        popGesture.interactiveDistanceFromEdge = MYFullScreenInteractiveDistanceDefault;
    }
}

@end
