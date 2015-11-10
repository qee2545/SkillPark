//
//  UserMessage.h
//  SkillPark
//
//  Created by qee on 2015/11/4.
//  Copyright © 2015年 qee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

enum MessageDirection {
    TO,
    FROM
};

@interface UserMessage : NSObject

@property (nonatomic) enum MessageDirection direction;
@property (nonatomic) NSMutableArray<NSString *> *message;
@property (nonatomic, weak) User *talkedUser;

@end
