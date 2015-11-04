//
//  SkillsTable.m
//  SkillPark
//
//  Created by qee on 2015/11/4.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "SkillsTable.h"
#import <AFNetworking/AFNetworking.h>

@implementation SkillsTable

- (NSMutableArray *)skillRecords
{
    if (!_skillRecords) {
        _skillRecords = [[NSMutableArray alloc] init];
    }
    
    return _skillRecords;
}

- (void)getData
{
    NSLog(@"%s", __FUNCTION__);
    
    AFHTTPRequestOperationManager *manger = [[AFHTTPRequestOperationManager alloc] init];
    
    [manger GET:self.apiUrlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id _Nonnull responseObject) {
        NSLog(@"Success %@", responseObject);
        
        NSDictionary *apiDictionary = responseObject;
        NSNumber *recordCount = apiDictionary[@"metadata"][@"total"];
        self.recordCount = recordCount;
        for (int i = 0 ; i < [recordCount intValue]; i++) {
            NSNumber *ID = apiDictionary[@"data"][i][@"id"];
            NSString *name = apiDictionary[@"data"][i][@"name"];
            NSString *requirement = apiDictionary[@"data"][i][@"requirement"];
            NSString *description = apiDictionary[@"data"][i][@"description"];
            NSString *username = apiDictionary[@"data"][i][@"username"];
            NSString *location = apiDictionary[@"data"][i][@"location"];
            NSArray *category = apiDictionary[@"data"][i][@"category"];
            NSMutableArray *pictures = apiDictionary[@"data"][i][@"pictures"];
            NSNumber *likedUsersCount = apiDictionary[@"data"][i][@"liked_users_count"];
            
            SkillRecord *skillRecord = [[SkillRecord alloc] init];
            skillRecord.ID = ID;
            skillRecord.name = name;
            skillRecord.requirement = requirement;
            skillRecord.skillDescription = description;
            skillRecord.username = username;
            skillRecord.location = location;
            CategoryRecord *categoryRecord = [[CategoryRecord alloc] init];
            categoryRecord.ID = category[0][0];
            categoryRecord.name = category[0][1];
            categoryRecord.categoryIcon = category[0][2];
            skillRecord.category = categoryRecord;
            skillRecord.pictures = pictures;
            skillRecord.likedUsersCount = likedUsersCount;
            
            [self.skillRecords addObject:skillRecord];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"Error %@", error);
    }];
}

@end
