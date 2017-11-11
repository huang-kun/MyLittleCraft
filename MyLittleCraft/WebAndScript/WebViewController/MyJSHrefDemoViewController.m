//
//  MyJSHrefDemoViewController.m
//  MyWebDemo
//
//  Created by huangkun on 2017/7/13.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MyJSHrefDemoViewController.h"
#import "UIViewController+ShowAlert.h"

@interface MyJSHrefDemoViewController () <WKNavigationDelegate>

@end

@implementation MyJSHrefDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.navigationDelegate = self;
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    // get javascript
    NSString *filePath = [NSBundle.mainBundle pathForResource:@"js_href_demo" ofType:@"js"];
    NSString *javaScript = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    // run javascript
    [webView evaluateJavaScript:javaScript completionHandler:nil];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    // show title
    NSString *href = navigationAction.request.URL.absoluteString;
    if ([href hasPrefix:@"mywebdemo:"]) {
        NSString *title = [href componentsSeparatedByString:@"mywebdemo:"].lastObject;
        title = [title stringByRemovingPercentEncoding];
        [self popAlertWithTitle:@"网页标题" message:title];
        
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
