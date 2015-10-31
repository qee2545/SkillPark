//
//  SkillModel.m
//  SkillPark
//
//  Created by qee on 2015/10/15.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "SkillModel.h"

@implementation SkillModel

- (void)printInfo
{
    NSLog(@"title: %@", self.title);
    NSLog(@"requirement: %@", self.requirement);
    NSLog(@"descript: %@", self.descript);
    NSLog(@"username: %@", self.username);
    NSLog(@"location: %@", self.location);
    NSLog(@"belongCategory count: %d", self.belongCategory.count);
    for (int i = 0; i < self.belongCategory.count; i++) {
        NSLog(@"category ID: %@", self.belongCategory[i].ID);
        NSLog(@"category name: %@", self.belongCategory[i].name);
        NSLog(@"category image: %@", self.belongCategory[i].image);
        NSLog(@"category imageURL: %@", self.belongCategory[i].imageURL);
    }
    for (int i = 0; i < self.images.count; i++) {
        NSLog(@"image: %@", self.images[i]);
    }
    for (int i = 0; i < self.imagesURL.count; i++) {
        NSLog(@"imageURL: %@", self.imagesURL[i]);
    }
    NSLog(@"image: %@", self.image);
    NSLog(@"likeNum: %d", self.likeNum);
}
@end
