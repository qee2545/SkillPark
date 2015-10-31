//
//  SomeoneMessageTableViewCell.h
//  SkillPark
//
//  Created by qee on 2015/10/27.
//  Copyright © 2015年 qee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface SomeoneMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headPhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *messageWrapView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

- (void)setContentWithUser:(UserModel *)user andMessage:(NSString *)message;
@end
