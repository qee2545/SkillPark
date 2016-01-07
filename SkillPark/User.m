//
//  User.m
//  SkillPark
//
//  Created by qee on 2015/11/4.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "User.h"

@implementation User

- (NSMutableArray *)skills
{
    if (!_skills) {
        _skills = [[NSMutableArray alloc] init];
    }
    
    return _skills;
}

- (NSMutableArray *)likeCategories
{
    if (!_likeCategories) {
        _likeCategories = [[NSMutableArray alloc] init];
    }
    
    return _likeCategories;
}

- (NSMutableArray *)favoriteUsers
{
    if (!_favoriteUsers) {
        _favoriteUsers = [[NSMutableArray alloc] init];
    }
    
    return _favoriteUsers;
}

- (void)printInfo
{
    NSLog(@"=======================================");
    NSLog(@"ID: %@", self.ID);
    NSLog(@"headPhoto: %@", self.headPhoto);
    NSLog(@"headPhotoURL: %@", self.headPhotoURL);
    NSLog(@"name: %@", self.name);
    NSLog(@"location: %@", self.location);
    NSLog(@"descript: %@", self.selfIntro);
    NSLog(@"skills count: %d", self.skills.count);
    for (int i = 0; i < self.skills.count; i++) {
        NSLog(@"skills ID: %@", self.skills[i].ID);
        NSLog(@"skills name: %@", self.skills[i].name);
    }
    NSLog(@"likedCategory count: %d", self.likeCategories.count);
    for (int i = 0; i < self.likeCategories.count; i++) {
        NSLog(@"likedCategory ID: %@", self.likeCategories[i].ID);
        NSLog(@"likedCategory name: %@", self.likeCategories[i].name);
        NSLog(@"likedCategory iconURL: %@", self.likeCategories[i].iconURL);
    }
    NSLog(@"followCount: %@", self.followCount);
    NSLog(@"favoriteUsers count: %d", self.favoriteUsers.count);
    for (int i = 0; i < self.favoriteUsers.count; i++) {
        NSLog(@"favoriteUsers ID: %@", self.favoriteUsers[i].ID);
        NSLog(@"favoriteUsers name: %@", self.favoriteUsers[i].name);
    }
    NSLog(@"=======================================");
}

@end
