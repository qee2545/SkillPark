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

@interface MainCollectionViewController () <CHTCollectionViewDelegateWaterfallLayout ,DownloadDelegate>
{
    NSUInteger tableDownload;
    UIActivityIndicatorView *activityIndicatorView;
    UIRefreshControl *refreshControl;
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

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(downloadNotifiaction:) name:@"DownloadNoti"
                                               object:nil];
    
    //add refresh UI
    refreshControl = [[UIRefreshControl alloc] init];
    [self.collectionView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refresh:)
             forControlEvents:UIControlEventValueChanged];
    
    [self setupCollectionView];
    [self registerNibs];
    [self tableDownload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupCollectionView {
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

- (void)registerNibs {
    UINib *cellNib = [UINib nibWithNibName:@"MainCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifier];
}

#pragma mark <ActivityIndicator>

- (void)addActivityIndicator {
    activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicatorView];
    activityIndicatorView.center = self.view.center;
    [activityIndicatorView startAnimating];
}

- (void)removeActivityIndicator {
    [activityIndicatorView removeFromSuperview];
}

#pragma mark <Download>

- (void)downloadNotifiaction:(NSNotification*)noti {
    NSDictionary *dic = noti.userInfo;
    NSString *job = dic[@"finishedJob"];
    if([job isEqualToString:@"allTableDownload"]) {
        NSLog(@"noti:AllTableDownload");
        //[self.collectionView reloadData];
        [self presentImageDownload];
    }
    else if([job isEqualToString:@"presentImageDownload"]) {
        NSLog(@"noti:PresentImageDownload");
        [self removeActivityIndicator];
        [self.collectionView reloadData];
    }
}

- (void)tableDownload {
    [self addActivityIndicator];
    
    tableDownload = 0x0;
    
    //four table api download
    skillsTable = [[SkillsTable alloc] init];
    skillsTable.delegate = self;
    skillsTable.apiUrlStr = @"http://www.skillpark.co/api/v1/skills";
    [skillsTable downloadData];
    
    profilesTable = [[ProfilesTable alloc] init];
    profilesTable.delegate = self;
    profilesTable.apiUrlStr = @"http://www.skillpark.co/api/v1/profiles";
    [profilesTable downloadData];
    
    commentsTable = [[CommentsTable alloc] init];
    commentsTable.delegate = self;
    commentsTable.apiUrlStr = @"http://www.skillpark.co/api/v1/comments";
    [commentsTable downloadData];
    
    categoriesTable = [[CategoriesTable alloc] init];
    categoriesTable.delegate = self;
    categoriesTable.apiUrlStr = @"http://www.skillpark.co/api/v1/categories";
    [categoriesTable downloadData];
}

- (void)didFinishTableDownloadWithStyle:(NSUInteger)tableStyle {
    tableDownload |= tableStyle;
    if (tableDownload == AllTableDownLoadFinished) {
        NSLog(@"AllTableDownLoadFinished");
        
        //construction periority could not be changed
        [self constructSkillCategories];
        [self constructUsers];
        [self constructSkills];
        [self constructMessages];
        loginUser = [self findLoginUserByName:loginUserName];

        NSDictionary *dic = @{@"finishedJob": @"allTableDownload"};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadNoti" object:nil userInfo:dic];
    }
}

- (void)presentImageDownload {
    
    NSMutableArray *mutableOperations = [NSMutableArray array];
    
    for (Skill *skill in skills) {
        if (skill.imagesURL.count > 0) {
            NSURL *url = [NSURL URLWithString:skill.imagesURL[0]];
            AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:url]];
            op.responseSerializer = [AFImageResponseSerializer serializer];
            
            [op setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead){
                
            }];
            
            __weak AFHTTPRequestOperation *weakOp = op;
            op.completionBlock = ^{
                NSLog(@"%@ present image download completion %@", skill.name, weakOp.responseObject);
                NSData *imageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation(weakOp.responseObject, 0.6)];
                [skill.images addObject:[UIImage imageWithData:imageData]];
                skill.presentImage = skill.images[0];
            };
            
            [mutableOperations addObject:op];
        }
    }

    NSArray *batches = [AFURLConnectionOperation batchOfRequestOperations:mutableOperations progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
    
    } completionBlock:^(NSArray *operations) {
        NSLog(@"all skill present image download completion");
        NSDictionary *dic = @{@"finishedJob": @"presentImageDownload"};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadNoti" object:nil userInfo:dic];
    }];
    
    [[NSOperationQueue mainQueue] addOperations:batches waitUntilFinished:NO];
}

#pragma mark <Construct Data>

- (void)constructSkillCategories {
    skillCategories = [[NSMutableArray alloc] init];
    for (CategoryRecord *aCategoryRecord in categoriesTable.categoryRecords) {
        SkillCategory *skillCategory = [[SkillCategory alloc] init];
        skillCategory.ID = aCategoryRecord.ID;
        skillCategory.name = aCategoryRecord.name;
        skillCategory.iconURL = aCategoryRecord.categoryIconURL;
        
        [skillCategories addObject:skillCategory];
    }
}

