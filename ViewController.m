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
#import "CRClassTableViewCell.h"

#import "CRTransitionAnimationObject.h"
#import "CRAccountsViewController.h"
#import "CRClassAddViewController.h"

#import "CRTestFunction.h"

@interface ViewController ()<CRTransitionAnimationDataSource, UIScrollViewDelegate, UIViewControllerPreviewingDelegate, UITableViewDataSource, UITableViewDelegate>

@property( nonatomic, strong ) CRTransitionAnimationObject *transitionAnimationObject;
@property( nonatomic, assign ) CGRect InitialFrame;
@property( nonatomic, strong ) CRTransitionAnimationObject *transitionAnimationDafult;
@property( nonatomic, strong ) UIView *park;
@property( nonatomic, strong ) NSLayoutConstraint *parkLayoutGuide;
@property( nonatomic, strong ) UILabel *titleLabel;
@property( nonatomic, strong ) UIButton *actionButton;
@property( nonatomic, strong ) UIButton *actionButtonAccount;
@property( nonatomic, strong ) UITableView *bear;

@property( nonatomic, strong ) NSArray *headerViews;
@property( nonatomic, strong ) NSArray *headerViewsLayoutGuide;
@property( nonatomic, strong ) NSMutableArray *shouldRelayoutGuide;

@property( nonatomic, strong ) NSLayoutConstraint *testLayout;

@property( nonatomic, assign ) BOOL once;

@property( nonatomic, strong ) NSArray *testData;

@end

@implementation ViewController

- (CGRect)CRTransitionAnimationFolderFinalFrame{
    return self.view.bounds;
}

- (CGRect)CRTransitionAnimationFolderInitialFrame{
    NSLog(@"%f %f %f %f", self.InitialFrame.origin.x, self.InitialFrame.origin.y, self.InitialFrame.size.width, self.InitialFrame.size.height);
    return self.InitialFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    self.title = @"CRLaunch's Class Schedule";
    self.transitionAnimationObject = [CRTransitionAnimationObject folderCRTransitionAnimation];
    self.transitionAnimationObject.dataSource = self;
    self.transitionAnimationDafult = [CRTransitionAnimationObject defaultCRTransitionAnimation];
    self.shouldRelayoutGuide = [NSMutableArray new];
    
    [self doPark];
    [self doBear];
    [self doActionButton];
    [self doHeaderViews];
    
    [self handlerShortcut];
    [self registerForPreviewingWithDelegate:self sourceView:self.bear];
    
    self.testData = [[NSUserDefaults standardUserDefaults] objectForKey:@"CRClassTestData"];
}

- (void)viewDidAppear:(BOOL)animated{
    [self.shouldRelayoutGuide enumerateObjectsUsingBlock:^(id obj, NSUInteger i, BOOL *sS){
        NSLayoutConstraint *con = (NSLayoutConstraint *)obj;
        NSUInteger index = [con.identifier integerValue];
        UIView *view = self.headerViews[index];
        CGFloat fuck = view.frame.origin.y - self.view.frame.size.height - self.bear.contentOffset.y;
        con.constant = fuck / 3;
    }];
    [self.bear layoutIfNeeded];
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
    
    NSIndexPath *indexPath = [self.bear indexPathForRowAtPoint:location];
    
    if( !indexPath ) return nil;
    UITableViewCell *cell = [self.bear cellForRowAtIndexPath:indexPath];
    previewingContext.sourceRect = cell.frame;

    CRClassSchedule *schedule = [CRTestFunction scheduleFromNSArray:self.testData[indexPath.section][indexPath.row]];
    CRClassAddViewController *CRClassAddVC = [CRClassAddViewController shareFromClassSchedule:schedule];
    CRClassAddVC.isPreview = YES;
    return CRClassAddVC;
}

