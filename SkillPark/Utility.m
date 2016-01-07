//
//  Utility.m
//  SkillPark
//
//  Created by qee on 2015/10/28.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "Utility.h"
#import <AFNetworking/AFNetworking.h>
@import AVFoundation;

@implementation Utility

#pragma mark -- Size Utility

+ (CGFloat)imageViewSizeForImage:(UIImage *)image withLimitWidth:(CGFloat)width
{
    CGRect boundingRect = CGRectMake(0, 0, width, FLT_MAX);
    CGRect rect = AVMakeRectWithAspectRatioInsideRect(image.size, boundingRect);
    return rect.size.height;
}

+ (CGSize)labelSizeForString:(NSString *)string withFontName:(NSString *)fontName withFontSize:(CGFloat)fontSize withLimitWidth:(CGFloat)width
{
    CGSize maximumLabelSize = CGSizeMake(width, FLT_MAX);
    
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[UIFont fontWithName:fontName size:fontSize] forKey: NSFontAttributeName];
    CGSize expectedLabelSize = [string boundingRectWithSize:maximumLabelSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:stringAttributes context:nil].size;
    
    return expectedLabelSize;
}

@end
