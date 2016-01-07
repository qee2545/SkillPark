//
//  MessageViewController.m
//  SkillPark
//
//  Created by qee on 2015/10/27.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "MessageViewController.h"
#import "SomeoneMessageTableViewCell.h"
#import "SelfMessageTableViewCell.h"
#import <AFNetworking/AFNetworking.h>

@interface MessageViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UITextField *activeTextField;
    NSTimer *messageTimer;
    NSTimeInterval messageTimeInterval;
    NSNumber *lastMessageID;
}
@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintToAdjust;
@property (weak, nonatomic) IBOutlet UITableView *messageTableView;
@end

@implementation MessageViewController

static NSString * const someoneReuseIdentifier = @"SomeoneCell";
static NSString * const selfReuseIdentifier = @"SelfCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.messageTextField.delegate = self;
    self.messageTableView.delegate = self;
    self.messageTableView.dataSource = self;
    
    self.messageTableView.backgroundColor = [UIColor clearColor];
    self.messageButton.backgroundColor = [UIColor colorWithRed:0.76 green:0.38 blue:0.33 alpha:1];
    
    self.messageTableView.estimatedRowHeight = 70.0;
    self.messageTableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = self.talkedUser.name;
    self.tabBarController.tabBar.hidden = YES;
    
    [self.messageTableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
    
    //message timer
    [self getLastMessageID];
    messageTimeInterval = 1.0;
    if (![messageTimer isValid]) {
        messageTimer = [NSTimer scheduledTimerWithTimeInterval:messageTimeInterval target:self selector:@selector(timeEvent) userInfo:nil repeats:YES];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [messageTimer invalidate];
    messageTimer = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.text = @"";
    activeTextField = nil;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    [self adjustMessageViewByKeyboardState:YES keyboardInfo:info];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    [self adjustMessageViewByKeyboardState:NO keyboardInfo:info];
}

- (void)adjustMessageViewByKeyboardState:(BOOL)showKeyboard keyboardInfo:(NSDictionary *)info {
    UIViewAnimationCurve animationCurve = [info[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    UIViewAnimationOptions animationOptions = UIViewAnimationOptionBeginFromCurrentState;
    if (animationCurve == UIViewAnimationCurveEaseIn) {
        animationOptions |= UIViewAnimationOptionCurveEaseIn;
    }
    else if (animationCurve == UIViewAnimationCurveEaseInOut) {
        animationOptions |= UIViewAnimationOptionCurveEaseInOut;
    }
    else if (animationCurve == UIViewAnimationCurveEaseOut) {
        animationOptions |= UIViewAnimationOptionCurveEaseOut;
    }
    else if (animationCurve == UIViewAnimationCurveLinear) {
        animationOptions |= UIViewAnimationOptionCurveLinear;
    }
    
    [self.messageView setNeedsUpdateConstraints];
    
    if (showKeyboard) {
        CGRect kbRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        self.constraintToAdjust.constant += kbRect.size.height - self.constraintToAdjust.constant;
    }
    else {
        self.constraintToAdjust.constant = 0;
    }
    
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:animationDuration
                          delay:0
                        options:animationOptions animations:^{
        [self.view layoutIfNeeded];
        if (self.messageTableView.contentSize.height > self.messageTableView.frame.size.height) {
            CGPoint offset = CGPointMake(0, self.messageTableView.contentSize.height - self.messageTableView.frame.size.height);
            [self.messageTableView setContentOffset:offset];
        }
    } completion:nil];
}

- (void)tapToCloseKeyboard:(UITapGestureRecognizer *)sender {
    [activeTextField resignFirstResponder];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = self.messages[indexPath.row];
    
    if (message.fromUser == self.talkedUser) {
        SomeoneMessageTableViewCell *someoneCell = [tableView dequeueReusableCellWithIdentifier:someoneReuseIdentifier forIndexPath:indexPath];
        [someoneCell setContentWithUser:message.fromUser andMessage:message.message];
        
        UITapGestureRecognizer *someoneCellTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToCloseKeyboard:)];
        [someoneCell addGestureRecognizer:someoneCellTap];
        
        return someoneCell;
    }
    
    SelfMessageTableViewCell *selfCell = [tableView dequeueReusableCellWithIdentifier:selfReuseIdentifier forIndexPath:indexPath];
    [selfCell setContentWithMessage:message.message];
    
    UITapGestureRecognizer *selfCellTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToCloseKeyboard:)];
    [selfCell addGestureRecognizer:selfCellTap];
    
    return selfCell;
}

- (void)getLastMessageID {
    lastMessageID = [messages lastObject].ID;
    if (!lastMessageID) {
        lastMessageID = @0;
    }
}

- (IBAction)sendMessage:(UIButton *)sender {
    if (self.messageTextField.text.length > 0) {
        Message *message = [[Message alloc] init];
        message.fromUser = self.theUser;
        message.toUser = self.talkedUser;
        message.message = [NSString stringWithString:self.messageTextField.text];
        
        //add message to local and global variable, messages
        if (!self.messages) {
            self.messages = [[NSMutableArray alloc] init];
        }
        [self addMessage:message toLocal:self.messages];
        [self addMessage:message toLocal:messages];
        //add message to server
        [self addMessage:message toServer:@"http://www.skillpark.co/api/v1/comments"];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
        [self.messageTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.messageTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        
        self.messageTextField.text = @"";
    }
}

- (void)addMessage:(Message *)message toLocal:(NSMutableArray *)array {
    [array addObject:message];
}

- (void)addMessage:(Message *)message toServer:(NSString *)url {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"auth_token": webTokenStr,
                                 @"metadata": @1,
                                 @"data":@[@{@"content": message.message,
                                             @"commentor": message.fromUser.name,
                                             @"commented_user": message.toUser.name}]};
    NSLog(@"parameters: %@", parameters);
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        message.ID = responseObject[@"id"];
        lastMessageID = message.ID;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)timeEvent {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"http://www.skillpark.co/api/v1/comments/%d/last_comments", [lastMessageID intValue]];
    NSDictionary *parameters = @{@"auth_token":webTokenStr,
                                 @"commentor_id": self.talkedUser.ID};
    [manager GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSArray *lastedMessageArray = responseObject[@"data"];
        for (int i = 0; i < lastedMessageArray.count; i++) {
            Message *message = [[Message alloc] init];
            message.fromUser = self.talkedUser;
            message.toUser = self.theUser;
            message.message = lastedMessageArray[i][@"content"];
            message.ID = lastedMessageArray[i][@"id"];
            
            //add message to local and global variable, messages
            if (!self.messages) {
                self.messages = [[NSMutableArray alloc] init];
            }
            [self addMessage:message toLocal:self.messages];
            [self addMessage:message toLocal:messages];

            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
            [self.messageTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.messageTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
        
        if (lastedMessageArray.count > 0) {
            lastMessageID = lastedMessageArray[lastedMessageArray.count - 1][@"id"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
