//
//  MYTableCellMapper.h
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/16.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MYTableElementType) {
    MYTableElementTypeSection,
    MYTableElementTypeCell,
};

@interface MYTableCellMapper : NSObject

@property (nonatomic, assign) MYTableElementType elementType;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger itemIndex;

@end
