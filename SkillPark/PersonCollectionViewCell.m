//
//  PersonCollectionViewCell.m
//  SkillPark
//
//  Created by qee on 2015/10/21.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "PersonCollectionViewCell.h"


@implementation PersonCollectionViewCell

- (void)setPersonCellWithSkill:(SkillModel *)skill
{
    self.titleLabel.text = skill.title;
    self.skillImageView.image = skill.image;
}

@end
