//
//  MusicSearchListViewController+Transition.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/19.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MusicSearchListViewController+Transition.h"
#import "MYSearchViewController.h"
#import "MYMusicDetailViewController.h"
#import "MYSearchBarTransitionAnimator.h"
#import "MYMusicDetailTransitionAnimator.h"
#import "MYSearchBar.h"
#import "MYMusicBar.h"
#import "MYArtworkCardView.h"

@implementation MusicSearchListViewController (Transition)

#pragma mark - UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    // pop search bar vc
    if ([presented isKindOfClass:MYSearchViewController.class]) {
        [self checkIf:source conformsTo:@protocol(MYSearchBarOwnerable)];
        [self checkIf:presented conformsTo:@protocol(MYSearchBarOwnerable)];
        
        self.searchBarTransitionAnimator.presenting = YES;
        self.searchBarTransitionAnimator.sourceOwner = (id)source;
        self.searchBarTransitionAnimator.presentedOwner = (id)presented;
        
        return self.searchBarTransitionAnimator;
    }
    // pop music card vc
    else if ([presented isKindOfClass:MYMusicDetailViewController.class]) {
        [self checkIf:source conformsTo:@protocol(MYArtworkCardOwnerable)];
        [self checkIf:presented conformsTo:@protocol(MYArtworkCardOwnerable)];

        self.musicDetailTransitionAnimator.presenting = YES;
        self.musicDetailTransitionAnimator.sourceOwner = (id)self;
        self.musicDetailTransitionAnimator.presentedOwner = (id)presented;
        self.musicDetailTransitionAnimator.initialPresentationDistanceFromBottom = self.musicBar.frame.size.height;
        
        return self.musicDetailTransitionAnimator;
    }
    
    return nil;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(id <MYSearchBarOwnerable>)dismissed {
    
    // dismiss from search bar vc
    if ([dismissed isKindOfClass:MYSearchViewController.class]) {
        self.searchBarTransitionAnimator.presenting = NO;
        return self.searchBarTransitionAnimator;
    }
    // dismiss from music card vc
    else if ([dismissed isKindOfClass:MYMusicDetailViewController.class]) {
        self.musicDetailTransitionAnimator.presenting = NO;
        return self.musicDetailTransitionAnimator;
    }
    
    return nil;
}

- (BOOL)checkIf:(UIViewController *)vc conformsTo:(Protocol *)protocol {
    NSAssert([vc conformsToProtocol:protocol], @"%@ must conforms to %@.", vc, NSStringFromProtocol(protocol));
    return YES;
}

@end
