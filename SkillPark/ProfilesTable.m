//
//  ProfilesTable.m
//  SkillPark
//
//  Created by qee on 2015/11/4.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "ProfilesTable.h"

@implementation ProfilesTable

- (NSMutableArray *)profileRecords
{
    if (!_profileRecords) {
        _profileRecords = [[NSMutableArray alloc] init];
    }
    
    return _profileRecords;
}

@end
