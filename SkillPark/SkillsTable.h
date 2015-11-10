//
//  SkillsTable.h
//  SkillPark
//
//  Created by qee on 2015/11/4.
//  Copyright © 2015年 qee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkillRecord.h"
#import "DownloadDelegate.h"

@interface SkillsTable : NSObject

@property (nonatomic) NSNumber *recordCount;
@property (nonatomic) NSMutableArray<SkillRecord*> *skillRecords;
@property (nonatomic) NSString *apiUrlStr;
@property (nonatomic, weak) id<DownloadDelegate> delegate;

- (void)getData;
@end
