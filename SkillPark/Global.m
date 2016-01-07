//
//  Global.m
//  SkillPark
//
//  Created by qee on 2015/10/30.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "Global.h"

NSString *webTokenStr;
NSString *loginUserName;
User *loginUser;

SkillsTable *skillsTable;
ProfilesTable *profilesTable;
CommentsTable *commentsTable;
CategoriesTable *categoriesTable;

NSMutableArray<User*> *users;
NSMutableArray<Skill*> *skills;
NSMutableArray<SkillCategory*> *skillCategories;
NSMutableArray<Message*> *messages;

@implementation Global

+ (Global *)sharedInstance
{
    static Global *myInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        myInstance = [[self alloc] init];
    });
    
    return myInstance;
}

+ (NSMutableArray *)selectMessagesBetweenUser:(User *)user1 andUser:(User *)user2 {
    NSMutableArray *answerMessages = [[NSMutableArray alloc] init];
    for (Message *message in messages) {
        if ( ((message.fromUser == user1) && (message.toUser == user2)) ||
             ((message.fromUser == user2) && (message.toUser == user1)) ) {
            [answerMessages addObject:message];
        }
    }
    
    return answerMessages;
}

@end
