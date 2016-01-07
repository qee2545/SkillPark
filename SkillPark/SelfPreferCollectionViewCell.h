//
//  SelfPreferCollectionViewCell.h
//  SkillPark
//
//  Created by qee on 2015/11/2.
//  Copyright © 2015年 qee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"

@interface SelfPreferCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;

- (void)setPreferCellWithCategory:(SkillCategory *)category;
@end
