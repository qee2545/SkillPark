//
//  FollowTableViewCell.h
//  SkillPark
//
//  Created by qee on 2015/11/3.
//  Copyright © 2015年 qee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"

@interface FollowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *followHeadImageView;
@property (weak, nonatomic) IBOutlet UILabel *followNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *followLocationLabel;

- (void)setContentWithUser:(User *)followUser;
@end
