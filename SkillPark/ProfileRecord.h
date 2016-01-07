//
//  ProfileRecord.h
//  SkillPark
//
//  Created by qee on 2015/11/4.
//  Copyright © 2015年 qee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryRecord.h"

@interface ProfileRecord : NSObject
@property (nonatomic) NSNumber *ID;
@property (nonatomic) NSString *username;
@property (nonatomic) NSString *profileDescription;
@property (nonatomic) NSString *photo;
@property (nonatomic) NSString *location;
@property (nonatomic) NSMutableArray<CategoryRecord*> *category;
@property (nonatomic) NSNumber *favoritedUsersCount;
@property (nonatomic) NSMutableArray<NSMutableArray*> *favorites;
@end
