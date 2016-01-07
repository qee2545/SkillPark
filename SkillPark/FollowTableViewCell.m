//
//  FollowTableViewCell.m
//  SkillPark
//
//  Created by qee on 2015/11/3.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "FollowTableViewCell.h"

@implementation FollowTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContentWithUser:(User *)followUser {
    self.followHeadImageView.image = followUser.headPhoto;
    NSURL *url = [NSURL URLWithString:followUser.headPhotoURL];
    NSURLRequest *urlRequest =  [NSURLRequest requestWithURL:url];
    [self.followHeadImageView setImageWithURLRequest:urlRequest
                                   placeholderImage:nil
                                            success:^(NSURLRequest *request, NSHTTPURLResponse * __nullable response, UIImage *image) {
                                                //NSLog(@"success:%@", response);
                                                self.followHeadImageView.image = image;
                                            }
                                            failure:^(NSURLRequest *request, NSHTTPURLResponse * __nullable response, NSError *error) {
                                                //NSLog(@"error:%@", response);
                                            }
    ];
    self.followHeadImageView.layer.cornerRadius =  self.followHeadImageView.frame.size.width / 2.0;
    self.followHeadImageView.clipsToBounds = YES;
    
    self.followNameLabel.text = followUser.name;
    
    self.followLocationLabel.text = [NSString stringWithFormat:@"@%@", followUser.location];
}

@end
