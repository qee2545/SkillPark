//
//  SelfPreferCollectionViewCell.m
//  SkillPark
//
//  Created by qee on 2015/11/2.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "SelfPreferCollectionViewCell.h"

@implementation SelfPreferCollectionViewCell

- (void)setPreferCellWithCategory:(SkillCategory *)category {
    self.categoryLabel.text = category.name;
    NSURL *url = [NSURL URLWithString:category.iconURL];
    NSURLRequest *urlRequest =  [NSURLRequest requestWithURL:url];
    [self.categoryImageView setImageWithURLRequest:urlRequest
                                  placeholderImage:nil
                                           success:^(NSURLRequest *request, NSHTTPURLResponse * __nullable response, UIImage *image) {
                                               //NSLog(@"success:%@", response);
                                               self.categoryImageView.image = image;
                                           }
                                           failure:^(NSURLRequest *request, NSHTTPURLResponse * __nullable response, NSError *error) {
                                               //NSLog(@"error:%@", response);
                                           }
    ];
}

@end
