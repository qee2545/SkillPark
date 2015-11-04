//
//  CommentsTable.m
//  SkillPark
//
//  Created by qee on 2015/11/4.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "CommentsTable.h"

@implementation CommentsTable

- (NSMutableArray *)commentRecords
{
    if (!_commentRecords) {
        _commentRecords = [[NSMutableArray alloc] init];
    }
    
    return _commentRecords;
}

@end
