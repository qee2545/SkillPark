//
//  CommentGroupModel.h
//  SkillPark
//
//  Created by qee on 2015/10/30.
//  Copyright © 2015年 qee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserModel;

@interface CommentGroupModel : NSObject

@property (nonatomic) NSMutableArray<NSDictionary *> *comments;
@property (nonatomic, weak) UserModel *talkedUser;

- (void) printInfo;
@end
