//
//  SearchTableViewCell.h
//  SkillPark
//
//  Created by qee on 2015/10/27.
//  Copyright © 2015年 qee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkillModel.h"

@interface SearchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *skillImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

- (void)setContentWithSkill:(SkillModel *)skill;
@end
