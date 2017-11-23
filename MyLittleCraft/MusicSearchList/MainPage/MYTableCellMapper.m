//
//  MYTableCellMapper.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/16.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MYTableCellMapper.h"

@implementation MYTableCellMapper

+ (instancetype)mapViewForHeaderInSection:(NSInteger)section {
    return [[self alloc] initWithElementType:MYTableElementTypeSectionHeader section:section row:NSIntegerMin];
}

+ (instancetype)mapCellForRow:(NSInteger)row inSection:(NSInteger)section {
    return [[self alloc] initWithElementType:MYTableElementTypeCell section:section row:row];
}

- (instancetype)initWithElementType:(MYTableElementType)elementType
                            section:(NSInteger)section
                                row:(NSInteger)row {
    self = [super init];
    if (self) {
        _elementType = elementType;
        _section = section;
        _row = row;
    }
    return self;
}

- (BOOL)isEqual:(MYTableCellMapper *)mapper {
    return
    self.elementType == mapper.elementType &&
    self.section == mapper.section &&
    self.row == mapper.row;
}

- (NSString *)description {
    NSMutableString *desc = [NSMutableString stringWithFormat:@"<%@:%p> ", self.class, self];
    [desc appendFormat:@"type = %@, ", @(_elementType)];
    switch (_elementType) {
        case MYTableElementTypeSectionHeader:
            [desc appendFormat:@"section = %@", @(_section)];
            break;
        case MYTableElementTypeCell:
            [desc appendFormat:@"row = %@, section = %@", @(_row), @(_section)];
            break;
    }
    return desc;
}

@end
