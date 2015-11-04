//
//  SkillRecord.m
//  SkillPark
//
//  Created by qee on 2015/11/4.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "SkillRecord.h"

@implementation SkillRecord

- (NSMutableArray *)pictures
{
    if (!_pictures) {
        _pictures = [[NSMutableArray alloc] init];
    }
    
    return _pictures;
}

@end
