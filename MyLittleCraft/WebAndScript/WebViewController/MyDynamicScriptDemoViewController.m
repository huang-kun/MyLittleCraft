//
//  MyDynamicScriptDemoViewController.m
//  MyWebDemo
//
//  Created by huangkun on 2017/8/10.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MyDynamicScriptDemoViewController.h"
#import "UIViewController+ShowAlert.h"
#import "WKUserScript+ScriptURL.h"

@interface MyDynamicScriptDemoViewController () <WKNavigationDelegate>

@end

@implementation MyDynamicScriptDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.navigationDelegate = self;
    
    NSString *scriptURL = @"http://www.w3school.com.cn/example/html/demo_script_src.js";
    NSString *requestURL = [scriptURL stringByAppendingFormat:@"?%@", @(arc4random() % 999)];
    WKUserScript *script = [[WKUserScript alloc] initWithScriptURLs:@[requestURL] toPosition:HTMLScriptTagPositionBody forMainFrameOnly:YES];
    
    WKUserContentController *userContentController = self.webView.configuration.userContentController;
    [userContentController addUserScript:script];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [self popAlertWithTitle:@"Next thing to do" message:@"Use Web Inspector in Safari to check your <script> node. PS: You can provide your own URL to finish this demo."];
}

@end
