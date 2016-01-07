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
#import "Global.h"


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
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint
                                            constraintWithItem:loginButton
                                            attribute:NSLayoutAttributeHeight
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:nil
                                            attribute:NSLayoutAttributeHeight
                                            multiplier:1
                                            constant:35];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint
                                            constraintWithItem:loginButton
                                            attribute:NSLayoutAttributeLeft
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:self.view
                                            attribute:NSLayoutAttributeLeft
                                            multiplier:1
                                            constant:35];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint
                                            constraintWithItem:loginButton
                                            attribute:NSLayoutAttributeRight
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:self.view
                                            attribute:NSLayoutAttributeRight
                                            multiplier:1
                                            constant:-35];
    
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
    
    NSArray *constraints = @[heightConstraint, leftConstraint,rightConstraint, bottomConstraint, centerXConstraint];
    
    [self.view addConstraints:constraints];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self checkNetwork]) {
        [self fbLoginChcek];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)checkNetwork {
    NSString *host = @"www.apple.com";
    SCNetworkReachabilityRef  reachability = SCNetworkReachabilityCreateWithName(nil, host.UTF8String);
    SCNetworkReachabilityFlags flags;
    BOOL result = NO;
    if(reachability) {
        result = SCNetworkReachabilityGetFlags(reachability, &flags);
        CFRelease(reachability);
    }
    
    if(!result || !flags) {
        NSLog(@"無網路");
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"No Internet Connection!"preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertController addAction:cancelButton];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return FALSE;
    }
    else {
        NSLog(@"有網路");
    }
    
    return TRUE;
}

- (void)fbLoginChcek {
    fbToken = [FBSDKAccessToken currentAccessToken];
    
    if (fbToken) {
        [self fbLogin];
    }
}

- (void)fbLogin {
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                       parameters:@{@"fields": @"picture, name, email"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            userName = result[@"name"];
            userEmail = result[@"email"];
//            NSString *pictureURL = result[@"picture"][@"data"][@"url"];
//            NSData  *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:pictureURL]];
            
            loginUserName = userName;
            NSLog(@"login user:%@", loginUserName);
            
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
              error:(NSError *)error {
    if (!error) {
        fbToken = result.token;
        [FBSDKAccessToken setCurrentAccessToken:fbToken];
        
        [self fbLogin];
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    loginUserName = @"";
    loginUser = nil;
    webTokenStr = @"";
}

@end
