//
//  MyJSInjectionDemoViewController.m
//  MyWebDemo
//
//  Created by huangkun on 2017/7/13.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MyJSInjectionDemoViewController.h"

@interface MyJSInjectionDemoViewController ()

@end

@implementation MyJSInjectionDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // get javascript
    NSString *filePath = [NSBundle.mainBundle pathForResource:@"js_injection_demo" ofType:@"js"];
    NSString *javaScript = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    WKUserScript *script = [[WKUserScript alloc] initWithSource:javaScript
                                                  injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                               forMainFrameOnly:YES];
    
    WKUserContentController *userContentController = self.webView.configuration.userContentController;
    [userContentController addUserScript:script];
}

@end
