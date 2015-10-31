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

extern NSMutableArray<UserModel *> *allUsers;
extern NSMutableArray<SkillModel *> *allSkills;
extern NSMutableArray<CommentModel *> *allComments;
extern NSMutableArray<CategoryModel *> *allCategories;

@interface Global : NSObject
{
   
}

+ (Global *)sharedInstance;
@end
