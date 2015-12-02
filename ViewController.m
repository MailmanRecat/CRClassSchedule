//
//  ViewController.m
//  CRClassSchedule
//
//  Created by caine on 12/1/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height

#import "ViewController.h"
#import "UIView+MOREShadow.h"
#import "UIView+MOREStackLayoutView.h"
#import "UIFont+MaterialDesignIcons.h"
#import "CRSettings.h"
#import "UIColor+CRColor.h"
#import "HuskyButton.h"
#import "MORETransitionAnimationDelegate.h"
#import "CRClassTableViewCell.h"

#import "CRAccountsViewController.h"
#import "CRClassAddViewController.h"

@interface ViewController ()<CRClassTableViewCellDelegate, UITableViewDataSource, UITableViewDelegate>

@property( nonatomic, strong ) MORETransitionAnimationDelegate *transitionAnimationDelegate;
@property( nonatomic, strong ) UIView *park;
@property( nonatomic, strong ) UILabel *titleLabel;
@property( nonatomic, strong ) UIButton *actionButton;
@property( nonatomic, strong ) UITableView *bear;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    self.title = @"Class Schedule";
    self.transitionAnimationDelegate = [[MORETransitionAnimationDelegate alloc] initWithAnimationType:CRAnimationTypeReverse];
    
    [self doPark];
    [self doActionButton];
    [self doBear];
    
    [self handlerShortcut];
}

- (void)viewDidAppear:(BOOL)animated{
    [self CRClassAddViewController];
}

- (void)handlerShortcut{
    if( [self.title isEqualToString:@"startWithShortcutAdd"] )
        [self CRClassAddViewController];
}

- (void)doPark{
    NSMutableArray *cons = [NSMutableArray new];
    self.park = [UIView new];
    self.titleLabel = [UILabel new];
    HuskyButton *backButton = [HuskyButton new];
    [self.view addAutolayoutSubviews:@[ self.park ]];
    [self.park addAutolayoutSubviews:@[ self.titleLabel, backButton ]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.park to:self.view type:EdgeTopLeftRightZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.park type:SpactecledBearFixedHeight constant:56 + STATUS_BAR_HEIGHT]];
    [self.view addConstraints:cons];
    [cons removeAllObjects];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.titleLabel to:self.park type:EdgeBottomZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.titleLabel to:self.park type:EdgeLeftRightZero constant:56]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.titleLabel type:SpactecledBearFixedHeight constant:56]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:backButton to:self.park type:EdgeBottomLeftZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:backButton type:SpactecledBearFixedEqual constant:56]];
    [self.park addConstraints:cons];
    
    self.park.backgroundColor = [UIColor whiteColor];
    [self.park makeShadowWithSize:CGSizeMake(0, 1) opacity:0.17 radius:0.3];
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [CRSettings appFontOfSize:[UIFont systemFontSize]];
    self.titleLabel.text = self.title;
    
    backButton.layer.cornerRadius = 56 / 2.0f;
    backButton.titleLabel.font = [UIFont MaterialDesignIconsWithSize:25];
    [backButton setTitleColor:[UIColor colorWithWhite:33 / 255.0 alpha:1] forState:UIControlStateNormal];
    [backButton setTitle:[UIFont mdiArrowLeft] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(CRAccountsViewController) forControlEvents:UIControlEventTouchUpInside];
}

