//
//  ScrollViewController.m
//  SkillPark
//
//  Created by qee on 2015/10/17.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "ShowSkillViewController.h"
#import "PersonCollectionViewController.h"
#import "SkillModel.h"

@interface ShowSkillViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *skillScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *skillPageControl;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *requireLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@property (weak, nonatomic) IBOutlet UILabel *likeNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headPhotoImageView;
@property (weak, nonatomic) IBOutlet UIButton *nameButton;

@end

@implementation ShowSkillViewController

- (void)setPresentContent
{
    //title
    self.titleLabel.text = self.showSkill.title;
    
    //location
    if(self.showSkill.location.length > 0) {
        self.locationLabel.text = [NSString stringWithFormat:@"@%@", self.showSkill.location ];
    }
    
    //requirement
    if(self.showSkill.requirement.length > 0) {
        self.requireLabel.text = [NSString stringWithFormat:@"自備工具 - %@", self.showSkill.requirement];
    }
    
    //description
    self.descriptionLabel.text = self.showSkill.descript;
    
    //person
    self.headPhotoImageView.image = self.showSkill.owner.headPhoto;
    self.headPhotoImageView.layer.cornerRadius = self.headPhotoImageView.frame.size.width / 2.0;
    self.headPhotoImageView.clipsToBounds = YES;
    
    NSString *name = self.showSkill.owner.name;
    [self.nameButton setTitle:name forState:UIControlStateNormal];
    
    
    //UIImage *buttonImage = [UIImage imageNamed:@"Heart"];
    //[self.followButton setImage:buttonImage forState:UIControlStateHighlighted];
    //[self.followButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    //self.followButton.contentMode = UIViewContentModeScaleAspectFit;
    
    self.likeNumLabel.text = [NSString stringWithFormat:@"%d", self.showSkill.likeNum];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setPresentContent];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%s", __FUNCTION__);
    [super viewWillAppear:animated];    
    
    //navigation setting
    self.navigationController.navigationBarHidden = NO;
    
    //scroll view setting
    self.skillScrollView.pagingEnabled = YES;
    self.skillScrollView.showsHorizontalScrollIndicator = NO;
    self.skillScrollView.delegate = self;
    
    int pageCount = self.showSkill.images.count;
    CGFloat width = self.skillScrollView.frame.size.width;
    CGFloat height = self.skillScrollView.frame.size.height;
    self.skillScrollView.contentSize = CGSizeMake(width * pageCount, height);
    
    //srcoll images
    for(int i = 0; i < pageCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width * i, 0, width, height)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = self.showSkill.images[pageCount - 1 - i];
        [self.skillScrollView addSubview:imageView];
    }
    
    //page control setting
    self.skillPageControl.numberOfPages = pageCount;
    self.skillPageControl.currentPage = 0;
    self.skillPageControl.hidesForSinglePage = YES;
    self.skillPageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.76 green:0.38 blue:0.33 alpha:1];
    self.skillPageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
}

//- (void)viewDidAppear:(BOOL)animated {
//    NSLog(@"%s", __FUNCTION__);
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    NSLog(@"%s", __FUNCTION__);
//}
//
//- (void)viewDidDisappear:(BOOL)animated {
//    NSLog(@"%s", __FUNCTION__);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width = scrollView.frame.size.width;
    NSInteger currentPage = ((scrollView.contentOffset.x - width / 2) / width) + 1;
    [self.skillPageControl setCurrentPage:currentPage];
}

- (IBAction)followButtonPressed:(UIButton *)sender
{
    UIImage *buttonImage = [UIImage imageNamed:@"Heart Filled"];
//    [self.followButton setImage:buttonImage forState:UIControlStateNormal];
//    [self.followButton setImage:buttonImage forState:UIControlStateHighlighted];
}
- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nameButtonPressed:(UIButton *)sender
{
    if (self.canNameButtonPressed) {
        [self performSegueWithIdentifier:@"ShowSkillToPerson" sender:nil];
    }
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PersonCollectionViewController *controller = [segue destinationViewController];
    controller.showUser = self.showSkill.owner;
}


@end
