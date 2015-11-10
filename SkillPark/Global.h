//
//  Global.h
//  SkillPark
//
//  Created by qee on 2015/10/30.
//  Copyright © 2015年 qee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "SkillModel.h"
#import "CommentModel.h"
#import "CategoryModel.h"

#import "SkillsTable.h"
#import "ProfilesTable.h"
#import "CommentsTable.h"
#import "CategoriesTable.h"

extern NSString *webTokenStr;
extern NSString *loginUserName;
extern UserModel* loginUser;
extern NSMutableArray<UserModel*> *allUsers;
extern NSMutableArray<SkillModel*> *allSkills;
extern NSMutableArray<CommentModel*> *allComments;
extern NSMutableArray<CategoryModel*> *allCategories;

extern SkillsTable *skillsTable;
extern ProfilesTable *profilesTable;
extern CommentsTable *commentsTable;
extern CategoriesTable *categoriesTable;


@interface Global : NSObject
{
   
}

+ (Global *)sharedInstance;
@end
