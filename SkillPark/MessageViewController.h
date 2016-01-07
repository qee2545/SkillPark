//
//  MessageViewController.h
//  SkillPark
//
//  Created by qee on 2015/10/27.
//  Copyright © 2015年 qee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"

@interface MessageViewController : UIViewController
@property (nonatomic) User *theUser;
@property (nonatomic) NSMutableArray *messages;
@property (nonatomic) User *talkedUser;
@end
