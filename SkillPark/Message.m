//
//  Message.m
//  SkillPark
//
//  Created by qee on 2016/1/2.
//  Copyright © 2016年 qee. All rights reserved.
//

#import "Message.h"

@implementation Message

- (void)printInfo
{
    NSLog(@"=======================================");
    
    NSLog(@"ID: %@", self.ID);
    NSLog(@"From: %@", self.fromUser.name);
    NSLog(@"To: %@", self.toUser.name);
    NSLog(@"message: %@", self.message);
    
    NSLog(@"=======================================");
}

@end
