//
//  PersonCollectionViewCell.m
//  SkillPark
//
//  Created by qee on 2015/10/21.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "PersonCollectionViewCell.h"


@implementation PersonCollectionViewCell

- (void)setPersonCellWithSkill:(Skill *)skill {
    self.titleLabel.text = skill.name;
    self.skillImageView.image = skill.presentImage;
}

@end
