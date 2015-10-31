//
//  PreferCollectionViewCell.h
//  SkillPark
//
//  Created by qee on 2015/10/27.
//  Copyright © 2015年 qee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreferCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

- (void)setPreferCellWith:(NSString *)category;
@end
