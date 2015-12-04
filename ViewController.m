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
#import "CRClassDatabase.h"
#import "UIColor+CRColor.h"
#import "HuskyButton.h"
#import "MORETransitionAnimationDelegate.h"
#import "CRClassTableViewCell.h"

#import "CRAccountsViewController.h"
#import "CRClassAddViewController.h"

@interface ViewController ()<UIScrollViewDelegate, UIViewControllerPreviewingDelegate, UITableViewDataSource, UITableViewDelegate>

@property( nonatomic, strong ) MORETransitionAnimationDelegate *transitionAnimationDelegate;
@property( nonatomic, strong ) UIView *park;
@property( nonatomic, strong ) UILabel *titleLabel;
@property( nonatomic, strong ) UIButton *actionButton;
@property( nonatomic, strong ) UIButton *actionButtonAccount;
@property( nonatomic, strong ) UITableView *bear;

@property( nonatomic, strong ) NSArray *headerViews;
@property( nonatomic, strong ) NSArray *headerViewsLayoutGuide;
@property( nonatomic, strong ) NSMutableArray *shouldRelayoutGuide;

@property( nonatomic, strong ) NSLayoutConstraint *testLayout;

@property( nonatomic, assign ) BOOL once;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    self.title = @"CRLaunch's Class Schedule";
    self.transitionAnimationDelegate = [[MORETransitionAnimationDelegate alloc] initWithAnimationType:CRAnimationTypeDefault];
    self.shouldRelayoutGuide = [NSMutableArray new];
    
    [self doPark];
    [self doBear];
    [self doActionButton];
    [self doHeaderViews];
    
    [self handlerShortcut];
    [self registerForPreviewingWithDelegate:self sourceView:self.view];
}

- (void)viewDidAppear:(BOOL)animated{
    [self.shouldRelayoutGuide enumerateObjectsUsingBlock:^(id obj, NSUInteger i, BOOL *sS){
        NSLayoutConstraint *con = (NSLayoutConstraint *)obj;
        NSUInteger index = [con.identifier integerValue];
        UIView *view = self.headerViews[index];
        CGFloat fuck = view.frame.origin.y - self.view.frame.size.height - self.bear.contentOffset.y;
        con.constant = fuck / 4;
        [self.view layoutIfNeeded];
    }];
}

- (void)handlerShortcut{
    if( [self.title isEqualToString:@"startWithShortcutAdd"] )
        [self CRClassAddViewController];
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit{
    NSLog(@"pressing");
    CRClassAddViewController *ClassAddVC = (CRClassAddViewController *)viewControllerToCommit;
    [ClassAddVC showDismissButton];
    [self presentViewController:viewControllerToCommit animated:YES completion:nil];
}

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location{
    
//    if( ![previewingContext.sourceView isKindOfClass:[UITableViewCell class]] ) return nil;
    NSLog(@"%@", previewingContext.sourceView);
    
    CRClassSchedule *newClassSchedule = [[CRClassSchedule alloc] initFromDictionary:@{
                                                                                      ClassScheduleUser: @"user",
                                                                                      ClassScheduleWeekday: [CRSettings weekday],
                                                                                      ClassScheduleTimeStart: @"7: 00",
                                                                                      ClassScheduleLocation: @"Edit location",
                                                                                      ClassScheduleClassname: @"Edit class name",
                                                                                      ClassScheduleTeacher: @"Edit teacher",
                                                                                      ClassScheduleTimeLong: @"40 mins",
                                                                                      ClassScheduleColorType: @"color",
                                                                                      ClassScheduleUserInfo: @"Add note",
                                                                                      ClassScheduleType: @"nullable type"
                                                                                      }];
    
    CRClassAddViewController *CRClassAddVC = [CRClassAddViewController new];
    
    NSIndexPath *indexPath = [self.bear indexPathForRowAtPoint:location];
    NSLog(@"%ld", indexPath.row);
    
    CRClassAddVC.isPreview = YES;
    CRClassAddVC.classSchedule = newClassSchedule;
    return CRClassAddVC;
}

- (void)doPark{
    NSMutableArray *cons = [NSMutableArray new];
    self.park = [UIView new];
    self.titleLabel = [UILabel new];
    HuskyButton *backButton = [HuskyButton new];
    [self.view addAutolayoutSubviews:@[ self.park ]];
//    [self.park addAutolayoutSubviews:@[ backButton, self.titleLabel ]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.park to:self.view type:EdgeTopLeftRightZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.park type:SpactecledBearFixedHeight constant:0 + STATUS_BAR_HEIGHT]];
    [self.view addConstraints:cons];
    [cons removeAllObjects];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.titleLabel to:self.park type:EdgeBottomZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.titleLabel to:self.park type:EdgeLeftRightZero constant:16]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.titleLabel to:self.park type:EdgeTopZero constant:STATUS_BAR_HEIGHT]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:backButton to:self.park type:EdgeBottomLeftZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:backButton type:SpactecledBearFixedEqual constant:56]];