- (void)doActionButton{
    self.actionButton = [UIButton new];
    [self.view addAutolayoutSubviews:@[ self.actionButton ]];
    [self.view addConstraints:[NSLayoutConstraint SpactecledBearEdeg:self.actionButton to:self.view type:EdgeBottomRightZero constant:16]];
    [self.actionButton addConstraints:[NSLayoutConstraint SpactecledBearFixed:self.actionButton type:SpactecledBearFixedEqual constant:56]];
    
    self.actionButton.layer.cornerRadius = 56 / 2.0f;
    self.actionButton.titleLabel.font = [UIFont MaterialDesignIcons];
    self.actionButton.backgroundColor = [UIColor CRColorType:CRColorTypeGoogleMapBlue];
    [self.actionButton makeShadowWithSize:CGSizeMake(0.0f, 6.0f) opacity:0.3f radius:7.0f];
    [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.actionButton setTitle:[UIFont mdiPlus] forState:UIControlStateNormal];
    [self.actionButton addTarget:self action:@selector(CRClassAddViewController) forControlEvents:UIControlEventTouchUpInside];
}

- (void)doBear{
    _bear = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    [self.view addAutolayoutSubviews:@[ _bear ]];
    [self.view bringSubviewToFront:self.actionButton];
    [self.view bringSubviewToFront:self.park];
    [self.view addConstraints:[NSLayoutConstraint SpactecledBearEdeg:_bear to:self.view type:EdgeAroundZero]];
    
    _bear.contentInset = UIEdgeInsetsMake(STATUS_BAR_HEIGHT + 56, 0, 0, 0);
    _bear.contentOffset = CGPointMake(0, - 56 - STATUS_BAR_HEIGHT);
    _bear.showsHorizontalScrollIndicator = NO;
    _bear.showsVerticalScrollIndicator = NO;
    _bear.backgroundColor = [UIColor whiteColor];
    _bear.separatorStyle = UITableViewCellSeparatorStyleNone;
    _bear.delegate = self;
    _bear.dataSource = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 108.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSMutableArray *cons = [NSMutableArray new];
    UIView *wrapper = [UIView new];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"M2.jpg"]];
    UILabel *weekname = [UILabel new];
    [wrapper addAutolayoutSubviews:@[ imageView, weekname ]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:weekname to:wrapper type:EdgeLeftRightZero constant:56]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:weekname to:wrapper type:EdgeTopZero constant:8]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:weekname type:SpactecledBearFixedHeight constant:56]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:imageView to:wrapper type:EdgeTopLeftRightZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint spactecledTwoBearFixed:imageView anotherBear:imageView type:SpactecledBearFixedHeight]];
    
    [wrapper addConstraints:cons];
    [cons removeAllObjects];
    wrapper.clipsToBounds = YES;
    NSString *weeknameText;
    
    if( section == 0 )
        weeknameText = @"Monday";
    if( section == 1 )
        weeknameText = @"Tuesday";
    if( section == 2 )
        weeknameText = @"Wednesday";
    if( section == 3 )
        weeknameText = @"Thursday";
    if( section == 4 )
        weeknameText = @"Friday";
    if( section == 5 )
        weeknameText = @"Saturday";
    if( section == 6 )
        weeknameText = @"Sunday";
    
    weekname.text = weeknameText;
    weekname.font = [CRSettings appFontOfSize:25];
    return wrapper;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CRCLASS_CELL_ID = @"CRCLASS_CELL_ID";
    
    CRClassTableViewCell *CRCell;
    CRCell = [tableView dequeueReusableCellWithIdentifier:CRCLASS_CELL_ID];
    if( !CRCell ){
        CRCell = [[CRClassTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CRCLASS_CELL_ID];
    }
    
    CRCell.startTime.text = @"18:00";
    CRCell.className.text = @"craig";
    CRCell.handler = self;
    
    return CRCell;
}

- (void)CRClassTableViewCellSelectedHandler:(NSIndexPath *)indexPath{
    NSLog(@"indexPath");
}

- (void)CRClassAddViewController{
    CRClassAddViewController *classAdd = [CRClassAddViewController new];
    [self presentViewController:classAdd animated:YES completion:nil];
}

- (void)CRAccountsViewController{
    CRAccountsViewController *accounts = [CRAccountsViewController new];
    accounts.transitioningDelegate = self.transitionAnimationDelegate;
    [self presentViewController:accounts animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
