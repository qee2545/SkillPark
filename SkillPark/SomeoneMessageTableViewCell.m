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

- (void)setContentWithUser:(UserModel *)user andMessage:(NSString *)message
{
    UIImage *image = user.headPhoto;
    self.headPhotoImageView.image = image;
    self.headPhotoImageView.layer.cornerRadius =  self.headPhotoImageView.frame.size.width / 2.0;
    self.headPhotoImageView.clipsToBounds = YES;

    self.nameLabel.text = user.name;
    //self.nameLabel.textColor = [UIColor whiteColor];
    
    self.messageWrapView.layer.cornerRadius = 10.0f;
    self.messageWrapView.backgroundColor = [UIColor colorWithRed:0.89 green:0.91 blue:0.92 alpha:1];//[UIColor whiteColor];
    self.messageWrapView.clipsToBounds = YES;
    [self.messageWrapView sizeToFit];
    
    self.messageLabel.text = message;
    [self.messageLabel sizeToFit];
}

@end
