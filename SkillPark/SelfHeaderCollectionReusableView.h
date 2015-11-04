//
//  SelfHeaderCollectionReusableView.h
//  SkillPark
//
//  Created by qee on 2015/11/2.
//  Copyright © 2015年 qee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"

@interface SelfHeaderCollectionReusableView : UICollectionReusableView

@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *heightConstraints;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headPhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *selfIntroLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodLabel;
@property (weak, nonatomic) IBOutlet UILabel *learnLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
@property (weak, nonatomic) IBOutlet UIImageView *learnImageView;
@property (weak, nonatomic) IBOutlet UIImageView *messageImageView;

- (void)setHeaderViewWithUser:(UserModel *)user;
- (CGSize)sizeOfHeaderView;
@end
