//
//  PersonCollectionViewController.m
//  SkillPark
//
//  Created by qee on 2015/10/21.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "PersonCollectionViewController.h"
#import "HeaderCollectionReusableView.h"
#import "PersonCollectionViewCell.h"
#import "PreferCollectionViewCell.h"
#import "MessageViewController.h"
#import "ShowSkillViewController.h"
#import "UserModel.h"
#import "SkillModel.h"
#import <AFNetworking/AFNetworking.h>

@interface PersonCollectionViewController () <UICollectionViewDelegateFlowLayout>
{
    BOOL isShowPersonSkill;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *followBarButtonItem;
@end

@implementation PersonCollectionViewController

static NSString * const personReuseIdentifier = @"PersonSkillCell";
static NSString * const preferReuseIdentifier = @"PreferSkillCell";

static CGFloat const topInset = 4.0;
static CGFloat const leftInset = 4.0;
static CGFloat const buttomInset = 4.0;
static CGFloat const rightInset = 4.0;

static CGFloat const minimumLineSpacing = 4.0;
static CGFloat const minimumInteritemSpacing = 4.0;

static CGFloat const skillColumnCount = 3.0;
static CGFloat const categoryColumnCount = 3.0;


- (void)viewDidLoad {
    NSLog(@"%s self:%@", __FUNCTION__, self);
    [super viewDidLoad];
    
//    [self setLayout];
    self.followBarButtonItem.title = @"收藏";
    for (UserModel *followUser in loginUser.followUsers) {
        if ([followUser.ID intValue] == [self.showUser.ID intValue]) {
            self.followBarButtonItem.title = @"取消收藏";
            break;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    
    //init variable
    isShowPersonSkill = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setLayout {
    
//    UICollectionViewFlowLayout *flowlayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
//    flowlayout.minimumInteritemSpacing = 4.0;
//    flowlayout.minimumLineSpacing = 4.0;
//    flowlayout.sectionInset = UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0);
//    double width = ([UIScreen mainScreen].bounds.size.width - 4.0 - 4.0 - 4.0)/ 2.0;
//    flowlayout.estimatedItemSize = CGSizeMake(width, width);
//    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%s", __FUNCTION__);
    
    if (!isShowPersonSkill) {
        double categoryWidth = ([UIScreen mainScreen].bounds.size.width - leftInset - rightInset - minimumInteritemSpacing * (categoryColumnCount - 1)) / categoryColumnCount;
        
        return CGSizeMake(categoryWidth, categoryWidth);
    }
    
    double skillWidth = ([UIScreen mainScreen].bounds.size.width - leftInset - rightInset - minimumInteritemSpacing * (skillColumnCount - 1)) / skillColumnCount;
    double skillHeight = skillWidth;
    
    return CGSizeMake(skillWidth, skillHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
//    NSLog(@"%s", __FUNCTION__);
    return UIEdgeInsetsMake(topInset, leftInset, buttomInset, rightInset);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
//    NSLog(@"%s", __FUNCTION__);
    return minimumLineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
//    NSLog(@"%s", __FUNCTION__);
    return minimumInteritemSpacing;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    NSLog(@"%s", __FUNCTION__);
//#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    NSLog(@"%s", __FUNCTION__);
    
//#warning Incomplete implementation, return the number of items
    if (isShowPersonSkill) {
        return self.showUser.skills.count;
    }
    
    return self.showUser.likedCategory.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%s", __FUNCTION__);
    
    PersonCollectionViewCell *personCell = [collectionView dequeueReusableCellWithReuseIdentifier:personReuseIdentifier forIndexPath:indexPath];
    
    if (isShowPersonSkill) {
        [personCell setPersonCellWithSkill:self.showUser.skills[indexPath.row]];
    }
    else {
        PreferCollectionViewCell *preferCell = [collectionView dequeueReusableCellWithReuseIdentifier:preferReuseIdentifier forIndexPath:indexPath];
        
        [preferCell setPreferCellWithCategory:self.showUser.likedCategory[indexPath.row]];
        
        return preferCell;
    }
 
    return personCell;
}

// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%s indexPath:%@", __FUNCTION__, indexPath);
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        HeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        [headerView setHeaderViewWithUser:self.showUser];
        
        //adjust header height
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
        flowLayout.headerReferenceSize = [headerView sizeOfHeaderView];
//        NSLog(@"size %f", flowLayout.headerReferenceSize.height);
        
        UITapGestureRecognizer *personSkillTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personSkillTaped:)];
        [headerView.goodImageView addGestureRecognizer:personSkillTap];
        
        UITapGestureRecognizer *preferSkillTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(preferSkillTaped:)];
        [headerView.learnImageView addGestureRecognizer:preferSkillTap];
        
        UITapGestureRecognizer *messageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messageTaped:)];
        [headerView.messageImageView addGestureRecognizer:messageTap];
       
        return headerView;
    }
    
    return nil;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    NSLog(@"%s", __FUNCTION__);
