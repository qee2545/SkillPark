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
    
    NSTimeInterval msgTimeInterval;
    NSTimer *msgTimer;
    
//    NSMutableArray<NSString *> *messages;
}
@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintToAdjust;
@property (weak, nonatomic) IBOutlet UITableView *messageTableView;

@property (atomic) NSNumber *lastCommentID;

@end

@implementation MessageViewController

static NSString * const someoneReuseIdentifier = @"SomeoneCell";
static NSString * const selfReuseIdentifier = @"SelfCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.messageTextField.delegate = self;
    self.messageTableView.delegate = self;
    self.messageTableView.dataSource = self;
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"msgBackground"] drawInRect:self.view.bounds];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
//    UIImageView *tableBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"msgBackground"]];
//    tableBackgroundView.frame = self.messageTableView.frame;
//    self.messageTableView.backgroundView = tableBackgroundView;
    
    self.messageTableView.backgroundColor = [UIColor clearColor];
//    self.messageView.backgroundColor = [UIColor whiteColor];
    self.messageButton.backgroundColor = [UIColor colorWithRed:0.76 green:0.38 blue:0.33 alpha:1];

    self.messageTableView.estimatedRowHeight = 70.0;
    self.messageTableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%s", __FUNCTION__);
    
    [super viewWillAppear:animated];
    
    self.navigationItem.title = self.talkedUser.name;
    self.tabBarController.tabBar.hidden = YES;
    
    [self.messageTableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //msg timer
    [self getLastCommentID];
    msgTimeInterval = 1.0;
    if (![msgTimer isValid]) {
        msgTimer = [NSTimer scheduledTimerWithTimeInterval:msgTimeInterval target:self selector:@selector(timeEvent) userInfo:nil repeats:YES];
    }
}

- (void)getLastCommentID {
    NSLog(@"%s", __FUNCTION__);
    if (self.commentGroup.comments.count > 0) {
        for (int i = self.commentGroup.comments.count - 1; i >= 0; i--) {
            NSNumber *commentID = self.commentGroup.comments[i][@"ID"];
            if (commentID != nil || commentID != NULL) {
                NSLog(@"!commentID");
                self.lastCommentID = commentID;
                break;
            }
        }
        
        if (self.lastCommentID == nil) {
            self.lastCommentID = @0;
        }
    }
    else {
        self.lastCommentID = @0;
    }
    NSLog(@"lastCommentID: %@", self.lastCommentID);
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"%s", __FUNCTION__);
    
    [super viewWillDisappear:animated];
    
    [msgTimer invalidate];
    msgTimer = nil;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    NSLog(@"%s", __FUNCTION__);
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    NSLog(@"%s", __FUNCTION__);
    activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    NSLog(@"%s", __FUNCTION__);
 
    textField.text = @"";
    activeTextField = nil;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
//    NSLog(@"%s", __FUNCTION__);
    
    NSDictionary* info = [notification userInfo];
    [self adjustMessageViewByKeyboardState:YES keyboardInfo:info];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
//    NSLog(@"%s", __FUNCTION__);
    
    NSDictionary* info = [notification userInfo];
    [self adjustMessageViewByKeyboardState:NO keyboardInfo:info];
}

- (void)adjustMessageViewByKeyboardState:(BOOL)showKeyboard keyboardInfo:(NSDictionary *)info
{
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
//        CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        CGRect kbRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//        NSLog(@"self.constraintToAdjust.constant:%f", self.constraintToAdjust.constant);
//        NSLog(@"kbRect.size.height:%f", kbRect.size.height);
        self.constraintToAdjust.constant += kbRect.size.height - self.constraintToAdjust.constant;
//        self.constraintToAdjust.constant = 252.0;
//        NSLog(@"after self.constraintToAdjust.constant:%f", self.constraintToAdjust.constant);
    }
    else {
        self.constraintToAdjust.constant = 0;
    }
    
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:animationDuration delay:0 options:animationOptions animations:^{
        [self.view layoutIfNeeded];
        if (self.messageTableView.contentSize.height > self.messageTableView.frame.size.height) {
            CGPoint offset = CGPointMake(0, self.messageTableView.contentSize.height - self.messageTableView.frame.size.height);
            [self.messageTableView setContentOffset:offset];
        }
    } completion:nil];
}

- (void)tapToCloseKeyboard:(UITapGestureRecognizer *)sender {
//    NSLog(@"%s", __FUNCTION__);
    [activeTextField resignFirstResponder];
}

