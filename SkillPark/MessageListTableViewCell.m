//
//  MessageListTableViewCell.m
//  SkillPark
//
//  Created by qee on 2015/10/28.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "MessageListTableViewCell.h"

@implementation MessageListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContentWithCommentGroup:(CommentGroupModel *)commentGroup;
{
//    UIImage *image = [UIImage imageNamed:@"headPhoto"];
//    self.headPhotoImageView.image = image;
//    self.headPhotoImageView.layer.cornerRadius =  self.headPhotoImageView.frame.size.width / 2.0;
//    self.headPhotoImageView.clipsToBounds = YES;
//    
//    self.nameLabel.text = @"楊力怡";
//    
//    self.lastMessageLabel.text = @"last message";
//    [self.lastMessageLabel sizeToFit];
    
    UIImage *image = commentGroup.talkedUser.headPhoto;
    self.headPhotoImageView.image = image;
    self.headPhotoImageView.layer.cornerRadius =  self.headPhotoImageView.frame.size.width / 2.0;
    self.headPhotoImageView.clipsToBounds = YES;
    
    self.nameLabel.text = commentGroup.talkedUser.name;
    
    self.lastMessageLabel.text = commentGroup.comments[commentGroup.comments.count - 1][@"comment"];
    [self.lastMessageLabel sizeToFit];

}

@end
