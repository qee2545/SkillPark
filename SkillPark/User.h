//
//  User.h
//  SkillPark
//
//  Created by qee on 2015/11/4.
//  Copyright © 2015年 qee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Skill.h"
#import "SkillCategory.h"

@interface User : NSObject
@property (nonatomic) NSNumber *ID;
@property (nonatomic) UIImage *headPhoto;
@property (nonatomic) NSString *headPhotoURL;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *location;
@property (nonatomic) NSString *selfIntro;
@property (nonatomic) NSMutableArray<Skill*> *skills;
@property (nonatomic) NSMutableArray<SkillCategory*> *likeCategories;
@property (nonatomic) NSNumber *followCount;
@property (nonatomic) NSMutableArray<__weak User*> *favoriteUsers;

- (void)printInfo;
@end
