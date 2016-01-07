//
//  Skill.h
//  SkillPark
//
//  Created by qee on 2015/11/4.
//  Copyright © 2015年 qee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkillCategory.h"

@class User;

@interface Skill : NSObject
@property (nonatomic) NSNumber *ID;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *requirement;
@property (nonatomic) NSString *descript;
@property (nonatomic) NSString *username;
@property (nonatomic, weak) User *owner;
@property (nonatomic) NSString *location;
@property (nonatomic) SkillCategory *belongCategory;
@property (nonatomic) UIImage *presentImage;
@property (nonatomic) NSMutableArray<UIImage *> *images;
@property (nonatomic) NSMutableArray<NSString *> *imagesURL;
@property (nonatomic) NSNumber *likeCount;

- (void)printInfo;
@end
