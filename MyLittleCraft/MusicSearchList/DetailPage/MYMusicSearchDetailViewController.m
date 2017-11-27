//
//  MYMusicSearchDetailViewController.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/23.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MYMusicSearchDetailViewController.h"
#import "MYMusicSearchConsts.h"
#import "MYTitleLabelOwnerable.h"
#import "MYBackButton.h"
#import "MYNavigationController.h"
#import "UIView+Pin.h"

@interface MYMusicSearchDetailViewController () <MYTitleLabelOwnerable>
@property (nonatomic, strong) MYBackButton *backButton;
@property (nonatomic, weak) MYNavigationController *navCtrl;
@property (nonatomic, strong) UILabel *tipLabel;
@end

@implementation MYMusicSearchDetailViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self buildInterface];
    [self layoutInterface];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.customTransitionFailed) {
        if ([self.navigationController isKindOfClass:MYNavigationController.class]) {
            // Having a weak reference for navigation controller, so when we can still track navigation controller
            // even after this vc is popped out of navigation stack
            _navCtrl = (MYNavigationController *)self.navigationController;
            
            // Change pop gesture target and action.
            [_navCtrl replacePopGestureTarget:self action:@selector(handleDismissal:)];
        }
        
        self.backButton.imageView.alpha = 0;
        
        [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            
            self.backButton.imageView.alpha = 1;
            
        } completion:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (!self.customTransitionFailed) {
        self.backButton.imageView.alpha = 1;
        
        [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            
            self.backButton.imageView.alpha = 0;
            
        } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            if (!context.isCancelled) {
                self.backButton.imageView.alpha = 0;
            } else {
                self.backButton.imageView.alpha = 1;
            }
        }];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (!self.customTransitionFailed) {
        // Reset pop gesture back to default configuration.
        [_navCtrl resetPopGestureDefaultTargetWithAction];
    }
}

#pragma mark - User interface

- (void)buildInterface {
    _backButton = [MYBackButton new];
    _backButton.tintColor = MY_MUSIC_TINT_COLOR;
    _backButton.titleLabel.text = @"Search";
    [_backButton addTarget:self action:@selector(popout) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    _tipLabel = [UILabel new];
    _tipLabel.numberOfLines = 0;
    _tipLabel.text = [self demoTip];
    _tipLabel.textColor = UIColor.lightGrayColor;
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_tipLabel];
}

- (void)layoutInterface {
    [_tipLabel pinEdgesWithInsets:(UIEdgeInsets){ 20, 20, 20, 20 }];
}

#pragma mark - MYTitleLabelOwnerable

- (MYTintLabel *)titleLabel {
    return _backButton.titleLabel;
}

#pragma mark - Target / action

- (void)handleDismissal:(UIPanGestureRecognizer *)popGesture {
    CGPoint translation = [popGesture translationInView:popGesture.view];
    CGFloat progress = translation.x / popGesture.view.bounds.size.width;
    
    if (progress < 0) {
        progress = 0;
    }
    if (progress > 1) {
        progress = 1;
    }
    
    switch (popGesture.state) {
        case UIGestureRecognizerStateBegan:
            _dismissalInteractor = [UIPercentDrivenInteractiveTransition new];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case UIGestureRecognizerStateChanged:
            [_dismissalInteractor updateInteractiveTransition:progress];
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            if (progress < 0.25) {
                [_dismissalInteractor cancelInteractiveTransition];
            } else {
                [_dismissalInteractor finishInteractiveTransition];
            }
            _dismissalInteractor = nil;
            break;
        default:
            break;
    }
}

#pragma mark - Helper

- (void)popout {
    // It seems cannot trigger popViewController during the percent driven interaction.
    // Otherwise the app will be freeze.
    if (!_dismissalInteractor) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [_dismissalInteractor finishInteractiveTransition];
    }
}

- (NSString *)demoTip {
    return @"In the previous page, make sure you can see the big \"Search\" title before you push in. Then tap one of the song and focus on the navigation back button transition.\n\n\nTry pop gesture to slowly drag from left edge of screen and dismiss.";
}

@end
