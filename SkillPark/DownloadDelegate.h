//
//  DownloadDelegate.h
//  SkillPark
//
//  Created by qee on 2015/11/4.
//  Copyright © 2015年 qee. All rights reserved.
//

#ifndef DownloadDelegate_h
#define DownloadDelegate_h

typedef NS_ENUM(NSUInteger, TableStyle) {
    TableStyleSkill     =   0x00000001,
    TableStyleProfile   =   0x00000010,
    TableStyleComment   =   0x00000100,
    TableStyleCategory  =   0x00001000
};
#define AllTableDownLoadFinished 0x00001111

@protocol DownloadDelegate <NSObject>

- (void)didFinishTableDownloadWithStyle:(NSUInteger)tableStyle;
- (void)imageDownloadFinished;

@end

#endif /* APIDelegate_h */
