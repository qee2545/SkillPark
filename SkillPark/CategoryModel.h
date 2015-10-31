//
//  CategoryModel.h
//  SkillPark
//
//  Created by qee on 2015/10/29.
//  Copyright © 2015年 qee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CategoryModel : NSObject
@property (nonatomic) NSNumber *ID;
@property (nonatomic) NSString *name;
@property (nonatomic) UIImage *image;
@property (nonatomic) NSString *imageURL;
@end
