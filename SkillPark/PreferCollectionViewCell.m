//
//  PreferCollectionViewCell.m
//  SkillPark
//
//  Created by qee on 2015/10/27.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "PreferCollectionViewCell.h"

@implementation PreferCollectionViewCell

- (void)setPreferCellWithCategory:(CategoryModel *)category
{
    self.categoryLabel.text = category.name;
    self.categoryImageView.image = category.image;
}

@end
