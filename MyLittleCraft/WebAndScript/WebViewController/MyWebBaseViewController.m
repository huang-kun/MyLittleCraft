//
//  MyWebBaseViewController.m
//  MyWebDemo
//
//  Created by huangkun on 2017/7/13.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MyWebBaseViewController.h"
#import "UIView+Pin.h"

@interface MyWebBaseViewController ()
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation MyWebBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    // create webview
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    
    // load request
    if (self.url) {
        NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
        [self.webView loadRequest:request];
        self.title = self.url.absoluteString;
    }

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.webView.isLoading) {
        [self.webView stopLoading];
    }
}

#pragma mark -

- (void)dealloc {
    NSLog(@"%@ dealloc", self);
}

@end
