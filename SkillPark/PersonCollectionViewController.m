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

static CGFloat const skillColumnCount = 2.0;
static CGFloat const categoryColumnCount = 3.0;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.followBarButtonItem.title = @"收藏";
    for (User *followUser in loginUser.favoriteUsers) {
        if ([followUser.ID intValue] == [self.showUser.ID intValue]) {
            self.followBarButtonItem.title = @"取消收藏";
            break;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
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

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!isShowPersonSkill) {
        double categoryWidth = ([UIScreen mainScreen].bounds.size.width - leftInset - rightInset - minimumInteritemSpacing * (categoryColumnCount - 1)) / categoryColumnCount;
        
        return CGSizeMake(categoryWidth, categoryWidth);
    }
    
    double skillWidth = ([UIScreen mainScreen].bounds.size.width - leftInset - rightInset - minimumInteritemSpacing * (skillColumnCount - 1)) / skillColumnCount;
    double skillHeight = skillWidth;
    
    return CGSizeMake(skillWidth, skillHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(topInset, leftInset, buttomInset, rightInset);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return minimumLineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return minimumInteritemSpacing;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (isShowPersonSkill) {
        return self.showUser.skills.count;
    }
    
    return self.showUser.likeCategories.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PersonCollectionViewCell *personCell = [collectionView dequeueReusableCellWithReuseIdentifier:personReuseIdentifier forIndexPath:indexPath];
    
    if (isShowPersonSkill) {
        [personCell setPersonCellWithSkill:self.showUser.skills[indexPath.row]];
    }
    else {
        PreferCollectionViewCell *preferCell = [collectionView dequeueReusableCellWithReuseIdentifier:preferReuseIdentifier forIndexPath:indexPath];
        
        [preferCell setPreferCellWithCategory:self.showUser.likeCategories[indexPath.row]];
        
        return preferCell;
    }
 
    return personCell;
}

// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        HeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        [headerView setHeaderViewWithUser:self.showUser];
        
        //adjust header height
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
        flowLayout.headerReferenceSize = [headerView sizeOfHeaderView];
        
        //add tap gesture to switch to skills or preferd skill categories
        UITapGestureRecognizer *personSkillTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personSkillTaped:)];
        [headerView.goodImageView addGestureRecognizer:personSkillTap];
        
        UITapGestureRecognizer *preferedSkillTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(preferedSkillTaped:)];
        [headerView.learnImageView addGestureRecognizer:preferedSkillTap];
        
        UITapGestureRecognizer *messageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messageTaped:)];
        [headerView.messageImageView addGestureRecognizer:messageTap];
       
        return headerView;
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (isShowPersonSkill) {
        [self performSegueWithIdentifier:@"PersonToShowSkill" sender:indexPath];
    }
}

#pragma make - tap

- (void)personSkillTaped:(id)sender {
    BOOL isPreShowPersonSkill = isShowPersonSkill;
    isShowPersonSkill = YES;
    if (isShowPersonSkill != isPreShowPersonSkill) {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
        [self.collectionView reloadSections:indexSet];
    }
}

- (void)preferedSkillTaped:(id)sender {
    BOOL isPreShowPersonSkill = isShowPersonSkill;
    isShowPersonSkill = NO;
    if (isShowPersonSkill != isPreShowPersonSkill) {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
        [self.collectionView reloadSections:indexSet];
    }
}

- (void)messageTaped:(id)sender {
    [self performSegueWithIdentifier:@"PersonToMessageDetail" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PersonToMessageDetail"]) {
        MessageViewController *controller = [segue destinationViewController];
        controller.theUser = loginUser;
        controller.talkedUser = self.showUser;
        controller.messages = [Global selectMessagesBetweenUser:loginUser andUser:self.showUser];
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
        [loginUser.favoriteUsers addObject:self.showUser];
    }
    else {
        sender.title = @"收藏";
        for (int i = 0; i < loginUser.favoriteUsers.count; i++) {
            if ([loginUser.favoriteUsers[i].ID intValue] == [self.showUser.ID intValue]) {
                [loginUser.favoriteUsers removeObjectAtIndex:i];
                break;
            }
        }
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"http://www.skillpark.co/api/v1/profiles/%d/favorite", [loginUser.ID intValue]];
    NSDictionary *parameters = @{@"auth_token":webTokenStr, @"favorite_id": self.showUser.ID};
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
