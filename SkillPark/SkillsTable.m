//
//  SkillsTable.m
//  SkillPark
//
//  Created by qee on 2015/11/4.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "SkillsTable.h"

@implementation SkillsTable

- (NSMutableArray *)skillRecords
{
    if (!_skillRecords) {
        _skillRecords = [[NSMutableArray alloc] init];
    }
    
    return _skillRecords;
}

@end
