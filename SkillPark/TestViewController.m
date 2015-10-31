//
//  TestViewController.m
//  SkillPark
//
//  Created by qee on 2015/10/25.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "TestViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface TestViewController ()
{
    AFHTTPRequestOperationManager *manger;
    NSDictionary* apiDictionary;
}
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL *baseURL = [NSURL URLWithString:@"http://139.162.15.196"];
    manger = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getData
{
    [manger GET:@"api/v1/skills" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"JSON %@", responseObject);
        apiDictionary = responseObject;
        [self didGetData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"Error %@", error);
    }];
    
    
}

- (void)didGetData
{
    NSLog(@"apiDictionary %@", apiDictionary);
    
    NSNumber *totalRecords = apiDictionary[@"metadata"][@"total"];
    NSLog(@"totalRecords %@", totalRecords);
    for (int i = 0; i < [totalRecords intValue]; i++) {
        NSNumber *id = apiDictionary[@"data"][i][@"id"];
        NSString *name = apiDictionary[@"data"][i][@"name"];
        NSString *requirement = apiDictionary[@"data"][i][@"requirement"];
        NSString *description = apiDictionary[@"data"][i][@"description"];
        NSArray *category = apiDictionary[@"data"][i][@"category"];
        
        NSLog(@"id %@", id);
        NSLog(@"name %@", name);
        NSLog(@"requirement %@", requirement);
        NSLog(@"description %@", description);
        NSLog(@"category %@", category);
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
