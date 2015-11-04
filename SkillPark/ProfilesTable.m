//
//  ProfilesTable.m
//  SkillPark
//
//  Created by qee on 2015/11/4.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "ProfilesTable.h"
#import <AFNetworking/AFNetworking.h>

@implementation ProfilesTable

- (NSMutableArray *)profileRecords
{
    if (!_profileRecords) {
        _profileRecords = [[NSMutableArray alloc] init];
    }
    
    return _profileRecords;
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
            NSString *username = apiDictionary[@"data"][i][@"username"];
            NSString *description = apiDictionary[@"data"][i][@"description"];
            NSString *photo = apiDictionary[@"data"][i][@"photo"];
            NSString *location = apiDictionary[@"data"][i][@"location"];
            NSArray *category = apiDictionary[@"data"][i][@"category"];
            NSNumber *favoritedUsersCount = apiDictionary[@"data"][i][@"favorited_users_count"];
            NSArray *favorites = apiDictionary[@"data"][i][@"favorites"];
            
            ProfileRecord *profileRecord = [[ProfileRecord alloc] init];
            profileRecord.ID = ID;
            profileRecord.username = username;
            profileRecord.profileDescription = description;
            profileRecord.photo = photo;
            profileRecord.location = location;
            for (int j = 0; j < category.count; j++) {
                CategoryRecord *categoryRecord = [[CategoryRecord alloc] init];
                categoryRecord.ID = category[j][0];
                categoryRecord.name = category[j][1];
                categoryRecord.categoryIcon = category[j][2];
                [profileRecord.category addObject:categoryRecord];
            }
            profileRecord.favoritedUsersCount = favoritedUsersCount;
            for (int j = 0; j < favorites.count; j++) {
                NSMutableArray *favorite = [[NSMutableArray alloc] init];
                favorite[0] = favorites[j][0];
                favorite[1] = favorites[j][1];
                [profileRecord.favorites addObject:favorite];
            }
            
            [self.profileRecords addObject:profileRecord];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"Error %@", error);
    }];
}

@end