- (void)constructUsers {
    users = [[NSMutableArray alloc] init];
    for (ProfileRecord* aProfileRecord in profilesTable.profileRecords) {
        User *user = [[User alloc] init];
        user.ID = aProfileRecord.ID;
        user.headPhotoURL = aProfileRecord.photo;
        user.name = aProfileRecord.username;
        user.location = aProfileRecord.location;
        user.selfIntro = aProfileRecord.profileDescription;
        user.followCount = aProfileRecord.favoritedUsersCount;
        
        for (CategoryRecord *aCategoryRecord in aProfileRecord.category) {
            for (SkillCategory *skillCategory in skillCategories) {
                if ([aCategoryRecord.ID intValue] == [skillCategory.ID intValue]) {
                    [user.likeCategories addObject:skillCategory];
                }
            }
            
        }
        
        [users addObject:user];
    }
    
    for (ProfileRecord* aProfileRecord in profilesTable.profileRecords) {
        for (User *user in users) {
            if ([aProfileRecord.ID intValue] == [user.ID intValue]) {
                for (NSArray *favoriteElement in aProfileRecord.favorites) {
                    for (User *favoriteUser in users) {
                        if ([favoriteElement[0] intValue] == [favoriteUser.ID intValue]) {
                            [user.favoriteUsers addObject:favoriteUser];
                        }
                    }
                }
            }
        }
    }
}

- (void)constructSkills {
    skills = [[NSMutableArray alloc] init];
    for (SkillRecord *aSkillRecord in skillsTable.skillRecords) {
        Skill *skill = [[Skill alloc] init];
        skill.ID = aSkillRecord.ID;
        skill.name = aSkillRecord.name;
        skill.requirement = aSkillRecord.requirement;
        skill.descript = aSkillRecord.skillDescription;
        skill.username = aSkillRecord.username;
        skill.location = aSkillRecord.location;
        
        for (SkillCategory *skillCategory in skillCategories) {
            if ([aSkillRecord.category.ID intValue] == [skillCategory.ID intValue]) {
                skill.belongCategory = skillCategory;
                break;
            }
        }

        for (NSString *pictureURL in aSkillRecord.pictures) {
            [skill.imagesURL addObject:pictureURL];
        }
        skill.likeCount = aSkillRecord.likedUsersCount;
        
        [skills addObject:skill];
    }
    
    for (Skill *skill in skills) {
        for (User *user in users) {
            if ([skill.username isEqualToString:user.name]) {
                skill.owner = user;
                [user.skills addObject:skill];
                break;
            }
        }
    }
}

- (void)constructMessages {
    messages = [[NSMutableArray alloc] init];
    for (CommentRecord *aCommentRecord in commentsTable.commentRecords) {
        Message *message = [[Message alloc] init];
        message.ID = aCommentRecord.ID;
        for (User *user in users) {
            if ([user.name isEqualToString:aCommentRecord.commentor]) {
                message.fromUser = user;
            }
            if ([user.name isEqualToString:aCommentRecord.commentedUser]) {
                message.toUser = user;
            }
        }
        message.message = aCommentRecord.content;
        
        [messages addObject:message];
    }
}

- (User *)findLoginUserByName:(NSString *)name {
    for (User *user in users) {
        if ([user.name isEqualToString:name]) {
            return user;
        }
    }
    
    return nil;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return skills.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    Skill *skill = (Skill *)skills[indexPath.row];
    [cell resetContent];
    [cell setContentWithSkill:skill];
    [cell.nameButton addTarget:self action:@selector(namePressed:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

- (void)namePressed:(id)sender {
    UIButton *button = sender;
    NSString *showName = button.titleLabel.text;
    User *showUser;
    for (User *user in users) {
        if ([showName isEqualToString:user.name]) {
            showUser = user;
            break;
        }
    }
    [self performSegueWithIdentifier:@"MainToPerson" sender:showUser];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"MainToShowSkill" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MainToShowSkill"]) {
        NSIndexPath *indexPath = sender;
        ShowSkillViewController *controller = [segue destinationViewController];
        controller.showSkill = skills[indexPath.row];
        controller.canNameButtonPressed = YES;
    }
    else if ([segue.identifier isEqualToString:@"MainToPerson"]) {
        User *showUser = sender;
        PersonCollectionViewController *controller = [segue destinationViewController];
        controller.showUser = showUser;
    }
    
}

#pragma mark <CHTCollectionViewDelegateWaterfallLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //cell width
    CGFloat contentWidth = collectionView.bounds.size.width - insetLeft - insetRight - minimumColumnSpacing * (columnCount - 1);
    CGFloat cellWidth = contentWidth / columnCount;
    
    //cell height
    Skill *skill = (Skill *)skills[indexPath.row];
    MainCollectionViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"MainCollectionViewCell" owner:self options:nil] firstObject];
    CGFloat cellHeight = [cell cellHeightForSkill:skill withLimitWidth:cellWidth];
    
    return CGSizeMake(cellWidth, cellHeight);
}

- (void)refresh:(UIRefreshControl *)sender {
    [refreshControl endRefreshing];
}

//- (void)downloadOtherSkillImages {
//    NSLog(@"downloadSkillImages");
//    for (int i = 0; i < allSkills.count; i++) {
//        SkillModel *skill = allSkills[i];
//        NSLog(@"Skill %d has %d images", i, skill.imagesURL.count);
//        for (int j = 1; j < skill.imagesURL.count; j++) {
//            if (skill.images == nil) {
//                skill.images = [[NSMutableArray alloc] init];
//            }
//            NSURL *url = [NSURL URLWithString:skill.imagesURL[j]];
//            NSURLRequest *urlRequest =  [NSURLRequest requestWithURL:url];
//            AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
//            requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
//            [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//                NSLog(@"Response: %@", responseObject);
//                [skill.images addObject:responseObject];
//                //NSLog(@"images count:%d", skill.images.count);
//
//
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                NSLog(@"Image error: %@", error);
//            }];
//            [requestOperation start];
//        }
//    }
//}

@end
