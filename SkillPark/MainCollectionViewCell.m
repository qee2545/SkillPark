//
//  MainCollectionViewCell.m
//  SkillPark
//
//  Created by qee on 2015/10/26.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "MainCollectionViewCell.h"
#import "Utility.h"

@implementation MainCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)resetContent
{
    self.skillImageView.image = nil;
    self.titleLabel.text = @"";
    self.descriptLabel.text = @"";
    self.headPhotoImageView.image = nil;
    [self.nameButton setTitle:@"" forState:UIControlStateNormal];
    self.locationLabel.text = @"";
    self.likeNumLabel.text = @"";
}

- (void)setContentWithSkill:(Skill *)skill
{
    //skill image
    if (skill.images.count > 0) {
        self.skillImageView.image = skill.presentImage;
    }
    
    //title
    self.titleLabel.text = skill.name;
    
    //description
    self.descriptLabel.text = skill.descript;
    
    //head photo
    NSURL *url = [NSURL URLWithString:skill.owner.headPhotoURL];
    NSURLRequest *urlRequest =  [NSURLRequest requestWithURL:url];
    [self.headPhotoImageView setImageWithURLRequest:urlRequest
                                   placeholderImage:nil
                                            success:^(NSURLRequest *request, NSHTTPURLResponse * __nullable response, UIImage *image) {
                                                //NSLog(@"success:%@", response);
                                                self.headPhotoImageView.image = image;
                                                //skill.owner.headPhoto = image;
                                            }
                                            failure:^(NSURLRequest *request, NSHTTPURLResponse * __nullable response, NSError *error) {
                                                //NSLog(@"error:%@", response);
                                            }
    ];
    self.headPhotoImageView.layer.cornerRadius = self.headPhotoImageView.frame.size.width / 2.0;
    self.headPhotoImageView.clipsToBounds = YES;
    
    //name
    [self.nameButton setTitle:skill.owner.name forState:UIControlStateNormal];
    
    //location
    self.locationLabel.text = skill.owner.location;
    
    //like num
    self.likeNumLabel.text = [NSString stringWithFormat:@"%@", skill.likeCount];


    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 5.0f;
}

- (CGFloat)cellHeightForSkill:(Skill *)skill withLimitWidth:(CGFloat)cellWidth
{
    //skill image height
    CGFloat imageHeight = 0;
    if (skill.images.count > 0) {
        imageHeight = [Utility imageViewSizeForImage:skill.images[0] withLimitWidth:cellWidth];
        if (isnan(imageHeight)) {
            imageHeight = 0;
        }
    }
    
    //title height
    UIFont *titleFont = self.titleLabel.font;
    CGSize titleSize = [Utility labelSizeForString:skill.name withFontName:titleFont.fontName withFontSize:titleFont.pointSize withLimitWidth:cellWidth];
    CGFloat titleHeight = titleSize.height;
    
    //descript height
    UIFont *descriptFont = self.descriptLabel.font;
    CGSize oneLineDescriptSize = [Utility labelSizeForString:@"one" withFontName:descriptFont.fontName withFontSize:descriptFont.pointSize withLimitWidth:cellWidth];
    CGSize descriptSize = [Utility labelSizeForString:skill.descript withFontName:descriptFont.fontName withFontSize:descriptFont.pointSize withLimitWidth:cellWidth];
    
    CGFloat limitDescriptHeight = oneLineDescriptSize.height * self.descriptLabel.numberOfLines;
    CGFloat descriptHeight = descriptSize.height;
    if (descriptSize.height > limitDescriptHeight) {
        descriptHeight = limitDescriptHeight;
    }

    //head photo height
    CGFloat headPhotoHeight = self.headPhotoImageView.frame.size.height;

    CGFloat constraintHeight = self.titleTopConstraint.constant + self.descriptTopConstraint.constant + self.headPhotoTopConstraint.constant + self.headPhotoBottomConstraint.constant;
    
    CGFloat cellHeight = imageHeight + titleHeight + descriptHeight + headPhotoHeight + constraintHeight;
    
    return cellHeight;
}

@end
