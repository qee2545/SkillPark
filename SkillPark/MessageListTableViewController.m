//
//  MessageListTableViewController.m
//  SkillPark
//
//  Created by qee on 2015/10/28.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "MessageListTableViewController.h"
#import "MessageListTableViewCell.h"
#import "MessageViewController.h"
#import "Global.h"

@interface MessageListTableViewController ()
{
    User *theUser;
    NSMutableArray *messagesGroup;
}
@end

@implementation MessageListTableViewController

static NSString * const reuseIdentifier = @"MessageListCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 70.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
    theUser = loginUser;
    messagesGroup = [[NSMutableArray alloc] init];
    for (User *user in users) {
        NSMutableArray *messages = [Global selectMessagesBetweenUser:theUser andUser:user];
        if (messages.count > 0) {
            [messagesGroup addObject:messages];
        }
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return messagesGroup.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [cell setContentWithMessages:[messagesGroup[indexPath.row] lastObject]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"MessageListToMessageDetail" sender:indexPath];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = sender;
    MessageViewController *controller = [segue destinationViewController];
    controller.theUser = theUser;
    controller.messages = messagesGroup[indexPath.row];
    Message *message = controller.messages[0];
    if (message.fromUser == theUser) {
        controller.talkedUser = message.toUser;
    }
    else {
        controller.talkedUser = message.fromUser;
    }
}

@end
