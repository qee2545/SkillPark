//
//  UerModel.m
//  SkillPark
//
//  Created by qee on 2015/10/17.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "userModel.h"

@implementation UserModel

- (void)printInfo
{
    NSLog(@"name: %@", self.name);
    NSLog(@"descript: %@", self.descript);
    NSLog(@"headPhoto: %@", self.headPhoto);
    NSLog(@"headPhotoURL: %@", self.headPhotoURL);
    NSLog(@"location: %@", self.location);
     NSLog(@"likedCategory count: %d", self.likedCategory.count);
    for (int i = 0; i < self.likedCategory.count; i++) {
        NSLog(@"category ID: %@", self.likedCategory[i].ID);
        NSLog(@"category name: %@", self.likedCategory[i].name);
        NSLog(@"category image: %@", self.likedCategory[i].image);
        NSLog(@"category imageURL: %@", self.likedCategory[i].imageURL);
    }
    
    NSLog(@"followingNum: %d", self.followingNum);
}

- (void)printCommentGroup
{
    NSLog(@"user:%@", self.name);
    for (CommentGroupModel *commentGroup in self.commentsGroup) {
        NSLog(@"=============================");
        for (NSDictionary *dic in commentGroup.comments) {
            if ([dic[@"to"] intValue] == 1) {
                NSLog(@"-> %@ : %@", commentGroup.talkedUser.name, dic[@"comment"]);
            }
            else {
                NSLog(@"<- %@ : %@", commentGroup.talkedUser.name, dic[@"comment"]);
            }
        }
    }
}

@end
