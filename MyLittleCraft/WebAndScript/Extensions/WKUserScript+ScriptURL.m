//
//  WKUserScript+ScriptURL.m
//  MyWebDemo
//
//  Created by huangkun on 2017/8/11.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "WKUserScript+ScriptURL.h"

@implementation WKUserScript (ScriptURL)

- (instancetype)initWithScriptURLs:(NSArray <NSString *> *)scriptURLs toPosition:(HTMLScriptTagPosition)position forMainFrameOnly:(BOOL)forMainFrameOnly {
    
    NSMutableString *javaScript = [NSMutableString string];
    
    NSString *targetElement = nil;
    switch (position) {
        case HTMLScriptTagPositionHead: targetElement = @"head"; break;
        case HTMLScriptTagPositionBody: targetElement = @"body"; break;
    }
    
    for (NSUInteger i = 0; i < scriptURLs.count; i++) {
        NSString *scriptURL = scriptURLs[i];
        
        [javaScript appendFormat:@"var scriptElement%@ = document.createElement('script');", @(i)];
        [javaScript appendFormat:@"scriptElement%@.setAttribute(\"type\", \"text/javascript\");", @(i)];
        [javaScript appendFormat:@"scriptElement%@.setAttribute(\"src\", \"%@\");", @(i), scriptURL];
        
        [javaScript appendFormat:@"var targetElement = document.getElementsByTagName('%@')[0];", targetElement];
        [javaScript appendFormat:@"targetElement.appendChild(scriptElement%@);", @(i)];
    }
    
    return [self initWithSource:javaScript.copy
                  injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
               forMainFrameOnly:forMainFrameOnly];
}

@end
