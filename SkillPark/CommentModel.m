//
//  CommentModel.m
//  SkillPark
//
//  Created by qee on 2015/10/30.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

- (void)printInfo
{
    NSLog(@"id: %@", self.ID);
    NSLog(@"comment: %@", self.content);
    NSLog(@"commentor: %@", self.commentor);
    NSLog(@"commented_user: %@", self.commented_user);
}

@end
