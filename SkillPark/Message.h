//
//  Message.h
//  SkillPark
//
//  Created by qee on 2016/1/2.
//  Copyright © 2016年 qee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Message : NSObject
@property (nonatomic) NSNumber *ID;
@property (nonatomic, weak) User *fromUser;
@property (nonatomic, weak) User *toUser;
@property (nonatomic) NSString *message;

- (void)printInfo;
@end
