//
//  MainCollectionViewCell.h
//  SkillPark
//
//  Created by qee on 2015/10/26.
//  Copyright © 2015年 qee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"

@interface MainCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *skillImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headPhotoImageView;
@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeNumLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headPhotoTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headPhotoBottomConstraint;

- (void)resetContent;
- (void)setContentWithSkill:(Skill *)skill;
- (CGFloat) cellHeightForSkill:(Skill *)skill withLimitWidth:(CGFloat)cellWidth;
@end
