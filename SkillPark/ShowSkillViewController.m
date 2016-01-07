//
//  ScrollViewController.m
//  SkillPark
//
//  Created by qee on 2015/10/17.
//  Copyright © 2015年 qee. All rights reserved.
//

#import "ShowSkillViewController.h"
#import "PersonCollectionViewController.h"

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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageControlHeightConstraint;
@end

@implementation ShowSkillViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setPresentContent];
}

- (void)setPresentContent {
    //title
    self.titleLabel.text = self.showSkill.name;
    
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
    
    //person info
    NSURL *url = [NSURL URLWithString:self.showSkill.owner.headPhotoURL];
    NSURLRequest *urlRequest =  [NSURLRequest requestWithURL:url];
    [self.headPhotoImageView setImageWithURLRequest:urlRequest
                                   placeholderImage:nil
                                            success:^(NSURLRequest *request, NSHTTPURLResponse * __nullable response, UIImage *image) {
                                                //NSLog(@"success:%@", response);
                                                self.headPhotoImageView.image = image;
                                            }
                                            failure:^(NSURLRequest *request, NSHTTPURLResponse * __nullable response, NSError *error) {
                                                //NSLog(@"error:%@", response);
                                            }
    ];
    self.headPhotoImageView.layer.cornerRadius = self.headPhotoImageView.frame.size.width / 2.0;
    self.headPhotoImageView.clipsToBounds = YES;
    
    NSString *name = self.showSkill.owner.name;
    [self.nameButton setTitle:name forState:UIControlStateNormal];
    
    self.likeNumLabel.text = [NSString stringWithFormat:@"%d", [self.showSkill.likeCount intValue]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //navigation setting
    self.navigationController.navigationBarHidden = NO;
    
    //scroll view setting
    self.skillScrollView.pagingEnabled = YES;
    self.skillScrollView.showsHorizontalScrollIndicator = NO;
    self.skillScrollView.delegate = self;
    
    int pageCount = self.showSkill.imagesURL.count;
    CGFloat width = self.skillScrollView.frame.size.width;
    CGFloat height = self.skillScrollView.frame.size.height;
    self.skillScrollView.contentSize = CGSizeMake(width * pageCount, height);
    
    //srcoll images
    for(int i = 0; i < self.showSkill.images.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width * i, 0, width, height)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = self.showSkill.images[i];
        [self.skillScrollView addSubview:imageView];
    }
    
    for(int i = self.showSkill.images.count; i < pageCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width * i, 0, width, height)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        NSURL *url = [NSURL URLWithString:self.showSkill.imagesURL[i]];
        NSURLRequest *urlRequest =  [NSURLRequest requestWithURL:url];
        __block __weak UIImageView *weakImageView = imageView;
        [weakImageView setImageWithURLRequest:urlRequest
                                    placeholderImage:nil
                                                success:^(NSURLRequest *request, NSHTTPURLResponse * __nullable response, UIImage *image) {
                                                    //NSLog(@"success:%@", response);
                                                    weakImageView.image = image;
                                                }
                                                failure:^(NSURLRequest *request, NSHTTPURLResponse * __nullable response, NSError *error) {
                                                    //NSLog(@"error:%@", response);
                                                }
        ];
        [self.skillScrollView addSubview:imageView];
    }
    
    //page control setting
    self.skillPageControl.numberOfPages = pageCount;
    self.skillPageControl.currentPage = 0;
    self.skillPageControl.hidesForSinglePage = YES;
    self.skillPageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.76 green:0.38 blue:0.33 alpha:1];
    self.skillPageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    
    double heightOfPageControl = 25.0;
    if (pageCount <= 1) {
        heightOfPageControl = 4;
    }
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint
                                            constraintWithItem:self.skillPageControl
                                            attribute:NSLayoutAttributeHeight
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:nil
                                            attribute:NSLayoutAttributeHeight
                                            multiplier:1
                                            constant:heightOfPageControl];
    
    NSArray *constraints = @[heightConstraint];
    
    [self.view addConstraints:constraints];
}

- (void)viewDidAppear:(BOOL)animated { 
    if (self.skillPageControl.numberOfPages <= 1) {
        self.pageControlHeightConstraint = 0;
        [self.skillPageControl setNeedsUpdateConstraints];
        [self.view setNeedsUpdateConstraints];
        [self.skillPageControl layoutIfNeeded];
        [self.view layoutIfNeeded];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = scrollView.frame.size.width;
    NSInteger currentPage = ((scrollView.contentOffset.x - width / 2) / width) + 1;
    [self.skillPageControl setCurrentPage:currentPage];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nameButtonPressed:(UIButton *)sender {
    if (self.canNameButtonPressed) {
        [self performSegueWithIdentifier:@"ShowSkillToPerson" sender:nil];
    }
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PersonCollectionViewController *controller = [segue destinationViewController];
    controller.showUser = self.showSkill.owner;
}

@end
