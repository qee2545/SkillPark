//
//  MessageListTableViewCell.h
//  SkillPark
//
//  Created by qee on 2015/10/28.
//  Copyright © 2015年 qee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentGroupModel.h"
#import "UserModel.h"

@interface MessageListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headPhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMessageLabel;

- (void)setContentWithCommentGroup:(CommentGroupModel *)commentGroup;
@end
