//
//  SkillModel.h
//  SkillPark
//
//  Created by qee on 2015/10/15.
//  Copyright © 2015年 qee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface SkillModel : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *requirement;
@property (nonatomic) NSString *descript;
@property (nonatomic) NSString *username;
@property (nonatomic, weak) UserModel *owner;
@property (nonatomic) NSString *location;
@property (nonatomic) NSMutableArray<CategoryModel *> *belongCategory;
@property (nonatomic) NSMutableArray<UIImage *> *images;
@property (nonatomic) NSMutableArray<NSString *> *imagesURL;
@property (nonatomic, assign) unsigned int likeNum;


@property (nonatomic) UIImage *image;


- (void)printInfo;
@end
