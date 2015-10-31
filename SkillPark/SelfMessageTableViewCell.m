//
//  SelfMessageTableViewCell.m
//  SkillPark
//
//  Created by qee on 2015/10/27.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "SelfMessageTableViewCell.h"

@implementation SelfMessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContentWithMessage:(NSString *)message
{
    self.messageWrapView.layer.cornerRadius = 10.0f;
    self.messageWrapView.backgroundColor = [UIColor colorWithRed:0.74 green:0.95 blue:0.53 alpha:1];//[UIColor whiteColor];
    self.messageWrapView.clipsToBounds = YES;
    
    self.messageLabel.text = message;
    [self.messageLabel sizeToFit];
}

@end
