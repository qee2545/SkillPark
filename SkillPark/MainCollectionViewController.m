//
//  MainCollectionViewController.m
//  SkillPark
//
//  Created by qee on 2015/10/26.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "MainCollectionViewController.h"
#import "MainCollectionViewCell.h"
#import "ShowSkillViewController.h"
#import "PersonCollectionViewController.h"

#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>
#import <AFNetworking/AFNetworking.h>

@interface MainCollectionViewController () <CHTCollectionViewDelegateWaterfallLayout>
{   
    BOOL isAllUsersDownload;
    BOOL isAllSkillsDownload;
    BOOL isAllCommentsDownload;
    BOOL isAllCategoriesDownload;
    
    AFHTTPRequestOperationManager *manger;
}
@end

@implementation MainCollectionViewController

static NSString * const reuseIdentifier = @"SkillCell";

static CGFloat const insetTop = 8.0;
static CGFloat const insetLeft = 8.0;
static CGFloat const insetButtom = 8.0;
static CGFloat const insetRight = 8.0;

static CGFloat const minimumColumnSpacing = 8.0;
static CGFloat const minimumInteritemSpacing = 8.0;
static CGFloat const columnCount = 2;


- (UIImage *)setImage:(UIImage *)image fromURLString:(NSString *)urlStr
{
    __block UIImage *skillImage = image;
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:30];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        skillImage = responseObject;
//        NSLog(@"skillImage: %@", skillImage);
//        NSLog(@"image: %@", image);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
    }];
    [requestOperation start];
    
    return skillImage;
}

- (void)getAPIProfiles
{
    NSLog(@"%s", __FUNCTION__);
    
    [manger GET:@"http://www.skillpark.co/api/v1/profiles" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *apiDictionary = responseObject;
        NSNumber *recordCount = apiDictionary[@"metadata"][@"total"];
        for (int i = 0 ; i < [recordCount intValue]; i++) {
            UserModel *user = [[UserModel alloc] init];
            NSNumber *ID = apiDictionary[@"data"][i][@"id"];
            NSString *name = apiDictionary[@"data"][i][@"username"];
            NSString *descript = apiDictionary[@"data"][i][@"description"];
            NSString *photoURL = apiDictionary[@"data"][i][@"photo"];
            NSString *location = apiDictionary[@"data"][i][@"location"];
            NSArray *categoryArray = apiDictionary[@"data"][i][@"category"];
            NSNumber *favorited_users_count = apiDictionary[@"data"][i][@"favorited_users_count"];
            
            NSMutableArray *favorites = apiDictionary[@"data"][i][@"favorites"];
            
            user.ID = ID;
            user.name = name;
            user.descript = descript;
            user.headPhotoURL = photoURL;
            
            user.location = location;
            user.followingNum = [favorited_users_count intValue];
            
            user.favorites = favorites;
            NSLog(@"user.favorites:%@", user.favorites);
        
            if (categoryArray.count > 0) {
                user.likedCategory = [[NSMutableArray alloc] init];
            }       
            for (int i = 0; i < categoryArray.count; i++) {
                CategoryModel *category = [[CategoryModel alloc] init];
                category.ID = categoryArray[i][0];
                category.name = categoryArray[i][1];
                category.imageURL = categoryArray[i][2];
                
                [user.likedCategory addObject:category];
            }
            
            //download headphoto
            NSURL *url = [NSURL URLWithString:user.headPhotoURL];
            NSLog(@"url:%@", url);
            NSLog(@"get headphoto %d", i);
            NSData *data = [[NSData alloc] initWithContentsOfURL:url];
            NSLog(@"get headphoto %d done", i);
            user.headPhoto = [[UIImage alloc] initWithData:data];
            
            [user printInfo];
            [allUsers addObject:user];
        }
        
        isAllUsersDownload = YES;
        [self finishAPIDownload];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"Error %@", error);
    }];
}

