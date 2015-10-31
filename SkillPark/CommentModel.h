//
//  CommentModel.h
//  SkillPark
//
//  Created by qee on 2015/10/30.
//  Copyright © 2015年 qee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject
@property (nonatomic) NSNumber *ID;
@property (nonatomic) NSString *content;
@property (nonatomic) NSString *commentor;
@property (nonatomic) NSString *commented_user;

- (void)printInfo;
@end
