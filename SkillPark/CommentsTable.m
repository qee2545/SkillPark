//
//  CommentsTable.m
//  SkillPark
//
//  Created by qee on 2015/11/4.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "CommentsTable.h"
#import <AFNetworking/AFNetworking.h>

@implementation CommentsTable

- (NSMutableArray *)commentRecords
{
    if (!_commentRecords) {
        _commentRecords = [[NSMutableArray alloc] init];
    }
    
    return _commentRecords;
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
            NSString *content = apiDictionary[@"data"][i][@"content"];
            NSString *commentor = apiDictionary[@"data"][i][@"commentor"];
            NSString *commentedUser = apiDictionary[@"data"][i][@"commented_user"];
            
            CommentRecord *commentRecord = [[CommentRecord alloc] init];
            commentRecord.ID = ID;
            commentRecord.content = content;
            commentRecord.commentor = commentor;
            commentRecord.commentedUser = commentedUser;
       
            [self.commentRecords addObject:commentRecord];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"Error %@", error);
    }];
}

@end