- (IBAction)sendMessage:(UIButton *)sender {
    NSLog(@"%s", __FUNCTION__);
    if (self.messageTextField.text.length > 0) {
        NSLog(@"msg: %@", self.messageTextField.text);
        
        if (self.commentGroup == nil) {
            self.commentGroup = [[CommentGroupModel alloc] init];
            if (self.theUser.commentsGroup == nil) {
                self.theUser.commentsGroup = [[NSMutableArray alloc] init];
            }
            [self.theUser.commentsGroup insertObject:self.commentGroup atIndex:0];
        }
        if (self.commentGroup.comments == nil) {
            self.commentGroup.comments = [[NSMutableArray alloc] init];
        }
        
        self.commentGroup.talkedUser = self.talkedUser;
        NSDictionary *dic = @{@"comment":self.messageTextField.text, @"to":@1};
        [self.commentGroup.comments addObject:dic];
        NSLog(@"count: %lu", (unsigned long)self.commentGroup.comments.count);
        
        NSIndexPath *indexPath = [NSIndexPath
                                  indexPathForRow:self.commentGroup.comments.count-1 inSection:0];
        [self.messageTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        
        [self scrollToTheBottom:NO];
        
        [self sendMessageToServerWithCommentor:self.theUser.name andCommentedUser:self.talkedUser.name andContent:self.messageTextField.text];
        
        self.messageTextField.text = @"";
        
    }
}

//- (void)addToLocalArrayWithID:(NSNumber *)lastID {
//    if (self.commentGroup == nil) {
//        self.commentGroup = [[CommentGroupModel alloc] init];
//        if (self.theUser.commentsGroup == nil) {
//            self.theUser.commentsGroup = [[NSMutableArray alloc] init];
//        }
//        [self.theUser.commentsGroup insertObject:self.commentGroup atIndex:0];
//    }
//    if (self.commentGroup.comments == nil) {
//        self.commentGroup.comments = [[NSMutableArray alloc] init];
//    }
//    
//    self.commentGroup.talkedUser = self.talkedUser;
//    NSDictionary *dic = @{@"ID":lastID, @"comment":self.messageTextField.text, @"to":@1};
//    [self.commentGroup.comments addObject:dic];
//    NSLog(@"count: %lu", (unsigned long)self.commentGroup.comments.count);
//    
//    NSIndexPath *indexPath = [NSIndexPath
//                              indexPathForRow:self.commentGroup.comments.count-1 inSection:0];
//    [self.messageTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
//    
//    [self scrollToTheBottom:NO];
//    
//    self.messageTextField.text = @"";
//}

- (void)sendMessageToServerWithCommentor:(NSString *)commentor andCommentedUser:(NSString *)CommentedUser andContent:(NSString *)content {
    NSLog(@"%s", __FUNCTION__);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"auth_token":webTokenStr, @"metadata": @1, @"data":@[@{@"content":content, @"commentor":commentor, @"commented_user":CommentedUser}]};
    NSLog(@"parameters: %@", parameters);
    
    [manager POST:@"http://www.skillpark.co/api/v1/comments" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        self.lastCommentID = responseObject[@"id"];
//        [self addToLocalArrayWithID:self.lastCommentID];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)scrollToTheBottom:(BOOL)animated
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.commentGroup.comments.count-1 inSection:0];
    [self.messageTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
//    NSLog(@"%s", __FUNCTION__);
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    NSLog(@"%s count:%d", __FUNCTION__, self.commentGroup.comments.count);
    return self.commentGroup.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%s row:%ld", __FUNCTION__, (long)indexPath.row);
    
    NSDictionary *dic = self.commentGroup.comments[indexPath.row];
    if ([dic[@"to"] intValue] == 0) {
        SomeoneMessageTableViewCell *someoneCell = [tableView dequeueReusableCellWithIdentifier:someoneReuseIdentifier forIndexPath:indexPath];
        [someoneCell setContentWithUser:self.commentGroup.talkedUser andMessage:dic[@"comment"]];
        
        UITapGestureRecognizer *someoneCellTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToCloseKeyboard:)];
        [someoneCell addGestureRecognizer:someoneCellTap];
        
        return someoneCell;
    }
    
    SelfMessageTableViewCell *selfCell = [tableView dequeueReusableCellWithIdentifier:selfReuseIdentifier forIndexPath:indexPath];
    [selfCell setContentWithMessage:dic[@"comment"]];
    
    UITapGestureRecognizer *selfCellTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToCloseKeyboard:)];
    [selfCell addGestureRecognizer:selfCellTap];
    
    return selfCell;
}


- (void)timeEvent
{
    NSLog(@"%s", __FUNCTION__);

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"auth_token":webTokenStr, @"commentor_id": self.talkedUser.ID};
    NSLog(@"parameters: %@", parameters);
    NSLog(@"lastCommentID: %@", self.lastCommentID);
    
    NSString *urlStr = [NSString stringWithFormat:@"http://www.skillpark.co/api/v1/comments/%d/last_comments", [self.lastCommentID intValue]];
    NSLog(@"urlStr: %@", urlStr);
    [manager GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSArray *lastedCommentArray = responseObject[@"data"];
        NSLog(@"lastedCommentArray: %@", lastedCommentArray);
        for (int i = 0; i < lastedCommentArray.count; i++) {
            if (self.commentGroup == nil) {
                self.commentGroup = [[CommentGroupModel alloc] init];
                if (self.theUser.commentsGroup == nil) {
                    self.theUser.commentsGroup = [[NSMutableArray alloc] init];
                }
                [self.theUser.commentsGroup insertObject:self.commentGroup atIndex:0];
            }
            if (self.commentGroup.comments == nil) {
                self.commentGroup.comments = [[NSMutableArray alloc] init];
            }
            
            self.commentGroup.talkedUser = self.talkedUser;
            NSDictionary *dic = @{@"ID": lastedCommentArray[i][@"id"], @"comment":lastedCommentArray[i][@"content"], @"to":@0};
            [self.commentGroup.comments addObject:dic];
            NSLog(@"count: %lu", (unsigned long)self.commentGroup.comments.count);
            
            NSIndexPath *indexPath = [NSIndexPath
                                      indexPathForRow:self.commentGroup.comments.count-1 inSection:0];
            NSLog(@"inset row %d", indexPath.row);
            
            [self.messageTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            
            [self scrollToTheBottom:NO];
        }
        
        if (lastedCommentArray.count > 0) {
            self.lastCommentID = lastedCommentArray[lastedCommentArray.count - 1][@"id"];
            NSLog(@"lastCommentID: %@", self.lastCommentID);
        
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
