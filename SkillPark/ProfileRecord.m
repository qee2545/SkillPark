//
//  ProfileRecord.m
//  SkillPark
//
//  Created by qee on 2015/11/4.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "ProfileRecord.h"

@implementation ProfileRecord

- (NSMutableArray *)favorites
{
    if (!_favorites) {
        _favorites = [[NSMutableArray alloc] init];
    }
    
    return _favorites;
}

@end
