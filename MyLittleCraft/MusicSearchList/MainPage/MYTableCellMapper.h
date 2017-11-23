//
//  MYTableCellMapper.h
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/16.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MYTableElementType) {
    MYTableElementTypeSectionHeader,
    MYTableElementTypeCell,
};

@interface MYTableCellMapper : NSObject

/// The new cell type
@property (nonatomic, readonly, assign) MYTableElementType elementType;

/// The new section index
@property (nonatomic, readonly, assign) NSInteger section;

/// The new row index in section
@property (nonatomic, readonly, assign) NSInteger row;


/// Get a mapper for section header item
+ (instancetype)mapViewForHeaderInSection:(NSInteger)section;

/// Get a mapper for cell item
+ (instancetype)mapCellForRow:(NSInteger)row inSection:(NSInteger)section;


@end
