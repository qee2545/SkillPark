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

- (void)setContentWithMessages:(Message *)lastMessage {
    User *talkedUser;
    if (lastMessage.fromUser == loginUser) {
        talkedUser = lastMessage.toUser;
    }
    else {
        talkedUser = lastMessage.fromUser;
    }
    
    NSURL *url = [NSURL URLWithString:talkedUser.headPhotoURL];
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
    self.nameLabel.text = talkedUser.name;
    self.lastMessageLabel.text = lastMessage.message;
    [self.lastMessageLabel sizeToFit];
}

@end
