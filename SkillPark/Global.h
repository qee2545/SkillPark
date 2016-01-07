//
//  Global.h
//  SkillPark
//
//  Created by qee on 2015/10/30.
//  Copyright © 2015年 qee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "UIImageView+AFNetworking.h"
#import "SkillsTable.h"
#import "ProfilesTable.h"
#import "CommentsTable.h"
#import "CategoriesTable.h"
#import "User.h"
#import "Skill.h"
#import "SkillCategory.h"
#import "Message.h"

extern NSString *webTokenStr;
extern NSString *loginUserName;
extern User *loginUser;

extern ProfilesTable *profilesTable;
extern SkillsTable *skillsTable;
extern CategoriesTable *categoriesTable;
extern CommentsTable *commentsTable;

extern NSMutableArray<User*> *users;
extern NSMutableArray<Skill*> *skills;
extern NSMutableArray<SkillCategory*> *skillCategories;
extern NSMutableArray<Message*> *messages;

@interface Global : NSObject
{
   
}

+ (Global *)sharedInstance;
+ (NSMutableArray *)selectMessagesBetweenUser:(User *)user1 andUser:(User *)user2;
@end
