//
//  PersonCollectionViewController.h
//  SkillPark
//
//  Created by qee on 2015/10/21.
//  Copyright © 2015年 qee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface PersonCollectionViewController : UICollectionViewController
@property (nonatomic) UserModel *theUser;
@end