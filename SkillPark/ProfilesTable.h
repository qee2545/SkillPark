//
//  ProfilesTable.h
//  SkillPark
//
//  Created by qee on 2015/11/4.
//  Copyright © 2015年 qee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProfileRecord.h"
#import "DownloadDelegate.h"

@interface ProfilesTable : NSObject
@property (nonatomic) NSNumber *recordCount;
@property (nonatomic) NSMutableArray<ProfileRecord*> *profileRecords;
@property (nonatomic) NSString *apiUrlStr;
@property (nonatomic, weak) id<DownloadDelegate> delegate;

- (void)downloadData;
@end
