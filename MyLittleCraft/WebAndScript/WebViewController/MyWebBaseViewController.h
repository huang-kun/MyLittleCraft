//
//  MyWebBaseViewController.h
//  MyWebDemo
//
//  Created by huangkun on 2017/7/13.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "WebViewControllerProtocol.h"

@interface MyWebBaseViewController : UIViewController <WebViewControllerProtocol>

@property (nonatomic, strong) NSURL *url;

@property (nonatomic, readonly, strong) WKWebView *webView;

@end
