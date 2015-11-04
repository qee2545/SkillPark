//
//  APIDelegate.h
//  SkillPark
//
//  Created by qee on 2015/11/4.
//  Copyright © 2015年 qee. All rights reserved.
//

#ifndef APIDelegate_h
#define APIDelegate_h

@protocol APIDelegate <NSObject>

- (void)APITextDownloadFinished;
- (void)APIImageDownloadFinished;

@end

#endif /* APIDelegate_h */
