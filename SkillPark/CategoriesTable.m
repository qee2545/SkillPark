//
//  CategoriesTable.m
//  SkillPark
//
//  Created by qee on 2015/11/4.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "CategoriesTable.h"
#import <AFNetworking/AFNetworking.h>

@implementation CategoriesTable

- (NSMutableArray *)categoryRecords {
    if (!_categoryRecords) {
        _categoryRecords = [[NSMutableArray alloc] init];
    }
    
    return _categoryRecords;
}

- (void)downloadData {
    AFHTTPRequestOperationManager *manger = [[AFHTTPRequestOperationManager alloc] init];
    
    [manger GET:self.apiUrlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id _Nonnull responseObject) {
        //NSLog(@"Success %@", responseObject);
        
        NSDictionary *apiDictionary = responseObject;
        NSNumber *recordCount = apiDictionary[@"metadata"][@"total"];
        self.recordCount = recordCount;
        
        [self.categoryRecords removeAllObjects];
        for (int i = 0 ; i < [recordCount intValue]; i++) {
            NSNumber *ID = apiDictionary[@"data"][i][@"id"];
            NSString *name = apiDictionary[@"data"][i][@"name"];
            NSString *categoryIcon = apiDictionary[@"data"][i][@"category_icon"];
            
            CategoryRecord *categoryRecord = [[CategoryRecord alloc] init];
            categoryRecord.ID = ID;
            categoryRecord.name = name;
            categoryRecord.categoryIconURL = categoryIcon;
            
            [self.categoryRecords addObject:categoryRecord];
        }
        
        NSLog(@"Category table download success");
        [self.delegate didFinishTableDownloadWithStyle:TableStyleCategory];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"Error %@", error);
    }];
}

@end
