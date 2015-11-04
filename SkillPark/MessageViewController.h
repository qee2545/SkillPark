//
//  MessageViewController.h
//  SkillPark
//
//  Created by qee on 2015/10/27.
//  Copyright © 2015年 qee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "CommentGroupModel.h"
#import "Global.h"

@interface MessageViewController : UIViewController
@property (nonatomic) UserModel *theUser;
@property (nonatomic) CommentGroupModel *commentGroup;
@property (nonatomic) UserModel *talkedUser;
@end
