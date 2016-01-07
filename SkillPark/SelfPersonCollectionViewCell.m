//
//  SelfPersonCollectionViewCell.m
//  SkillPark
//
//  Created by qee on 2015/11/2.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "SelfPersonCollectionViewCell.h"

@implementation SelfPersonCollectionViewCell

- (void)setPersonCellWithSkill:(Skill *)skill {
    self.titleLabel.text = skill.name;
    self.skillImageView.image = skill.presentImage;
}

@end
