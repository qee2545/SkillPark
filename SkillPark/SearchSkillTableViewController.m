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
    // Data
    NSMutableArray *contentList;
    NSMutableArray *filteredContentList;
}
@end

@implementation SearchSkillTableViewController

static NSString * const reuseIdentifier = @"SearchCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    contentList = [[NSMutableArray alloc] initWithObjects:@"ruby on rails", @"iOS", @"handicraft", @"rails", @"Objective-C", @"swift",@"iphone", @"ruby", @"on", nil];
    contentList = [[NSMutableArray alloc] init];
    filteredContentList = [[NSMutableArray alloc] init];
    
    [self registerNibs];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.estimatedRowHeight = 70.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.searchDisplayController.searchResultsTableView.estimatedRowHeight = 70.0;
    self.searchDisplayController.searchResultsTableView .rowHeight = UITableViewAutomaticDimension;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [contentList removeAllObjects];
    for (SkillModel *skill in allSkills) {
        [contentList addObject:skill];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerNibs
{
    // attach the UI nib file for the ImageUICollectionViewCell to the collectionview
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
        SkillModel *skill = filteredContentList[indexPath.row];
        [cell setContentWithSkill:skill];
//        cell.titleLabel.text = [filteredContentList objectAtIndex:indexPath.row];
    }
    else {
        SkillModel *skill = contentList[indexPath.row];
        [cell setContentWithSkill:skill];
//        cell.titleLabel.text = [contentList objectAtIndex:indexPath.row];
    }
    
//    cell.textLabel.text = [contentList objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SkillModel *showSkill;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSLog(@"search display row:%d %@", indexPath.row, [filteredContentList objectAtIndex:indexPath.row]);
        showSkill = [filteredContentList objectAtIndex:indexPath.row];
    }
    else {
        NSLog(@"normal display row:%d %@", indexPath.row, [contentList objectAtIndex:indexPath.row]);
        showSkill = [contentList objectAtIndex:indexPath.row];
    }
    
    [self performSegueWithIdentifier:@"SearchToShowSkill" sender:showSkill];
}

- (void)filterContentForSearchText:(NSString *)searchText
{
    [filteredContentList removeAllObjects];
    
    for (SkillModel *skill in contentList) {
        //search title
        NSString *titleStr = skill.title;
        NSComparisonResult resultOfTitle = [titleStr compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        if (resultOfTitle == NSOrderedSame) {
            [filteredContentList addObject:skill];
            continue;
        }
        
        //search category
        for (CategoryModel *category in skill.belongCategory) {
            NSString *categoryStr = category.name;
            NSComparisonResult resultOfCategory = [categoryStr compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            if (resultOfCategory == NSOrderedSame) {
                [filteredContentList addObject:skill];
                break;
            }
        }
    }
    NSLog(@"%@", filteredContentList);
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString];
    return true;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SkillModel *showSkill = sender;
    ShowSkillViewController *controller = [segue destinationViewController];
    controller.showSkill = showSkill;
}


@end
