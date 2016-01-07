//
//  SomeoneMessageTableViewCell.m
//  SkillPark
//
//  Created by qee on 2015/10/27.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "SomeoneMessageTableViewCell.h"

@implementation SomeoneMessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContentWithUser:(User *)user andMessage:(NSString *)message {
    NSURL *url = [NSURL URLWithString:user.headPhotoURL];
    NSURLRequest *urlRequest =  [NSURLRequest requestWithURL:url];
    [self.headPhotoImageView setImageWithURLRequest:urlRequest
                                   placeholderImage:nil
                                            success:^(NSURLRequest *request, NSHTTPURLResponse * __nullable response, UIImage *image) {
                                                //NSLog(@"success:%@", response);
                                                self.headPhotoImageView.image = image;
                                            }
                                            failure:^(NSURLRequest *request, NSHTTPURLResponse * __nullable response, NSError *error) {
                                                //NSLog(@"error:%@", response);
                                            }
    ];
    self.headPhotoImageView.layer.cornerRadius =  self.headPhotoImageView.frame.size.width / 2.0;
    self.headPhotoImageView.clipsToBounds = YES;

    self.nameLabel.text = user.name;
    //self.nameLabel.textColor = [UIColor whiteColor];
    
    self.messageWrapView.layer.cornerRadius = 10.0f;
    self.messageWrapView.backgroundColor = [UIColor colorWithRed:0.89 green:0.91 blue:0.92 alpha:1];
    self.messageWrapView.clipsToBounds = YES;
    [self.messageWrapView sizeToFit];
    
    self.messageLabel.text = message;
    [self.messageLabel sizeToFit];
}

@end
