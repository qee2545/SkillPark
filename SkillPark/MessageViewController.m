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

@interface MessageViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UITextField *activeTextField;
    
//    NSMutableArray<NSString *> *messages;
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
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"msgBackground"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
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
    [super viewWillAppear:animated];
    
    self.navigationItem.title = self.commentGroup.talkedUser.name;
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
}

- (void)viewDidDisappear:(BOOL)animated {
    
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
    NSLog(@"%s", __FUNCTION__);
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"%s", __FUNCTION__);
    activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"%s", __FUNCTION__);
 
    textField.text = @"";
    activeTextField = nil;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSLog(@"%s", __FUNCTION__);
    
    NSDictionary* info = [notification userInfo];
    [self adjustMessageViewByKeyboardState:YES keyboardInfo:info];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSLog(@"%s", __FUNCTION__);
    
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
        CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        self.constraintToAdjust.constant += kbRect.size.height;
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

- (IBAction)tapToCloseKeyboard:(UITapGestureRecognizer *)sender {
    NSLog(@"%s", __FUNCTION__);
    [activeTextField resignFirstResponder];
}

- (IBAction)sendMessage:(UIButton *)sender {
    NSLog(@"%s", __FUNCTION__);
    if (self.messageTextField.text.length != 0) {
        NSLog(@"msg: %@", self.messageTextField.text);
        
        if (self.commentGroup == nil) {
            self.commentGroup = [[CommentGroupModel alloc] init];
            [self.theUser.commentsGroup addObject:self.commentGroup];
        }
        if (self.commentGroup.comments == nil) {
            self.commentGroup.comments = [[NSMutableArray alloc] init];
        }
     
        self.commentGroup.talkedUser = self.talkedUser;
        NSDictionary *dic = @{@"comment":self.messageTextField.text, @"to":@1};
        [self.commentGroup.comments addObject:dic];
        NSLog(@"count: %d", self.commentGroup.comments.count);
        
        NSIndexPath *indexPath = [NSIndexPath
                                  indexPathForRow:self.commentGroup.comments.count-1 inSection:0];
        [self.messageTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        [self scrollToTheBottom:YES];
        self.messageTextField.text = @"";
    }
}

- (void)scrollToTheBottom:(BOOL)animated
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.commentGroup.comments.count-1 inSection:0];
    [self.messageTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    NSLog(@"%s", __FUNCTION__);
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    NSLog(@"%s", __FUNCTION__);
    return self.commentGroup.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s row:%ld", __FUNCTION__, (long)indexPath.row);
    
    NSDictionary *dic = self.commentGroup.comments[indexPath.row];
    if ([dic[@"to"] intValue] == 0) {
        SomeoneMessageTableViewCell *someoneCell = [tableView dequeueReusableCellWithIdentifier:someoneReuseIdentifier forIndexPath:indexPath];
        [someoneCell setContentWithUser:self.commentGroup.talkedUser andMessage:dic[@"comment"]];
        return someoneCell;
    }
    
    SelfMessageTableViewCell *selfCell = [tableView dequeueReusableCellWithIdentifier:selfReuseIdentifier forIndexPath:indexPath];
    [selfCell setContentWithMessage:dic[@"comment"]];
    
    return selfCell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didWillDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSLog(@"%s", __FUNCTION__);
}

@end
