//
//  SelfMessageTableViewCell.h
//  SkillPark
//
//  Created by qee on 2015/10/27.
//  Copyright © 2015年 qee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelfMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *messageWrapView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

- (void)setContentWithMessage:(NSString *)message;
@end
