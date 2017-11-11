//
//  WebDemoItem.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/11.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "WebDemoItem.h"

@implementation WebDemoItem

+ (instancetype)demoWithClass:(Class)demoClass
                        title:(NSString *)title
                     subtitle:(NSString *)subtitle {
    
    WebDemoItem *item = [WebDemoItem new];
    item.demoClass = demoClass;
    item.title = title;
    item.subtitle = subtitle;
    
    return item;
}

@end
