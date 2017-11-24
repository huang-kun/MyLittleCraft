//
//  MYMusicSearchTransitioner.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/23.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MYMusicSearchTransitioner.h"
#import "MYNavigationController.h"

#import "MusicSearchListViewController.h"
#import "MYSearchViewController.h"
#import "MYMusicCardViewController.h"
#import "MYMusicSearchDetailViewController.h"

#import "MYSearchBarTransitionAnimator.h"
#import "MYMusicCardTransitionAnimator.h"
#import "MYMusicTitleTransitionAnimator.h"

#import "MYSearchBar.h"
#import "MYMusicBar.h"
#import "MYArtworkCardView.h"
#import "MYTitleLabelOwnerable.h"
#import "MYTintLabel.h"

@interface MYMusicSearchTransitioner()
@property (nonatomic, weak) UIViewController *source;
@property (nonatomic, weak) UIViewController *presented;
@end

@implementation MYMusicSearchTransitioner

- (instancetype)init {
    self = [super init];
    if (self) {
        _searchBarTransitionAnimator = [MYSearchBarTransitionAnimator new];
        _musicCardTransitionAnimator = [MYMusicCardTransitionAnimator new];
        _musicTitleTransitionAnimator = [MYMusicTitleTransitionAnimator new];
    }
    return self;
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(MYNavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // Hide navigation bar in music list vc
    BOOL showMusicList = [viewController isKindOfClass:MusicSearchListViewController.class];
    [navigationController setNavigationBarHidden:showMusicList animated:animated];
    
    // Hide title and back button
    if (showMusicList) {
        // Hide title during dismissal transition animation.
        viewController.title = nil;
        
        // Set empty back button instead of nil, otherwise navigation bar will use
        // the default one during dismissal transition animation.
        UIBarButtonItem *emptyBackButton = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
        viewController.navigationItem.leftBarButtonItem = emptyBackButton;
    }
}

- (void)navigationController:(MYNavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    NSAssert([navigationController isKindOfClass:MYNavigationController.class], @"Must initialize %@ class inside of MYNavigationController.", self.class);
    
    // Change default edge distance from pop gesture
    MYFullScreenPanGestureRecognizer *popGesture = navigationController.my_interactivePopGestureRecognizer;
    popGesture.interactiveDistanceFromEdge = UIScreen.mainScreen.bounds.size.width / 2;
    
    BOOL showMusicList = [viewController isKindOfClass:MusicSearchListViewController.class];
    if (!showMusicList) {
        popGesture.interactiveDistanceFromEdge = MYFullScreenInteractiveDistanceDefault;
    }
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    if (operation == UINavigationControllerOperationPush) {
        if ([fromVC isKindOfClass:MusicSearchListViewController.class] &&
            [toVC isKindOfClass:MYMusicSearchDetailViewController.class]) {
            
            [self checkIf:fromVC conformsTo:@protocol(MYTitleLabelOwnerable)];
            [self checkIf:toVC conformsTo:@protocol(MYTitleLabelOwnerable)];
            
            id <MYTitleLabelOwnerable> sourceOwner = (id)fromVC;
            id <MYTitleLabelOwnerable> presentedOwner = (id)toVC;
            
            if (![self isViewOnScreen:sourceOwner.titleLabel]) {
                MYMusicSearchDetailViewController *dvc = (id)toVC;
                dvc.customTransitionFailed = YES;
                return nil;
            }
            
            MYMusicTitleTransitionAnimator *animator = self.musicTitleTransitionAnimator;
            
            animator.presentation = YES;
            animator.sourceOwner = sourceOwner;
            animator.presentedOwner = presentedOwner;
            
            return animator;
        }
    }
    
    else if (operation == UINavigationControllerOperationPop) {
        if ([fromVC isKindOfClass:MYMusicSearchDetailViewController.class] &&
            [toVC isKindOfClass:MusicSearchListViewController.class]) {
            
            MYMusicTitleTransitionAnimator *animator = self.musicTitleTransitionAnimator;
            animator.presentation = NO;
            
            if (!animator.sourceOwner || !animator.presentedOwner) {
                return nil;
            }
            
            return animator;
        }
    }
    
    return nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    
    if (animationController == self.musicTitleTransitionAnimator) {
        MYMusicTitleTransitionAnimator *animator = (MYMusicTitleTransitionAnimator *)animationController;
        if (!animator.isPresentation) {
            if ([animator.presentedOwner isKindOfClass:MYMusicSearchDetailViewController.class]) {
                MYMusicSearchDetailViewController *dvc = (id)animator.presentedOwner;
                return dvc.dismissalInteractor;
            }
        }
    }
    
    return nil;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    self.source = source;
    self.presented = presented;
    
    // Make constraints effective now, the frame will be used in transition animation later.
    [presented.view layoutIfNeeded];
    
    // present search bar vc
    if ([presented isKindOfClass:MYSearchViewController.class]) {
        [self checkIf:source conformsTo:@protocol(MYSearchBarOwnerable)];
        [self checkIf:presented conformsTo:@protocol(MYSearchBarOwnerable)];
        
        MYSearchBarTransitionAnimator *animator = self.searchBarTransitionAnimator;
        animator.presentation = YES;
        animator.sourceOwner = (id)source;
        animator.presentedOwner = (id)presented;
        
        return animator;
    }
    // present music card vc
    else if ([presented isKindOfClass:MYMusicCardViewController.class]) {
        [self checkIf:source conformsTo:@protocol(MYMusicBarOwnerable)];
        [self checkIf:presented conformsTo:@protocol(MYArtworkCardOwnerable)];
        
        id <MYMusicBarOwnerable> musicBarOwner = (id)source;
        MYMusicCardTransitionAnimator *animator = self.musicCardTransitionAnimator;

        animator.presentation = YES;
        animator.sourceOwner = (id)musicBarOwner;
        animator.presentedOwner = (id)presented;
        animator.initialPresentationDistanceFromBottom = musicBarOwner.musicBar.frame.size.height;
        
        return animator;
    }
    
    return nil;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(id <MYSearchBarOwnerable>)dismissed {
    
    // dismiss from search bar vc
    if ([dismissed isKindOfClass:MYSearchViewController.class]) {
        self.searchBarTransitionAnimator.presentation = NO;
        return self.searchBarTransitionAnimator;
    }
    // dismiss from music card vc
    else if ([dismissed isKindOfClass:MYMusicCardViewController.class]) {
        self.musicCardTransitionAnimator.presentation = NO;
        return self.musicCardTransitionAnimator;
    }
    
    return nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    
    if (animator == self.searchBarTransitionAnimator) {
        if ([self.presented isKindOfClass:MYSearchViewController.class]) {
            MYSearchViewController *svc = (MYSearchViewController *)self.presented;
            return svc.searchBarDismissalInteractor;
        }
    }
    
    return nil;
}

- (BOOL)checkIf:(UIViewController *)vc conformsTo:(Protocol *)protocol {
    NSAssert([vc conformsToProtocol:protocol], @"%@ must conforms to %@.", vc, NSStringFromProtocol(protocol));
    return YES;
}

- (BOOL)isViewOnScreen:(UIView *)view {
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    CGRect screenBounds = UIScreen.mainScreen.bounds;
    CGRect viewFrame = [window convertRect:view.frame fromView:view.superview];
    return (CGRectContainsRect(screenBounds, viewFrame));
}

@end
