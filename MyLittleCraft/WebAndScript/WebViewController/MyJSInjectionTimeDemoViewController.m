//
//  MyJSInjectionTimeDemoViewController.m
//  MyWebDemo
//
//  Created by huangkun on 2017/7/15.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MyJSInjectionTimeDemoViewController.h"
#import "UIViewController+ShowAlert.h"

@interface MyJSInjectionTimeDemoViewController () <WKNavigationDelegate>

@end

@implementation MyJSInjectionTimeDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.navigationDelegate = self;
    
    NSString *source1 = [self javaScriptByInsertingElementNamed:@"start"];
    NSString *source2 = [self javaScriptByInsertingElementNamed:@"end"];
    
    WKUserScriptInjectionTime start = WKUserScriptInjectionTimeAtDocumentStart;
    WKUserScriptInjectionTime end = WKUserScriptInjectionTimeAtDocumentEnd;
    
    WKUserScript *script1 = [[WKUserScript alloc] initWithSource:source1 injectionTime:start forMainFrameOnly:YES];
    WKUserScript *script2 = [[WKUserScript alloc] initWithSource:source2 injectionTime:end forMainFrameOnly:YES];
    
    WKUserContentController *userContentController = self.webView.configuration.userContentController;
    
    [userContentController addUserScript:script1];
    [userContentController addUserScript:script2];
}

- (NSString *)javaScriptByInsertingElementNamed:(NSString *)name {
    NSMutableString *js = [NSMutableString string];
    [js appendFormat:@"var %@ = document.createElement('%@');", name, name];
    [js appendFormat:@"document.documentElement.appendChild(%@);", name];
    return js.copy;
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [self popAlertWithTitle:@"Next thing to do" message:@"Open Safari, then use Web Inspector to check the document elements."];
}

@end
