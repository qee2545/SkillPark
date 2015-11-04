//
//  SkillRecord.h
//  SkillPark
//
//  Created by qee on 2015/11/4.
//  Copyright © 2015年 qee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryRecord.h"

@interface SkillRecord : NSObject

@property (nonatomic) NSNumber *ID;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *requirement;
@property (nonatomic) NSString *skillDescription;
@property (nonatomic) NSString *username;
@property (nonatomic) NSString *location;
@property (nonatomic) CategoryRecord *category;
@property (nonatomic) NSMutableArray<NSString *> *pictures;

@end