//    [self.park addConstraints:cons];
    
    self.park.backgroundColor = [UIColor CRColorType:CRColorTypeGoogleMapBlue];
    [self.park makeShadowWithSize:CGSizeMake(0, 1) opacity:0.27 radius:1.7];
    
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [CRSettings appFontOfSize:19];
    self.titleLabel.text = self.title;
    
    backButton.alpha = 0;
    backButton.layer.cornerRadius = 56 / 2.0f;
    backButton.titleLabel.font = [UIFont MaterialDesignIconsWithSize:25];
    [backButton setTitleColor:[UIColor colorWithWhite:33 / 255.0 alpha:1] forState:UIControlStateNormal];
    [backButton setTitle:[UIFont mdiArrowLeft] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(CRAccountsViewController) forControlEvents:UIControlEventTouchUpInside];
}

- (void)doActionButton{
    NSMutableArray *cons = [NSMutableArray new];
    self.actionButton = [UIButton new];
    self.actionButtonAccount = [UIButton new];
    [self.view addAutolayoutSubviews:@[ self.actionButton, self.actionButtonAccount ]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.actionButton to:self.view type:EdgeBottomRightZero constant:16]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.actionButtonAccount to:self.view type:EdgeRightZero constant:16]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.actionButtonAccount to:self.view type:EdgeBottomZero
                                                            constant:16 + 56 + 16]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.actionButtonAccount type:SpactecledBearFixedEqual constant:56]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.actionButton type:SpactecledBearFixedEqual constant:56]];
    [self.view addConstraints:cons];
    [cons removeAllObjects];
    
    self.actionButton.layer.cornerRadius = self.actionButtonAccount.layer.cornerRadius = 56 / 2.0f;
    self.actionButton.titleLabel.font = [UIFont MaterialDesignIcons];
    self.actionButtonAccount.titleLabel.font = [CRSettings appFontOfSize:27];
    self.actionButton.backgroundColor = [UIColor CRColorType:CRColorTypeGoogleMapBlue];
    self.actionButtonAccount.backgroundColor = [UIColor CRColorType:CRColorTypeGoogleYellow];
    [self.actionButton makeShadowWithSize:CGSizeMake(0.0f, 6.0f) opacity:0.3f radius:7.0f];
    [self.actionButtonAccount makeShadowWithSize:CGSizeMake(0.0f, 6.0f) opacity:0.3f radius:7.0f];
    [self.actionButtonAccount addTarget:self action:@selector(CRAccountsViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.actionButtonAccount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.actionButton setTitle:[UIFont mdiPlus] forState:UIControlStateNormal];
    [self.actionButtonAccount setTitle:@"D" forState:UIControlStateNormal];
    [self.actionButton addTarget:self action:@selector(CRClassAddViewController) forControlEvents:UIControlEventTouchUpInside];
}

- (void)doBear{
    _bear = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    [self.view addAutolayoutSubviews:@[ _bear ]];
    [self.view bringSubviewToFront:self.actionButton];
    [self.view bringSubviewToFront:self.park];
    [self.view addConstraints:[NSLayoutConstraint SpactecledBearEdeg:_bear to:self.view type:EdgeAroundZero]];
    
    _bear.sectionHeaderHeight = 142.0f;
    _bear.sectionFooterHeight = 0;
    _bear.contentInset = UIEdgeInsetsMake(STATUS_BAR_HEIGHT + 0, 0, 0, 0);
    _bear.contentOffset = CGPointMake(0, - 0 - STATUS_BAR_HEIGHT);
    _bear.showsHorizontalScrollIndicator = NO;
    _bear.showsVerticalScrollIndicator = NO;
    _bear.backgroundColor = [UIColor whiteColor];
    _bear.separatorStyle = UITableViewCellSeparatorStyleNone;
    _bear.delegate = self;
    _bear.dataSource = self;
}

