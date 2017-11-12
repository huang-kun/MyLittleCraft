//
//  MotionCamera.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/11.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MotionCamera.h"
#import <CoreMotion/CoreMotion.h>
#import "MYCameraPreviewLayer.h"
#import "MotionCameraExt.h"
#import "UIViewController+ShowAlert.h"

@interface MotionCamera ()

@property (nonatomic, assign) UIDeviceOrientation deviceOrientation;
@property (nonatomic, assign) CGAffineTransform cameraTransform;
@property (nonatomic, strong) CMMotionManager *motionManager;

@property (nonatomic, strong) MYCameraPreviewLayer *previewLayer;
@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UISwitch *switcher;
@property (nonatomic, strong) UILabel *switcherLabel;

@property (nonatomic, assign) BOOL useAccelerometer;

@end

@implementation MotionCamera

#pragma mark - UIViewController life cycles

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Fake preview
    _previewLayer = [MYCameraPreviewLayer new];
    [self.view.layer addSublayer:_previewLayer];
    
    // Fake button
    UIImage *cameraIcon = [UIImage imageNamed:@"camera"];
    _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cameraButton setImage:cameraIcon forState:UIControlStateNormal];
    [_cameraButton setImage:cameraIcon forState:UIControlStateHighlighted];
    [_cameraButton addTarget:self action:@selector(capture:) forControlEvents:UIControlEventTouchUpInside];
    [_cameraButton sizeToFit];
    [self.view addSubview:_cameraButton];
    
    // Tip Label
    _tipLabel = [UILabel new];
    _tipLabel.text = [self defaultTip];
    _tipLabel.textColor = UIColor.grayColor;
    _tipLabel.numberOfLines = 5;
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    [_tipLabel sizeToFit];
    [self.view addSubview:_tipLabel];
    
    // Make Switcher
    _switcher = [UISwitch new];
    [_switcher addTarget:self action:@selector(handleSwitcher:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *switchButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_switcher];
    self.navigationItem.rightBarButtonItem = switchButtonItem;
    
    _switcherLabel = [UILabel new];
    _switcherLabel.numberOfLines = 1;
    _switcherLabel.textAlignment = NSTextAlignmentRight;
    _switcherLabel.text = [self changeToCustomDetectionText];
    _switcherLabel.textColor = UIColor.redColor;
    [_switcherLabel sizeToFit];
    [self.view addSubview:_switcherLabel];
    
#if !TARGET_OS_SIMULATOR
    
    // Motion manager
    _motionManager = [CMMotionManager new];
    if (_motionManager.isAccelerometerAvailable) {
        _motionManager.accelerometerUpdateInterval = 0.1;
    }
    
#endif
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(handleDeviceChange:)
                                               name:UIDeviceOrientationDidChangeNotification
                                             object:UIDevice.currentDevice];
    
    [self updateCameraUIFromOrientation:UIDeviceOrientationUnknown
                          toOrientation:UIDevice.currentDevice.orientation];
    
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_motionManager.isAccelerometerAvailable && !_motionManager.isAccelerometerActive) {
        [_motionManager startAccelerometerUpdatesToQueue:NSOperationQueue.mainQueue withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
            
            if (self.useAccelerometer) {
                UIDeviceOrientation oldOrientation = self.deviceOrientation;
                UIDeviceOrientation newOrientation = my_orientationForAccelerometerData(accelerometerData);
                [self updateCameraUIFromOrientation:oldOrientation toOrientation:newOrientation];
            }
            
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (_motionManager.isAccelerometerActive) {
        [_motionManager stopAccelerometerUpdates];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
#if TARGET_OS_SIMULATOR
    [self popAlertWithTitle:@"Sorry" message:@"This demo is better testing on a real device, so you can see the device orientation changes drove by real accelerometer."];
#endif
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat topBarHeight = UIApplication.sharedApplication.statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
    
    CGRect previewFrame = UIScreen.mainScreen.bounds;
    previewFrame.origin.x += 10;
    previewFrame.origin.y += (topBarHeight + 20);
    previewFrame.size.width -= 20;
    previewFrame.size.height -= (topBarHeight + 50);
    
    _previewLayer.frame = previewFrame;
    
    _tipLabel.center = (CGPoint){
        CGRectGetMidX(previewFrame),
        CGRectGetMidY(previewFrame)
    };
    
    _cameraButton.center = (CGPoint) {
        CGRectGetMidX(previewFrame),
        CGRectGetMaxY(previewFrame) - _cameraButton.frame.size.height / 2 - 25
    };
    
    _switcherLabel.center = (CGPoint) {
        self.view.bounds.size.width - _switcherLabel.frame.size.width / 2 - 40,
        topBarHeight + _switcherLabel.frame.size.height / 2 + 5
    };
}

#pragma mark - Target / Action

- (void)handleSwitcher:(UISwitch *)sender {
    if (sender.tag == 0) {
        sender.tag = 1;
        self.useAccelerometer = YES;
        self.switcherLabel.text = [self changeToSystemDetectionText];
        self.switcherLabel.textColor = UIColor.blackColor;
        [self.switcherLabel sizeToFit];
    } else {
        sender.tag = 0;
        self.useAccelerometer = NO;
        self.switcherLabel.text = [self changeToCustomDetectionText];
        self.switcherLabel.textColor = UIColor.redColor;
        [self.switcherLabel sizeToFit];
    }
}

- (void)capture:(UIButton *)sender {
    [self popAlertWithTitle:@"Oops" message:@"Sorry, this is not a real camera app, but for device orientation detection purpose only."];
}

#pragma mark - NSNotification

- (void)handleDeviceChange:(NSNotification *)notification {
    if (!self.useAccelerometer) {
        UIDeviceOrientation oldOrientation = self.deviceOrientation;
        UIDeviceOrientation newOrientation = UIDevice.currentDevice.orientation;
        [self updateCameraUIFromOrientation:oldOrientation toOrientation:newOrientation];
    }
}

#pragma mark - Camera UI Rotation

- (void)updateCameraUIFromOrientation:(UIDeviceOrientation)oldOrientation toOrientation:(UIDeviceOrientation)newOrientation {
    
    if (oldOrientation == newOrientation || _deviceOrientation == newOrientation)
        return;
    
    _deviceOrientation = newOrientation;
    
    // Change tips
    NSMutableString *tip = [self defaultTip].mutableCopy;
    switch (_deviceOrientation) {
        case UIDeviceOrientationFaceUp: [tip appendString:@"\n(Face up)"]; break;
        case UIDeviceOrientationFaceDown: [tip appendString:@"\n(Face down)"]; break;
        default: break;
    }
    _tipLabel.text = tip;
    [_tipLabel sizeToFit];
    
    // Rotate
    CGFloat degrees = 0;
    switch (_deviceOrientation) {
        case UIDeviceOrientationPortrait: degrees = 0; break;
        case UIDeviceOrientationLandscapeLeft: degrees = 90; break;
        case UIDeviceOrientationLandscapeRight: degrees = -90; break;
        default: return;
    }
    
    // left to right
    if (oldOrientation == UIDeviceOrientationLandscapeLeft && newOrientation == UIDeviceOrientationLandscapeRight) {
        degrees = 270.0;
    }
    // right to left
    else if (oldOrientation == UIDeviceOrientationLandscapeRight && newOrientation == UIDeviceOrientationLandscapeLeft) {
        degrees = -270.0;
    }
    
    CGFloat angle = (degrees * M_PI / 180.0);
    CGAffineTransform newTransform = CGAffineTransformMakeRotation(angle);
    
    if (CGAffineTransformEqualToTransform(_cameraTransform, newTransform))
        return;
    
    _cameraTransform = newTransform;
    
    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:5.0 options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.cameraButton.transform = newTransform;
        self.tipLabel.transform = newTransform;
    } completion:nil];
    
}

#pragma mark - Helper

- (NSString *)defaultTip {
    return @"Rotate Camera. It's stable.\nEven it lies down on the table";
}

- (NSString *)changeToCustomDetectionText {
    return @"Change it to custom detection. ↗";
}

- (NSString *)changeToSystemDetectionText {
    return @"Back to default detection. ↗";
}

@end
