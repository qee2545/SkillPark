//
//  PersonCollectionViewCell.h
//  SkillPark
//
//  Created by qee on 2015/10/21.
//  Copyright © 2015年 qee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkillModel.h"

@interface PersonCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *skillImageView;

//- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes;

- (void)setPersonCellWithSkill:(SkillModel *)skill;
@end
