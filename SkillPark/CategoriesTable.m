//
//  CategoriesTable.m
//  SkillPark
//
//  Created by qee on 2015/11/4.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "CategoriesTable.h"

@implementation CategoriesTable

- (NSMutableArray *)categoryRecords
{
    if (!_categoryRecords) {
        _categoryRecords = [[NSMutableArray alloc] init];
    }
    
    return _categoryRecords;
}

@end