- (void)getAPISkills
{
    [manger GET:@"http://www.skillpark.co/api/v1/skills" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary *apiDictionary = responseObject;
        NSNumber *recordCount = apiDictionary[@"metadata"][@"total"];
        for (int i = 0 ; i < [recordCount intValue]; i++) {
            SkillModel *skill = [[SkillModel alloc] init];
            NSString *name = apiDictionary[@"data"][i][@"name"];
            NSString *requirement = apiDictionary[@"data"][i][@"requirement"];
            NSString *descript = apiDictionary[@"data"][i][@"description"];
            NSString *username = apiDictionary[@"data"][i][@"username"];
            NSString *location = apiDictionary[@"data"][i][@"location"];
            NSArray *categoryArray = apiDictionary[@"data"][i][@"category"];
            NSArray *pictureArray = apiDictionary[@"data"][i][@"pictures"];
            NSNumber *liked_users_count = apiDictionary[@"data"][i][@"liked_users_count"];
            
            skill.title = name;
            skill.requirement = requirement;
            skill.descript = descript;
            skill.username = username;
            skill.location = location;
            skill.likeNum = [liked_users_count intValue];
            
            if (categoryArray.count > 0) {
                skill.belongCategory = [[NSMutableArray alloc] init];
            }
            for (int i = 0; i < categoryArray.count; i++) {
                CategoryModel *category = [[CategoryModel alloc] init];
                category.ID = categoryArray[i][0];
                category.name = categoryArray[i][1];
//                category.imageURL = categoryArray[i][2];

                [skill.belongCategory addObject:category];
            }
            
            if (pictureArray.count > 0) {
                skill.imagesURL = [[NSMutableArray alloc] init];
            }
            for (int i = 0; i < pictureArray.count; i++) {
                NSString *imageURL = pictureArray[i][@"url"];
                [skill.imagesURL addObject:imageURL];
            }
            
            //download skill images
//            if (skill.imagesURL.count > 0) {
//                skill.images = [[NSMutableArray alloc] init];
//            }
//            for (int i = 0; i < skill.imagesURL.count; i++) {
//                NSURL *url = [NSURL URLWithString:skill.imagesURL[i]];
//                NSLog(@"get image %d", i);
//                NSData *data = [[NSData alloc] initWithContentsOfURL:url];
//                NSLog(@"get image %d done", i);
//                UIImage *image = [[UIImage alloc] initWithData:data];
//                [skill.images addObject:image];
//            }
//            skill.image = skill.images[skill.images.count - 1];
            
//            [skill printInfo];
            [allSkills addObject:skill];
        }
        
        isAllSkillsDownload = YES;
        [self finishAPIDownload];
  
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"Error %@", error);
    }];
}

- (void)getAPIComments
{
    [manger GET:@"http://www.skillpark.co/api/v1/comments" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary *apiDictionary = responseObject;
        NSNumber *recordCount = apiDictionary[@"metadata"][@"total"];
        for (int i = 0 ; i < [recordCount intValue]; i++) {
            CommentModel *comment = [[CommentModel alloc] init];
            NSNumber *ID = apiDictionary[@"data"][i][@"id"];
            NSString *content = apiDictionary[@"data"][i][@"content"];
            NSString *commentor = apiDictionary[@"data"][i][@"commentor"];
            NSString *commented_user = apiDictionary[@"data"][i][@"commented_user"];
            
            comment.ID = ID;
            comment.content = content;
            comment.commentor = commentor;
            comment.commented_user = commented_user;
            
//            [comment printInfo];
            [allComments addObject:comment];
        }
        
        isAllCommentsDownload = YES;
        [self finishAPIDownload];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"Error %@", error);
    }];
}

- (void)getAPICategory
{
    [manger GET:@"http://www.skillpark.co/api/v1/categories" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary *apiDictionary = responseObject;
        NSNumber *recordCount = apiDictionary[@"metadata"][@"total"];
        for (int i = 0 ; i < [recordCount intValue]; i++) {
            CategoryModel *category = [[CategoryModel alloc] init];
            NSNumber *ID = apiDictionary[@"data"][i][@"id"];
            NSString *name = apiDictionary[@"data"][i][@"name"];
            NSString *category_icon = apiDictionary[@"data"][i][@"category_icon"];
            
            category.ID = ID;
            category.name = name;
            category.imageURL = category_icon;

            NSURL *url = [NSURL URLWithString:category.imageURL];
//            NSLog(@"get category image %d", [category.ID intValue]);
            NSData *data = [[NSData alloc] initWithContentsOfURL:url];
//            NSLog(@"get category image %d done", [category.ID intValue]);
            UIImage *image = [[UIImage alloc] initWithData:data];
            category.image = image;
            
            [allCategories addObject:category];
        }
        
        isAllCategoriesDownload = YES;
        [self finishAPIDownload];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"Error %@", error);
    }];
}

