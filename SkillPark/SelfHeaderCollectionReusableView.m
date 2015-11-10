//
//  SelfHeaderCollectionReusableView.m
//  SkillPark
//
//  Created by qee on 2015/11/2.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "SelfHeaderCollectionReusableView.h"
#import "Utility.h"

@implementation SelfHeaderCollectionReusableView
- (void)setHeaderViewWithUser:(UserModel *)user
{
    //head photo
    self.headPhotoImageView.image = user.headPhoto;
    self.headPhotoImageView.layer.cornerRadius =  self.headPhotoImageView.frame.size.width / 2.0;
    self.headPhotoImageView.layer.borderWidth = 2.0f;
    self.headPhotoImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.headPhotoImageView.clipsToBounds = YES;
    
    //name
    self.nameLabel.text = user.name;
    
    //location
    if ([user.location length] > 0) {
        self.locationLabel.text = [NSString stringWithFormat:@"@%@", user.location];
    }
    else {
        self.locationLabel.text = @"";
    }
    
    //self intro
    self.selfIntroLabel.text = user.descript;
    
    //good label
    self.goodLabel.layer.borderWidth = 1.0f;
    self.goodLabel.layer.borderColor = [[UIColor blackColor] CGColor];
    
    //learn label
    self.learnLabel.layer.borderWidth = 1.0f;
    self.learnLabel.layer.borderColor = [[UIColor blackColor] CGColor];
}

- (CGSize)sizeOfHeaderView
{
    CGFloat width = self.headerView.frame.size.width;
    
    //constraint height
    CGFloat heightConstraints = 0;
    for (NSLayoutConstraint *constraint in self.heightConstraints) {
        heightConstraints += constraint.constant;
    }
    
    //all component height
    CGFloat backgroundImageHeight = self.backgroundImageView.frame.size.height;
    CGFloat headPhotoImageHeight = self.headPhotoImageView.frame.size.height;
    UIFont *font = self.selfIntroLabel.font;
    CGSize selfIntroSize = CGSizeZero;
    if (self.selfIntroLabel.text.length > 0) {
        selfIntroSize = [Utility labelSizeForString:self.selfIntroLabel.text withFontName:font.fontName withFontSize:font.pointSize withLimitWidth:self.selfIntroLabel.frame.size.width];
    }
    CGFloat goodViewHeight = self.goodImageView.frame.size.height;
    
    CGFloat heightComponent =  backgroundImageHeight + headPhotoImageHeight + selfIntroSize.height + goodViewHeight + 8;
    
    //total height
    CGFloat height = heightConstraints + heightComponent;
    
    //[self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return CGSizeMake([UIScreen mainScreen].bounds.size
                      .width, height);
}

@end