- (void)doHeaderViews{
    
    NSMutableArray *views = [NSMutableArray new];
    NSMutableArray *cons = [NSMutableArray new];
    NSMutableArray *layoutGuide = [NSMutableArray new];
    NSArray *weekdays = @[ @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday" ];
    
    UIView *wrapper;
    UIImageView *imageView;
    UILabel *weekday;
    NSLayoutConstraint *con;
    for( int fox = 0; fox < 7; fox++ ){
        wrapper = [UIView new]; weekday = [UILabel new];
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"M%d.jpg", fox + 3]]];
        [wrapper addAutolayoutSubviews:@[ imageView, weekday ]];
        [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:weekday to:wrapper type:EdgeLeftRightZero constant:56]];
        [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:weekday to:wrapper type:EdgeTopZero constant:8]];
        [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:weekday type:SpactecledBearFixedHeight constant:56]];
        [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:imageView to:wrapper type:EdgeLeftRightZero]];
        con = [NSLayoutConstraint constraintWithItem:imageView
                                           attribute:NSLayoutAttributeTop
                                           relatedBy:NSLayoutRelationEqual
                                              toItem:wrapper
                                           attribute:NSLayoutAttributeTop
                                          multiplier:1.0
                                            constant:-30];
        if( fox == 1 ) self.testLayout = con;
        con.identifier = [NSString stringWithFormat:@"%d", fox];
        [cons addObject:con];
        [cons addObject:[NSLayoutConstraint constraintWithItem:imageView
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:imageView
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1.0
                                                      constant:0]];
    
        [wrapper addConstraints:cons];
        [cons removeAllObjects];
        wrapper.clipsToBounds = YES;
        weekday.text = weekdays[fox];
        weekday.font = [CRSettings appFontOfSize:25];
        
        [views addObject:wrapper];
        [layoutGuide addObject:con];
    }
    self.headerViews = (NSArray *)views;
    self.headerViewsLayoutGuide = (NSArray *)layoutGuide;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 142.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerViews[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CRCLASS_CELL_ID = @"CRCLASS_CELL_ID";
    
    CRClassTableViewCell *CRCell;
    CRCell = [tableView dequeueReusableCellWithIdentifier:CRCLASS_CELL_ID];
    if( !CRCell ){
        CRCell = [[CRClassTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CRCLASS_CELL_ID];
    }
    
    CRCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CRCell.wrapper.backgroundColor = [UIColor CRColorType:CRColorTypeGoogleMapBlue];
    CRCell.startTime.text = @"18:00";
    CRCell.className.textColor = [UIColor whiteColor];
    CRCell.className.text = @"craig";
    
    if( indexPath.section != 1 ){
        CRCell.wrapper.backgroundColor = [UIColor clearColor];
        CRCell.className.text = @"You dont have a class today";
        CRCell.className.textColor = [UIColor colorWithWhite:157 / 255.0 alpha:1];
        CRCell.startTime.text = @"";
    }
    
    return CRCell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint scrollPoint = scrollView.contentOffset;
    
    [self.shouldRelayoutGuide enumerateObjectsUsingBlock:^(id obj, NSUInteger i, BOOL *sS){
        NSLayoutConstraint *con = (NSLayoutConstraint *)obj;
        NSUInteger index = [con.identifier integerValue];
        UIView *view = self.headerViews[index];
        CGFloat fuck = view.frame.origin.y - scrollView.frame.size.height - scrollPoint.y;
        con.constant = fuck / 4;
        [self.view layoutIfNeeded];
    }];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    [self.shouldRelayoutGuide addObject:self.headerViewsLayoutGuide[section]];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section{
    [self.shouldRelayoutGuide removeObject:self.headerViewsLayoutGuide[section]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"selected %@", indexPath);
}

- (void)CRClassAddViewController{
    CRClassSchedule *createClassSchedule = [[CRClassSchedule alloc] initFromDictionary:@{
                                                                                      ClassScheduleUser: @"user",
                                                                                      ClassScheduleWeekday: [CRSettings weekday],
                                                                                      ClassScheduleTimeStart: @"7: 00",
                                                                                      ClassScheduleLocation: @"Edit location",
                                                                                      ClassScheduleClassname: @"Edit class name",
                                                                                      ClassScheduleTeacher: @"Edit teacher",
                                                                                      ClassScheduleTimeLong: @"40 mins",
                                                                                      ClassScheduleColorType: @"color",
                                                                                      ClassScheduleUserInfo: @"Add note",
                                                                                      ClassScheduleType: @"nullable type"
                                                                                      }];
    
    CRClassAddViewController *CRClassAddVC = [[CRClassAddViewController alloc] initFromClassSchedule:createClassSchedule];
    
    CRClassAddVC.isPreview = NO;
    [self presentViewController:CRClassAddVC animated:YES completion:nil];
}

- (void)CRAccountsViewController{
    CRAccountsViewController *accounts = [CRAccountsViewController new];
    accounts.transitioningDelegate = self.transitionAnimationDelegate;
    [self presentViewController:accounts animated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