- (void)finishAPIDownload
{
    if (isAllUsersDownload && isAllSkillsDownload && isAllCommentsDownload && isAllCategoriesDownload) {
        
        for (UserModel *user in allUsers) {
            if ([user.name isEqualToString:loginUserName]) {
                loginUser = user;
                break;
            }
        }
        //loginUser = allUsers[1];
        
        for (UserModel *user in allUsers) {
//            NSLog(@"==== user:%@  =====",user.name);
            for (NSArray *favorite in user.favorites) {
                for (UserModel *followUser in allUsers) {
                    if ([favorite[0] intValue] == [followUser.ID intValue]) {
                        if (user.followUsers == nil) {
                            user.followUsers = [[NSMutableArray alloc] init];
                        }
                        [user.followUsers addObject:followUser];
//                        NSLog(@"follow user:%@", user.followUsers[user.followUsers.count - 1].name);
                    }
                }
            }
        }
     
        for (UserModel *user in allUsers) {
            user.skills = [[NSMutableArray alloc] init];
            user.comments = [[NSMutableArray alloc] init];
        }
        
        for (SkillModel *skill in allSkills) {
            for (UserModel *user in allUsers) {
                if ([skill.username isEqualToString:user.name]) {
                    skill.owner = user;
                    [user.skills addObject:skill];
                    break;
                }
            }
        }
        
        for (CommentModel *comment in allComments) {
            for (UserModel *user in allUsers) {
                if ([comment.commentor isEqualToString:user.name] || [comment.commented_user isEqualToString:user.name]) {
                    [user.comments addObject:comment];
                }
            }
        }
        
//        for (UserModel *user in allUsers) {
//            NSLog(@"===========================");
//            NSLog(@"user: %@", user.name);
//            for (CommentModel *comment in user.comments) {
//                NSLog(@"%@ to %@ : %@", comment.commentor, comment.commented_user, comment.content);
//            }
//        }
        
        for (UserModel *user in allUsers) {
            for (CommentModel *comment in user.comments) {
                NSDictionary *commentDic;
                if ([user.name isEqualToString:comment.commentor]) {
                    commentDic = @{@"comment": comment.content, @"to": @1};
                }
                else {
                    commentDic = @{@"comment": comment.content, @"to": @0};
                }
                
                if (user.commentsGroup == nil) {
                    user.commentsGroup = [[NSMutableArray alloc] init];
                }
                
                BOOL isExist = NO;
                for (CommentGroupModel *commnetG in user.commentsGroup) {
                    if ([commnetG.talkedUser.name isEqualToString:comment.commentor] || [commnetG.talkedUser.name isEqualToString:comment.commented_user]) {
                        [commnetG.comments addObject:commentDic];
                        isExist = YES;
                        break;
                    }
                }
                
                if (isExist == NO) {
                    CommentGroupModel *commentGNew = [[CommentGroupModel alloc] init];
                    commentGNew.comments = [[NSMutableArray alloc] init];
                    if ([user.name isEqualToString:comment.commentor]) {
                        for (UserModel *findUser in allUsers) {
                            if ([findUser.name isEqualToString:comment.commented_user]) {
                                commentGNew.talkedUser = findUser;
                                break;
                            }
                        }
                    }
                    else {
                        for (UserModel *findUser in allUsers) {
                            if ([findUser.name isEqualToString:comment.commentor]) {
                                commentGNew.talkedUser = findUser;
                                break;
                            }
                        }
                    }
                    [commentGNew.comments addObject:commentDic];
                    [user.commentsGroup addObject:commentGNew];
                }
            }
//            [user printCommentGroup];
            
            for (CategoryModel* category in user.likedCategory) {
                for (CategoryModel* categoryGold in allCategories) {
                    if ([category.ID isEqualToNumber:categoryGold.ID]) {
                        category.image = categoryGold.image;
                    }
                }
            }
            
        }
        
        [self.collectionView reloadData];
    }
}

