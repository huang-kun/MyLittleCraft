//
//  AppDelegate.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/4.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MYNavigationController.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIViewController *vc = [ViewController new];
    
    MYNavigationController *nav = [[MYNavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.translucent = YES;
    nav.navigationBar.shadowImage = [UIImage new];
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    window.backgroundColor = UIColor.whiteColor;
    window.rootViewController = nav;
    [window makeKeyAndVisible];
    
    self.window = window;
    
    return YES;
}

@end
