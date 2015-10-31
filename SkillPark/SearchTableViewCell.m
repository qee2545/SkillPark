//
//  SearchTableViewCell.m
//  SkillPark
//
//  Created by qee on 2015/10/27.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContentWithSkill:(SkillModel *)skill
{
    self.skillImageView.image = skill.images[skill.images.count - 1];
    self.titleLabel.text = skill.title;
    if ([skill.owner.location length] > 0) {
        self.locationLabel.text = [NSString stringWithFormat:@"@%@", skill.owner.location];
    }
    else {
        self.locationLabel.text = @"";
    }
    
}
@end
