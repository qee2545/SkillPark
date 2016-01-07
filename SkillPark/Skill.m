//
//  Skill.m
//  SkillPark
//
//  Created by qee on 2015/11/4.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "Skill.h"

@implementation Skill

- (NSMutableArray *)images
{
    if (!_images) {
        _images = [[NSMutableArray alloc] init];
    }
    
    return _images;
}

- (NSMutableArray *)imagesURL
{
    if (!_imagesURL) {
        _imagesURL = [[NSMutableArray alloc] init];
    }
    
    return _imagesURL;
}

- (void)printInfo
{
    NSLog(@"=======================================");
    
    NSLog(@"ID: %@", self.ID);
    NSLog(@"name: %@", self.name);
    NSLog(@"requirement: %@", self.requirement);
    NSLog(@"descript: %@", self.descript);
    NSLog(@"username: %@", self.username);
    NSLog(@"location: %@", self.location);
    NSLog(@"belongCategory.ID: %@", self.belongCategory.ID);
    NSLog(@"belongCategory.name: %@", self.belongCategory.name);
    
    NSLog(@"imagesURL count: %d", self.imagesURL.count);
    for (int i = 0; i < self.imagesURL.count; i++) {
        NSLog(@"imagesURL: %@", self.imagesURL[i]);
    }

    NSLog(@"likeCount: %@", self.likeCount);

    NSLog(@"=======================================");
}

@end
