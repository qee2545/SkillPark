//
//  CommentGroupModel.m
//  SkillPark
//
//  Created by qee on 2015/10/30.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "CommentGroupModel.h"

@implementation CommentGroupModel

- (void) printInfo
{
    for (NSDictionary *dic in self.comments) {
        if (dic[@"to"]) {
            NSLog(@"-> %@ : %@", self.talkedUser, dic[@"comment"]);
        }
        else {
            NSLog(@"<- %@ : %@", self.talkedUser, dic[@"comment"]);
        }
    }
}

@end
