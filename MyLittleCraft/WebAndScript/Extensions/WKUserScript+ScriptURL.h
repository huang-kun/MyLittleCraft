//
//  WKUserScript+ScriptURL.h
//  MyWebDemo
//
//  Created by huangkun on 2017/8/11.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import <WebKit/WebKit.h>

typedef NS_ENUM(NSInteger, HTMLScriptTagPosition) {
    HTMLScriptTagPositionHead,
    HTMLScriptTagPositionBody,
};

@interface WKUserScript (ScriptURL)

/**
 Create a WKUserScript object which inserts <script src="https://xxx.js"></script> nodes into a web.

 @param scriptURLs          A collection of URL for javascripts on the server.
 @param position            The position to insert <script> node. Either in the <head> or in the <body>.
 @param forMainFrameOnly    A Boolean value indicating whether the script should be injected only into the main frame (YES) or into all frames (NO).
 @return The WKUserScript object.
 */
- (instancetype)initWithScriptURLs:(NSArray <NSString *> *)scriptURLs toPosition:(HTMLScriptTagPosition)position forMainFrameOnly:(BOOL)forMainFrameOnly;

@end
