//
//  MyJSFunctionDemoViewController.m
//  MyWebDemo
//
//  Created by huangkun on 2017/7/13.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MyJSFunctionDemoViewController.h"
#import "UIViewController+ShowAlert.h"

@interface MyJSFunctionDemoViewController () <WKNavigationDelegate>

@end

@implementation MyJSFunctionDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.navigationDelegate = self;
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    // get javascript
    NSString *filePath = [NSBundle.mainBundle pathForResource:@"js_function_demo" ofType:@"js"];
    NSString *javaScript = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    // run javascript and show title
    [webView evaluateJavaScript:javaScript completionHandler:^(id _Nullable callback, NSError * _Nullable error) {
        if ([callback isKindOfClass:[NSString class]]) {
            [self popAlertWithTitle:@"网页标题" message:callback];
        }
    }];
}

@end