//    
////    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
////    HeaderCollectionReusableView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
////    
////    [headerView setHeaderViewWithUser:self.theUser];
//    
//    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 500);//[self heightForHeader]);
//}
//
//- (CGFloat)heightForHeader
//{
//    NSLog(@"%s", __FUNCTION__);
//    static HeaderCollectionReusableView *sizingHeader = nil;
//    static dispatch_once_t onceToken;
//    
//    dispatch_once(&onceToken, ^{
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
//        sizingHeader = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
//    });
//    
//    [sizingHeader setHeaderViewWithUser:self.showUser];
//    return [self calculateHeightForHeader:sizingHeader];
//}
//
//- (CGFloat)calculateHeightForHeader:(HeaderCollectionReusableView *)sizingHeader {
//    NSLog(@"%s", __FUNCTION__);
//    [sizingHeader setNeedsLayout];
//    [sizingHeader layoutIfNeeded];
//    
//    CGSize size = [sizingHeader systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
//    NSLog(@"size width:%f height:%f", size.width, size.height);
//    return size.height + 1.0f; // Add 1.0f for the cell separator height
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (isShowPersonSkill) {
        [self performSegueWithIdentifier:@"PersonToShowSkill" sender:indexPath];
    }
}

#pragma make - tap

- (void)personSkillTaped:(id)sender {
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", sender);
    
    BOOL isPreShowPersonSkill = isShowPersonSkill;
    isShowPersonSkill = YES;
    if (isShowPersonSkill != isPreShowPersonSkill) {
        //        [self.collectionView reloadData];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
        [self.collectionView reloadSections:indexSet];
    }
}

- (void)preferSkillTaped:(id)sender {
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", sender);
    
    BOOL isPreShowPersonSkill = isShowPersonSkill;
    isShowPersonSkill = NO;
    if (isShowPersonSkill != isPreShowPersonSkill) {
        //        [self.collectionView reloadData];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
        [self.collectionView reloadSections:indexSet];
    }
}

- (void)messageTaped:(id)sender {
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", sender);
    
    [self performSegueWithIdentifier:@"PersonToMessageDetail" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PersonToMessageDetail"]) {
        MessageViewController *controller = [segue destinationViewController];
        controller.theUser = loginUser;
        for (CommentGroupModel *commentG in loginUser.commentsGroup) {
            if (commentG.talkedUser == self.showUser) {
                controller.commentGroup = commentG;
                break;
            }
        }

        controller.talkedUser = self.showUser;
        
        NSLog(@"theUse:%@ name:%@, talkedUser:%@ name:%@", controller.theUser, controller.theUser.name, controller.talkedUser.name,controller.talkedUser);
    }
    else if ([segue.identifier isEqualToString:@"PersonToShowSkill"]) {
        NSIndexPath *indexPath = sender;
        ShowSkillViewController *controller = [segue destinationViewController];
        controller.showSkill = self.showUser.skills[indexPath.row];
        controller.canNameButtonPressed = NO;
    }
}
- (IBAction)followPressed:(UIBarButtonItem *)sender {
    if ([sender.title isEqualToString:@"收藏"]) {
        sender.title = @"取消收藏";
        [loginUser.followUsers addObject:self.showUser];
    }
    else {
        sender.title = @"收藏";
        for (int i = 0; i < loginUser.followUsers.count; i++) {
            if ([loginUser.followUsers[i].ID intValue] == [self.showUser.ID intValue]) {
                [loginUser.followUsers removeObjectAtIndex:i];
                break;
            }
        }
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"auth_token":webTokenStr, @"favorite_id": self.showUser.ID};
    NSLog(@"parameters: %@", parameters);
    
    NSString *urlStr = [NSString stringWithFormat:@"http://www.skillpark.co/api/v1/profiles/%d/favorite", [loginUser.ID intValue]];
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