- (void)doPark{
    NSMutableArray *cons = [NSMutableArray new];
    self.park = [UIView new];
    self.titleLabel = [UILabel new];
    HuskyButton *backButton = [HuskyButton new];
    [self.view addAutolayoutSubviews:@[ self.park ]];
    [self.park addAutolayoutSubviews:@[ self.titleLabel ]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.park to:self.view type:EdgeTopLeftRightZero]];
    self.parkLayoutGuide = [NSLayoutConstraint constraintWithItem:self.park
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0
                                                         constant:STATUS_BAR_HEIGHT];
    [self.view addConstraint:self.parkLayoutGuide];
    [self.view addConstraints:cons];
    [cons removeAllObjects];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.titleLabel to:self.park type:EdgeBottomZero
                                                            constant:STATUS_BAR_HEIGHT]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.titleLabel to:self.park type:EdgeLeftRightZero constant:16]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.titleLabel type:SpactecledBearFixedHeight constant:56]];
    [self.park addConstraints:cons];
    [cons removeAllObjects];
    
    self.park.backgroundColor = [UIColor CRColorType:CRColorTypeGoogleYellow];
    [self.park makeShadowWithSize:CGSizeMake(0, 1) opacity:0.27 radius:1.7];
    
    self.titleLabel.alpha = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [CRSettings appFontOfSize:19];
    self.titleLabel.text = self.title;
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
    self.actionButton.backgroundColor = [UIColor CRColorType:CRColorTypeGoogleTomato];
    self.actionButtonAccount.backgroundColor = [UIColor CRColorType:CRColorTypeGoogleYellow];
    [self.actionButton makeShadowWithSize:CGSizeMake(0.0f, 6.0f) opacity:0.3f radius:7.0f];
    [self.actionButtonAccount makeShadowWithSize:CGSizeMake(0.0f, 6.0f) opacity:0.3f radius:7.0f];
    [self.actionButtonAccount addTarget:self action:@selector(CRAccountsViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.actionButtonAccount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.actionButton setTitle:[UIFont mdiPlus] forState:UIControlStateNormal];
    [self.actionButtonAccount setTitle:@"C" forState:UIControlStateNormal];
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
    NSUInteger offset = 0;
    if( section == 0 ) offset = 1;
    return [self.testData[section] count] == 0 ? 1 : [self.testData[section] count] + offset;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 142.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if( indexPath.row == 0 || indexPath.row + 1 == [self tableView:tableView numberOfRowsInSection:indexPath.section] )
        return 66.0f + 20.0f;
    
    return 56.0f + 20.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerViews[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CRClassTableViewCell *CRCell;
    if( [self.testData[indexPath.section] count] == 0 ){
        CRCell = [tableView dequeueReusableCellWithIdentifier:CRClassCellNoClassID];
        if( !CRCell ){
            CRCell = [[CRClassTableViewCell alloc] initFromNoClass];
        }
        
//        [CRCell makeTopWhiteStroke];
//        [CRCell makeBottomWhiteSpace];
        
        return CRCell;
    }
    
    if( indexPath.section == 0 && indexPath.row == 6 ){
        CRCell = [tableView dequeueReusableCellWithIdentifier:CRClassCellMomentID];
        if( !CRCell ){
            CRCell = [[CRClassTableViewCell alloc] initFromMomentWithColor:[UIColor randomColor]];
        }
        return CRCell;
    }
    
    CRClassSchedule *schedule = [CRTestFunction scheduleFromNSArray:self.testData[indexPath.section][indexPath.row]];
    
    CRCell = [tableView dequeueReusableCellWithIdentifier:CRClassCellDefaultID];
    if( !CRCell ){
        CRCell = [[CRClassTableViewCell alloc] initFromDefault];
    }
    
    CRCell.wrapper.backgroundColor = [CRSettings CRAppColorTypes][schedule.colorType];
    CRCell.startTime.text = schedule.timeStart;
    CRCell.className.text = schedule.classname;
    CRCell.location.text = schedule.location;
    
    if( indexPath.row == 0 ) [CRCell makeTopWhiteSpace]; else [CRCell makeTopWhiteStroke];
    if( indexPath.row + 1 == [self tableView:tableView numberOfRowsInSection:indexPath.section] ) [CRCell makeBottomWhiteSpace];
    else [CRCell makeBottomWhiteStroke];
    
    return CRCell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint scrollPoint = scrollView.contentOffset;
    
    if( scrollPoint.y < -20 ){
        CGFloat offset = fabs(scrollPoint.y);
        CGFloat alpha = (offset - 56) / 56.0;
        if( alpha <= 1 && alpha >= 0 ) self.titleLabel.alpha = alpha;
        if( alpha >  1 && self.titleLabel.alpha != 1 ) self.titleLabel.alpha = 1;
        self.parkLayoutGuide.constant = offset;
    }else{
        self.titleLabel.alpha = 0;
        self.parkLayoutGuide.constant = STATUS_BAR_HEIGHT;
    }
    
    [self.shouldRelayoutGuide enumerateObjectsUsingBlock:^(id obj, NSUInteger i, BOOL *sS){
        NSLayoutConstraint *con = (NSLayoutConstraint *)obj;
        NSUInteger index = [con.identifier integerValue];
        UIView *view = self.headerViews[index];
        CGFloat fuck = view.frame.origin.y - scrollView.frame.size.height - scrollPoint.y;
        con.constant = fuck / 3;
    }];
    
    [self.view layoutIfNeeded];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    [self.shouldRelayoutGuide addObject:self.headerViewsLayoutGuide[section]];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section{
    [self.shouldRelayoutGuide removeObject:self.headerViewsLayoutGuide[section]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"selected %@", indexPath);
//    CRClassTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    self.InitialFrame = [cell convertRect:cell.wrapper.frame toView:self.view];
//    CRClassSchedule *schedule = [CRTestFunction scheduleFromNSArray:self.testData[indexPath.section][indexPath.row]];
//    CRClassAddViewController *CRClassAddVC = [CRClassAddViewController shareFromClassSchedule:schedule];
//    CRClassAddVC.transitioningDelegate = self.transitionAnimationObject;
//    [self presentViewController:CRClassAddVC animated:YES completion:nil];
}

- (void)CRClassAddViewController{
    CRClassSchedule *schedule = [CRClassSchedule ClassCreateTempleSchedule];
    CRClassAddViewController *CRClassAddVC = [CRClassAddViewController shareFromClassSchedule:schedule];
    
    CRClassAddVC.isPreview = NO;
    [self presentViewController:CRClassAddVC animated:YES completion:nil];
}

- (void)CRAccountsViewController{
    CRAccountsViewController *accounts = [CRAccountsViewController new];
    accounts.transitioningDelegate = self.transitionAnimationDafult;
    [self presentViewController:accounts animated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
