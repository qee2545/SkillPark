//
//  MainCollectionViewCell.m
//  SkillPark
//
//  Created by qee on 2015/10/26.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "MainCollectionViewCell.h"
#import "Utility.h"
#import <AFNetworking/AFNetworking.h>
#import "UIImageView+AFNetworking.h"

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

- (void)setContentWithSkill:(SkillModel *)skill
{
    //skill image
    self.skillImageView.image = skill.image;
    //self.skillImageView.image = skill.images[0];
    
    //title
    self.titleLabel.text = skill.title;
    
    //description
    self.descriptLabel.text = skill.descript;
    
    //head photo
    self.headPhotoImageView.image = skill.owner.headPhoto;
    self.headPhotoImageView.layer.cornerRadius = self.headPhotoImageView.frame.size.width / 2.0;
    self.headPhotoImageView.clipsToBounds = YES;

    
//    NSURL *url = [NSURL URLWithString:skill.owner.headPhotoURL];
//    NSURLRequest *urlRequest =  [NSURLRequest requestWithURL:url];
//    [self.headPhotoImageView setImageWithURLRequest:urlRequest
//                                   placeholderImage:nil
//                                            success:^(NSURLRequest *request, NSHTTPURLResponse * __nullable response, UIImage *image) {
//                                                NSLog(@"success:%@", response);
//                                                self.headPhotoImageView.image = image;
//                                                skill.owner.headPhoto = image;
//                                            }
//                                            failure:^(NSURLRequest *request, NSHTTPURLResponse * __nullable response, NSError *error) {
//                                                NSLog(@"error:%@", response);
//                                            }
//     ];
    
    //name
    [self.nameButton setTitle:skill.owner.name forState:UIControlStateNormal];
    
    //location
    self.locationLabel.text = skill.owner.location;
    
    //like num
    self.likeNumLabel.text = [NSString stringWithFormat:@"%d", skill.likeNum];


    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 5.0f;
}

- (CGFloat) cellHeightForSkill:(SkillModel *)skill withLimitWidth:(CGFloat)cellWidth
{
    //skill image height
    CGFloat imageHeight = [Utility imageViewSizeForImage:skill.image withLimitWidth:cellWidth];
    if (isnan(imageHeight)) {
        imageHeight = 0;
    }
//    NSLog(@"image width:%f height:%f", skill.image.size.width, skill.image.size.height);
//    NSLog(@"after image width:%f height:%f", cellWidth, imageHeight);
    
    //title height
    UIFont *titleFont = self.titleLabel.font;
    CGSize titleSize = [Utility labelSizeForString:skill.title withFontName:titleFont.fontName withFontSize:titleFont.pointSize withLimitWidth:cellWidth];
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
    
    //NSLog(@"descriptSize.height:%f, cellStandard.descriptLabel.numberOfLines:%d", descriptSize.height, cellStandard.descriptLabel.numberOfLines);
    
    //head photo height
    CGFloat headPhotoHeight = self.headPhotoImageView.frame.size.height;
    
//    NSLog(@"imageHeight:%f, titleHeight:%f, descriptHeight:%f, headPhotoHeight:%f", imageHeight, titleHeight, descriptHeight, headPhotoHeight);
    
    CGFloat constraintHeight = self.titleTopConstraint.constant + self.descriptTopConstraint.constant + self.headPhotoTopConstraint.constant + self.headPhotoBottomConstraint.constant;
//    NSLog(@"constraintHeight: %f", constraintHeight);
    
    CGFloat cellHeight = imageHeight + titleHeight + descriptHeight + headPhotoHeight + constraintHeight;
    
    return cellHeight;
}

@end
