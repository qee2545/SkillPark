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
#import "UserModel.h"
#import "SkillModel.h"

@interface PersonCollectionViewController () <UICollectionViewDelegateFlowLayout>
{
    BOOL isShowPersonSkill;
}
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
    NSLog(@"%s", __FUNCTION__);
    [super viewDidLoad];
    
    [self setLayout];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
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
//    self.flowLaout.estimatedItemSize = CGSizeMake(width, width);
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    if (self.navigationController.navigationBarHidden) {
        self.collectionView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    }
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __FUNCTION__);
    
    if (!isShowPersonSkill) {
        double categoryWidth = ([UIScreen mainScreen].bounds.size.width - leftInset - rightInset - minimumInteritemSpacing * (categoryColumnCount - 1)) / categoryColumnCount;
        double categoryHeight = 30;
        
        return CGSizeMake(categoryWidth, categoryHeight);
    }
    
    double skillWidth = ([UIScreen mainScreen].bounds.size.width - leftInset - rightInset - minimumInteritemSpacing * (skillColumnCount - 1)) / skillColumnCount;
    double skillHeight = skillWidth;
    
    return CGSizeMake(skillWidth, skillHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    NSLog(@"%s", __FUNCTION__);
    return UIEdgeInsetsMake(topInset, leftInset, buttomInset, rightInset);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    NSLog(@"%s", __FUNCTION__);
    return minimumLineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    NSLog(@"%s", __FUNCTION__);
    return minimumInteritemSpacing;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSLog(@"%s", __FUNCTION__);
//#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"self.theUser.skills.count: %d", self.theUser.skills.count);
//#warning Incomplete implementation, return the number of items
    return self.theUser.skills.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __FUNCTION__);
    
    PersonCollectionViewCell *personCell = [collectionView dequeueReusableCellWithReuseIdentifier:personReuseIdentifier forIndexPath:indexPath];
    
    if (isShowPersonSkill) {
        [personCell setPersonCellWithSkill:self.theUser.skills[indexPath.row]];
    }
    else {
        PreferCollectionViewCell *preferCell = [collectionView dequeueReusableCellWithReuseIdentifier:preferReuseIdentifier forIndexPath:indexPath];
        
        [preferCell setPreferCellWith:@"Ruby"];
        
        return preferCell;
    }
 
    return personCell;
}

// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __FUNCTION__);
    HeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
 
    [headerView setHeaderViewWithUser:self.theUser];
    
    //adjust header height
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    flowLayout.headerReferenceSize = [headerView sizeOfHeaderView];
    
    NSLog(@"size %f", flowLayout.headerReferenceSize.height);
    
    return headerView;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return [self.headerView sizeOfHeaderView];
//}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/
#pragma make - button pressed

- (IBAction)personSkillPressed:(UIButton *)sender
{
    NSLog(@"%s", __FUNCTION__);
    BOOL isPreShowPersonSkill = isShowPersonSkill;
    isShowPersonSkill = YES;
    if (isShowPersonSkill != isPreShowPersonSkill) {
//        [self.collectionView reloadData];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
        [self.collectionView reloadSections:indexSet];
    }
}

- (IBAction)preferSkillPressed:(UIButton *)sender
{
    NSLog(@"%s", __FUNCTION__);
    BOOL isPreShowPersonSkill = isShowPersonSkill;
    isShowPersonSkill = NO;
    if (isShowPersonSkill != isPreShowPersonSkill) {
//        [self.collectionView reloadData];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
        [self.collectionView reloadSections:indexSet];
    }
}

@end
