//
//  SelfPreferCollectionViewCell.m
//  SkillPark
//
//  Created by qee on 2015/11/2.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "SelfPreferCollectionViewCell.h"

@implementation SelfPreferCollectionViewCell

- (void)setPreferCellWithCategory:(CategoryModel *)category
{
    self.categoryLabel.text = category.name;
    self.categoryImageView.image = category.image;
}

@end
