//
//  MyJSMessageDemoViewController.m
//  MyWebDemo
//
//  Created by huangkun on 2017/7/13.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MyJSMessageDemoViewController.h"
#import "UIViewController+ShowAlert.h"

@interface MyJSMessageDemoViewController () <WKScriptMessageHandler>

@end

@implementation MyJSMessageDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // get javascript
    NSString *filePath = [NSBundle.mainBundle pathForResource:@"js_message_demo" ofType:@"js"];
    NSString *javaScript = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    WKUserScript *script = [[WKUserScript alloc] initWithSource:javaScript
                                                  injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
                                               forMainFrameOnly:YES];
    
    // NOTICE:
    // 1. configuration is a new copy, but userContentController is the same reference.
    // 2. userContentController holds a strong reference to self by calling -addScriptMessageHandler:name:
    //    so better remove it later to break the retain cycle.
    WKWebViewConfiguration *configuration = self.webView.configuration;
    WKUserContentController *userContentController = configuration.userContentController;

    [userContentController addUserScript:script];
    [userContentController addScriptMessageHandler:self name:@"didFindTitle"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"didFindTitle"];
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    // show title
    if ([message.name isEqualToString:@"didFindTitle"]) {
        [self popAlertWithTitle:@"网页标题" message:message.body];
    }
}

@end