- (void)viewDidLoad {
    NSLog(@"%s", __FUNCTION__);
    [super viewDidLoad];
    
//    NSURL *baseURL = [NSURL URLWithString:@"http://www.skillpark.co/"];
    manger = [[AFHTTPRequestOperationManager alloc] init];
    
    isAllUsersDownload = NO;
    isAllSkillsDownload = NO;
    isAllCommentsDownload = NO;
    isAllCategoriesDownload = NO;
    
    allUsers = [[NSMutableArray alloc] init];
    [self getAPIProfiles];
    
    allSkills = [[NSMutableArray alloc] init];
    [self getAPISkills];
    
    allComments = [[NSMutableArray alloc] init];
    [self getAPIComments];
    
    allCategories = [[NSMutableArray alloc] init];
    [self getAPICategory];
    
//    [self fakeData];
    [self setupCollectionView];
    [self registerNibs];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"%s", __FUNCTION__);
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupCollectionView
{
    // Create a waterfall layout
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    
    // Change individual layout attributes for the spacing between cells
    layout.sectionInset = UIEdgeInsetsMake(insetTop, insetLeft, insetButtom, insetRight);
    layout.minimumColumnSpacing = minimumColumnSpacing;
    layout.minimumInteritemSpacing = minimumInteritemSpacing;
    layout.columnCount = columnCount;
    
    // Collection view attributes
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.collectionView.alwaysBounceVertical = true;
    
    // Add the waterfall layout to your collection view
    self.collectionView.collectionViewLayout = layout;
}

- (void)registerNibs
{
    // attach the UI nib file for the ImageUICollectionViewCell to the collectionview
    UINib *cellNib = [UINib nibWithNibName:@"MainCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifier];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of items
//    NSLog(@"allSkills.count:%d", allSkills.count);
    return allSkills.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"====== row:%d =======", indexPath.row);
    MainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    SkillModel *skill = (SkillModel *)allSkills[indexPath.row];
    [cell resetContent];
    [cell setContentWithSkill:skill];
    [cell.nameButton addTarget:self action:@selector(namePressed:) forControlEvents:UIControlEventTouchUpInside];
    
//    NSLog(@"cell frame width:%f height:%f", cell.frame.size.width, cell.frame.size.height);
    
    return cell;
}

- (void)namePressed:(id)sender
{
    UIButton *button = sender;
    NSString *showName = button.titleLabel.text;
    UserModel *showUser;
    for (UserModel *user in allUsers) {
        if ([showName isEqualToString:user.name]) {
            showUser = user;
            break;
        }
    }
    [self performSegueWithIdentifier:@"MainToPerson" sender:showUser];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%s", __FUNCTION__);
    [self performSegueWithIdentifier:@"MainToShowSkill" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    NSLog(@"%s", __FUNCTION__);
    
    if ([segue.identifier isEqualToString:@"MainToShowSkill"]) {
        NSIndexPath *indexPath = sender;
        ShowSkillViewController *controller = [segue destinationViewController];
        controller.showSkill = allSkills[indexPath.row];
        controller.canNameButtonPressed = YES;
    }
    else if ([segue.identifier isEqualToString:@"MainToPerson"]) {
        UserModel *showUser = sender;
        PersonCollectionViewController *controller = [segue destinationViewController];
        controller.showUser = showUser;
    }
    
}

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

#pragma mark <CHTCollectionViewDelegateWaterfallLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"====== row:%d =======", indexPath.row);
    
    //cell width
    CGFloat contentWidth = collectionView.bounds.size.width - insetLeft - insetRight - minimumColumnSpacing;
    CGFloat cellWidth = contentWidth / columnCount;

    //NSLog(@"contentWidth:%f columnWidth:%f cellWidth:%f", contentWidth, columnWidth, cellWidth);

    SkillModel *skill = (SkillModel *)allSkills[indexPath.row];

    MainCollectionViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"MainCollectionViewCell" owner:self options:nil] firstObject];
    
    CGFloat cellHeight = [cell cellHeightForSkill:skill withLimitWidth:cellWidth];
    
//    NSLog(@"cellWidth:%f, cellHeight:%f", cellWidth, cellHeight);
    
    return CGSizeMake(cellWidth, cellHeight);
}

@end
