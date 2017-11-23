//
//  MYMusicSearchTransitioner.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/23.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MYMusicSearchTransitioner.h"
#import "MYSearchViewController.h"
#import "MYMusicDetailViewController.h"
#import "MYSearchBarTransitionAnimator.h"
#import "MYMusicDetailTransitionAnimator.h"
#import "MYSearchBar.h"
#import "MYMusicBar.h"
#import "MYArtworkCardView.h"

@interface MYMusicSearchTransitioner()
@property (nonatomic, strong) MYSearchBarTransitionAnimator *searchBarTransitionAnimator;
@property (nonatomic, strong) MYMusicDetailTransitionAnimator *musicDetailTransitionAnimator;
@property (nonatomic, weak) UIViewController *source;
@property (nonatomic, weak) UIViewController *presented;
@end

@implementation MYMusicSearchTransitioner

- (instancetype)init {
    self = [super init];
    if (self) {
        _searchBarTransitionAnimator = [MYSearchBarTransitionAnimator new];
        _musicDetailTransitionAnimator = [MYMusicDetailTransitionAnimator new];
    }
    return self;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    self.source = source;
    self.presented = presented;
    
    // Make constraints effect now, the frame will be used in transition animation later.
    [presented.view layoutIfNeeded];
    
    // present search bar vc
    if ([presented isKindOfClass:MYSearchViewController.class]) {
        [self checkIf:source conformsTo:@protocol(MYSearchBarOwnerable)];
        [self checkIf:presented conformsTo:@protocol(MYSearchBarOwnerable)];
        
        self.searchBarTransitionAnimator.presentation = YES;
        self.searchBarTransitionAnimator.sourceOwner = (id)source;
        self.searchBarTransitionAnimator.presentedOwner = (id)presented;
        
        return self.searchBarTransitionAnimator;
    }
    // present music card vc
    else if ([presented isKindOfClass:MYMusicDetailViewController.class]) {
        [self checkIf:source conformsTo:@protocol(MYMusicBarOwnerable)];
        [self checkIf:presented conformsTo:@protocol(MYArtworkCardOwnerable)];
        
        id <MYMusicBarOwnerable> musicBarOwner = (id)source;
        
        self.musicDetailTransitionAnimator.presentation = YES;
        self.musicDetailTransitionAnimator.sourceOwner = (id)musicBarOwner;
        self.musicDetailTransitionAnimator.presentedOwner = (id)presented;
        self.musicDetailTransitionAnimator.initialPresentationDistanceFromBottom = musicBarOwner.musicBar.frame.size.height;
        
        return self.musicDetailTransitionAnimator;
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
    else if ([dismissed isKindOfClass:MYMusicDetailViewController.class]) {
        self.musicDetailTransitionAnimator.presentation = NO;
        return self.musicDetailTransitionAnimator;
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

@end
