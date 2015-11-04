//
//  LoginViewController.m
//  SkillPark
//
//  Created by qee on 2015/11/2.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "LoginViewController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

#import <AFNetworking/AFNetworking.h>


@interface LoginViewController () <FBSDKLoginButtonDelegate>
{
    FBSDKAccessToken *fbToken;
    NSString *userName;
    NSString *userEmail;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    loginButton.delegate = self;
    
    loginButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:loginButton];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint
                                            constraintWithItem:loginButton
                                            attribute:NSLayoutAttributeBottom
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:self.view
                                            attribute:NSLayoutAttributeBottom
                                            multiplier:1
                                            constant:-50];
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint
                                             constraintWithItem:loginButton
                                             attribute:NSLayoutAttributeCenterX
                                             relatedBy:NSLayoutRelationEqual
                                             toItem:self.view
                                             attribute:NSLayoutAttributeCenterX
                                             multiplier:1
                                             constant:0];
    
    NSArray *constraints = @[bottomConstraint, centerXConstraint];
    
    [self.view addConstraints:constraints];
    
    [self fbLoginChcek];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)fbLoginChcek
{
    fbToken = [FBSDKAccessToken currentAccessToken];
    
    if (fbToken) {
        [self fbLogin];
    }
}

- (void)fbLogin
{
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"picture, name, email"}] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        if (!error) {
            userName = result[@"name"];
            userEmail = result[@"email"];
            //            NSString *pictureURL = result[@"picture"][@"data"][@"url"];
            //            NSData  *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:pictureURL]];
            
            loginUserName = userName;
            
            NSLog(@"name:%@", userName);
            NSLog(@"email:%@", userEmail);
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSDictionary *parameters = @{@"access_token": fbToken.tokenString};
            [manager POST:@"http://www.skillpark.co/api/v1/login" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                webTokenStr = responseObject[@"auth_token"];
                [self performSegueWithIdentifier:@"LoginToMain" sender:nil];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
        }
    }];
}

#pragma mark FBSDKLoginButtonDelegate

- (void)loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:(NSError *)error
{
    NSLog(@"%s", __FUNCTION__);
    
    if (!error) {
        fbToken = result.token;
        [FBSDKAccessToken setCurrentAccessToken:fbToken];
        
        [self fbLogin];
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    NSLog(@"%s", __FUNCTION__);
    
    loginUserName = @"";
    loginUser = nil;
    webTokenStr = @"";
}


@end
