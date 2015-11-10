//
//  SelfPersonCollectionViewController.m
//  SkillPark
//
//  Created by qee on 2015/11/2.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "SelfPersonCollectionViewController.h"
#import "SelfPersonCollectionViewCell.h"
#import "SelfPreferCollectionViewCell.h"
#import "SelfHeaderCollectionReusableView.h"
#import "ShowSkillViewController.h"

@interface SelfPersonCollectionViewController ()
{
    UserModel *theUser;
    BOOL isShowPersonSkill;

}
@end

@implementation SelfPersonCollectionViewController

static NSString * const selfPersonReuseIdentifier = @"SelfPersonSkillCell";
static NSString * const selfPreferReuseIdentifier = @"SelfPreferSkillCell";

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
    
    //theUser = allUsers[1];
    theUser = loginUser;
    isShowPersonSkill = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of items
    if (isShowPersonSkill) {
        return theUser.skills.count;
    }
    
    return theUser.likedCategory.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //    NSLog(@"%s", __FUNCTION__);
    
    SelfPersonCollectionViewCell *personCell = [collectionView dequeueReusableCellWithReuseIdentifier:selfPersonReuseIdentifier forIndexPath:indexPath];
    
    if (isShowPersonSkill) {
        [personCell setPersonCellWithSkill:theUser.skills[indexPath.row]];
    }
    else {
        SelfPreferCollectionViewCell *preferCell = [collectionView dequeueReusableCellWithReuseIdentifier:selfPreferReuseIdentifier forIndexPath:indexPath];
        
        [preferCell setPreferCellWithCategory:theUser.likedCategory[indexPath.row]];
        
        return preferCell;
    }
    
    return personCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"SelfPersonToShowSkill" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SelfPersonToShowSkill"]) {
        NSIndexPath *indexPath = sender;
        ShowSkillViewController *controller = [segue destinationViewController];
        controller.showSkill = theUser.skills[indexPath.row];
        controller.canNameButtonPressed = NO;
    }
}

// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"%s indexPath:%@", __FUNCTION__, indexPath);
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SelfHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SelfHeaderView" forIndexPath:indexPath];
        
        [headerView setHeaderViewWithUser:theUser];
        
        //adjust header height
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
        flowLayout.headerReferenceSize = [headerView sizeOfHeaderView];
        //        NSLog(@"size %f", flowLayout.headerReferenceSize.height);
        
        UITapGestureRecognizer *personSkillTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personSkillTaped:)];
        [headerView.goodImageView addGestureRecognizer:personSkillTap];
        
        UITapGestureRecognizer *preferSkillTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(preferSkillTaped:)];
        [headerView.learnImageView addGestureRecognizer:preferSkillTap];
        
        return headerView;
    }
    
    return nil;
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

@end
