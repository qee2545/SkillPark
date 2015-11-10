//
//  Global.m
//  SkillPark
//
//  Created by qee on 2015/10/30.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "Global.h"

NSString *webTokenStr;
NSString *loginUserName;
UserModel *loginUser;
NSMutableArray<UserModel *> *allUsers;
NSMutableArray<SkillModel *> *allSkills;
NSMutableArray<CommentModel *> *allComments;
NSMutableArray<CategoryModel *> *allCategories;

SkillsTable *skillsTable;
ProfilesTable *profilesTable;
CommentsTable *commentsTable;
CategoriesTable *categoriesTable;

@implementation Global

+ (Global *)sharedInstance
{
    static Global *myInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        myInstance = [[self alloc] init];
    });
    
    return myInstance;
}

@end
