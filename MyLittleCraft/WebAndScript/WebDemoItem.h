//
//  WebDemoItem.h
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/11.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebDemoItem : NSObject

@property (nonatomic, assign) Class demoClass;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;

+ (instancetype)demoWithClass:(Class)demoClass
                        title:(NSString *)title
                     subtitle:(NSString *)subtitle;

@end
