//
//  SearchSkillTableViewController.m
//  SkillPark
//
//  Created by qee on 2015/10/23.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "SearchSkillTableViewController.h"
#import "ShowSkillViewController.h"
#import "SearchTableViewCell.h"
#import "Global.h"

@interface SearchSkillTableViewController () <UISearchBarDelegate, UISearchDisplayDelegate>
{
    NSMutableArray *contentList;
    NSMutableArray *filteredContentList;
}
@end

@implementation SearchSkillTableViewController

static NSString * const reuseIdentifier = @"SearchCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    contentList = [[NSMutableArray alloc] init];
    filteredContentList = [[NSMutableArray alloc] init];
    
    [self registerNibs];
    
    //original tableview setting
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.estimatedRowHeight = 70.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    //serch tableview setting
    self.searchDisplayController.searchResultsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.searchDisplayController.searchResultsTableView.estimatedRowHeight = 70.0;
    self.searchDisplayController.searchResultsTableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [contentList removeAllObjects];
    for (Skill *skill in skills) {
        [contentList addObject:skill];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerNibs
{
    UINib *cellNib = [UINib nibWithNibName:@"SearchTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:reuseIdentifier];
    [self.searchDisplayController.searchResultsTableView registerNib:cellNib forCellReuseIdentifier:reuseIdentifier];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [filteredContentList count];
    }
    
    return [contentList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        Skill *skill = filteredContentList[indexPath.row];
        [cell setContentWithSkill:skill];
    }
    else {
        Skill *skill = contentList[indexPath.row];
        [cell setContentWithSkill:skill];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Skill *showSkill;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        showSkill = [filteredContentList objectAtIndex:indexPath.row];
    }
    else {
        showSkill = [contentList objectAtIndex:indexPath.row];
    }
    
    [self performSegueWithIdentifier:@"SearchToShowSkill" sender:showSkill];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString];
    return true;
}

- (void)filterContentForSearchText:(NSString *)searchText
{
    [filteredContentList removeAllObjects];
    
    for (Skill *skill in contentList) {
        //search title
        NSString *titleStr = skill.name;
        NSComparisonResult resultOfTitle = [titleStr compare:searchText options:(NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        if (resultOfTitle == NSOrderedSame) {
            [filteredContentList addObject:skill];
            continue;   //name match, no need to search category
        }
        
        //search category
        SkillCategory *category = skill.belongCategory;
        NSString *categoryStr = category.name;
        NSComparisonResult resultOfCategory = [categoryStr compare:searchText options:(NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        if (resultOfCategory == NSOrderedSame) {
            [filteredContentList addObject:skill];
        }
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    Skill *showSkill = sender;
    ShowSkillViewController *controller = [segue destinationViewController];
    controller.showSkill = showSkill;
    controller.canNameButtonPressed = YES;
}

@end
