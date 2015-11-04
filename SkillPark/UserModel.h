//
//  UserModel.h
//  SkillPark
//
//  Created by qee on 2015/10/17.
//  Copyright © 2015年 qee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CategoryModel.h"
#import "CommentModel.h"
#import "CommentGroupModel.h"

@class SkillModel;

@interface UserModel : NSObject

@property (nonatomic) NSNumber *ID;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *descript;
@property (nonatomic) UIImage *headPhoto;
@property (nonatomic) NSString *headPhotoURL;
@property (nonatomic) NSString *location;
@property (nonatomic) NSMutableArray<CategoryModel*> *likedCategory;
@property (nonatomic, assign) unsigned int followingNum;
@property (nonatomic) NSMutableArray<SkillModel*> *skills;
@property (nonatomic) NSMutableArray<CommentModel*> *comments;
@property (nonatomic) NSMutableArray<CommentGroupModel*> *commentsGroup;
@property (nonatomic) NSMutableArray<NSMutableArray*> *favorites;
@property (nonatomic) NSMutableArray<__weak UserModel*> *followUsers;

- (void)printInfo;
- (void)printCommentGroup;
@end
