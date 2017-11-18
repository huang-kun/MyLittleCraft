//
//  MYTableCellMapper.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/16.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MYTableCellMapper.h"

@implementation MYTableCellMapper

- (BOOL)isEqual:(MYTableCellMapper *)mapper {
    return self.elementType == mapper.elementType &&
            self.section == mapper.section &&
            self.itemIndex == mapper.itemIndex;
}

@end
