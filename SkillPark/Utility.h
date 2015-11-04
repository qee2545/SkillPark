//
//  Utility.h
//  SkillPark
//
//  Created by qee on 2015/10/28.
//  Copyright © 2015年 qee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Enum.h"
#import "SkillsTable.h"
#import "ProfilesTable.h"
#import "CommentsTable.h"
#import "CategoriesTable.h"

@interface Utility : NSObject

#pragma mark -- Size Utility
+ (CGFloat)imageViewSizeForImage:(UIImage *)image withLimitWidth:(CGFloat)width;

+ (CGSize)labelSizeForString:(NSString *)string withFontName:(NSString *)fontName withFontSize:(CGFloat)fontSize withLimitWidth:(CGFloat)width;

@end
