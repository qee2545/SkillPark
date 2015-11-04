//
//  HeaderCollectionReusableView.m
//  SkillPark
//
//  Created by qee on 2015/10/22.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "HeaderCollectionReusableView.h"
#import "Utility.h"

@implementation HeaderCollectionReusableView

- (void)setHeaderViewWithUser:(UserModel *)user
{
    //head photo
    self.headPhotoImageView.image = user.headPhoto;
    self.headPhotoImageView.layer.cornerRadius =  self.headPhotoImageView.frame.size.width / 2.0;
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
    CGFloat imageHeight = self.headPhotoImageView.frame.size.height;
    CGFloat nameHeight = self.nameLabel.frame.size.height;
    CGFloat locationHeight = self.locationLabel.frame.size.height;
    UIFont *font = self.selfIntroLabel.font;
    CGSize selfIntroSize = CGSizeZero;
    if (self.selfIntroLabel.text.length > 0) {
        selfIntroSize = [Utility labelSizeForString:self.selfIntroLabel.text withFontName:font.fontName withFontSize:font.pointSize withLimitWidth:self.selfIntroLabel.frame.size.width];
    }
    //CGFloat buttonHeight = self.goodButton.frame.size.height;
    CGFloat buttonHeight = self.goodImageView.frame.size.height;
    
    CGFloat heightComponent =  imageHeight + nameHeight + locationHeight + selfIntroSize.height + buttonHeight + 16;
    
    //total height
    CGFloat height = heightConstraints + heightComponent;
    
    //[self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return CGSizeMake([UIScreen mainScreen].bounds.size
                      .width, height);
}

@end
