//
//  CommentRecord.h
//  SkillPark
//
//  Created by qee on 2015/11/4.
//  Copyright © 2015年 qee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentRecord : NSObject

@property (nonatomic) NSNumber *ID;
@property (nonatomic) NSString *content;
@property (nonatomic) NSString *commentor;
@property (nonatomic) NSString *commentedUser;

@end
