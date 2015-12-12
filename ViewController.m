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
#import "CRClassCurrent.h"
#import "UIColor+CRColor.h"
#import "HuskyButton.h"
#import "CRClassTableViewCell.h"

#import "CRTransitionAnimationObject.h"
#import "CRAccountsViewController.h"
#import "CRClassScheduleAddViewController.h"
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
@property( nonatomic, assign ) BOOL CAAnimationFlag;
@property( nonatomic, strong ) UITableView *bear;

@property( nonatomic, strong ) NSArray *headerViews;
@property( nonatomic, strong ) NSArray *headerViewsLayoutGuide;
@property( nonatomic, strong ) NSMutableArray *shouldRelayoutGuide;

@property( nonatomic, strong ) NSLayoutConstraint *testLayout;

@property( nonatomic, assign ) BOOL once;

@property( nonatomic, strong ) NSString *accountID;
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
    
    [self doBear];
    [self doPark];
    [self doActionButton];
    [self doHeaderViews];
    
    [self handlerShortcut];
    [self registerForPreviewingWithDelegate:self sourceView:self.bear];
    
//    self.testData = [[NSUserDefaults standardUserDefaults] objectForKey:@"CRClassTestData"];
}

- (void)viewWillAppear:(BOOL)animated{
    CRClassAccount *currentAccount = [CRClassCurrent account];
    self.testData = [CRClassDatabase selectCRClassScheduleFromUser:currentAccount.ID];
    
//    NSLog(@"%@ %ld", self.testData, [self.testData count]);
    
    self.park.backgroundColor =
    self.actionButtonAccount.backgroundColor = [CRSettings CRAppColorTypes][[currentAccount.colorType lowercaseString]];
    [self.actionButtonAccount setTitle:[[currentAccount.ID substringToIndex:1] uppercaseString] forState:UIControlStateNormal];
    
    if( self.isBeingDismissed ){
//        NSLog(@"dismiss");
//        [self.bear reloadData];
    }
    [self.bear reloadData];
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
    
    CRClassScheduleAddViewController *VC = (CRClassScheduleAddViewController *)viewControllerToCommit;
    VC.isPreview = NO;
    
    [self presentViewController:viewControllerToCommit animated:YES completion:nil];
}

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location{
    
    NSIndexPath *indexPath = [self.bear indexPathForRowAtPoint:location];
    
    if( !indexPath ) return nil;
    CRClassTableViewCell *cell = [self.bear cellForRowAtIndexPath:indexPath];

    previewingContext.sourceRect = cell.frame;

    CRClassSchedule *schedule = [CRTestFunction scheduleFromNSArray:self.testData[indexPath.section][indexPath.row]];
    
    CRClassScheduleAddViewController *CRClassScheduleAddVC = ({
        CRClassScheduleAddViewController *VC = [CRClassScheduleAddViewController new];
        VC.classSchedule = schedule;
        VC.isPreview = YES;
        VC;
    });
    
    return CRClassScheduleAddVC;
}

- (void)doPark{
    
    self.park = ({
        UIView *park = [UIView new];
        park.backgroundColor = [UIColor whiteColor];
        [park makeShadowWithSize:CGSizeMake(0, 1) opacity:0.27 radius:1.7];
        park;
    });
    
    self.titleLabel = ({
        UILabel *label = [UILabel new];
        label.alpha = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [CRSettings appFontOfSize:19];
        label.text = self.title;
        label;
    });
    
    [self.view addAutolayoutSubviews:@[ self.park ]];
    [self.park addAutolayoutSubviews:@[ self.titleLabel ]];
    [CRLayout view:@[ self.park, self.view ] type:CREdgeTopLeftRight];
    self.parkLayoutGuide = [NSLayoutConstraint constraintWithItem:self.park
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0
                                                         constant:STATUS_BAR_HEIGHT];
    [self.view addConstraint:self.parkLayoutGuide];
    [CRLayout view:@[ self.titleLabel, self.park ] type:CREdgeBottom constants:UIEdgeInsetsMake(0, 0, -STATUS_BAR_HEIGHT, 0)];
    [CRLayout view:@[ self.titleLabel, self.park ] type:CREdgeLeftRight];
    [CRLayout view:@[ self.titleLabel ] type:CRFixedHeight constants:UIEdgeInsetsMake(0, 56, 0, 0)];
}

- (void)doActionButton{
    
    self.actionButton = ({
        UIButton *button = [UIButton new];
        button.layer.cornerRadius = self.actionButtonAccount.layer.cornerRadius = 56 / 2.0f;
        button.titleLabel.font = [UIFont MaterialDesignIcons];
        button.backgroundColor = [UIColor CRColorType:CRColorTypeGoogleTomato];
        [button makeShadowWithSize:CGSizeMake(0.0f, 1.7f) opacity:0.3f radius:1.7f];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:[UIFont mdiPlus] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(CRClassAddViewController) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    self.actionButtonAccount = ({
        UIButton *button = [UIButton new];
        button.layer.cornerRadius = 56 / 2.0f;
        button.titleLabel.font = [CRSettings appFontOfSize:27];
        button.backgroundColor = [UIColor CRColorType:CRColorTypeGoogleYellow];
        [button makeShadowWithSize:CGSizeMake(0.0f, 1.7f) opacity:0.3f radius:1.7f];
        [button addTarget:self action:@selector(CRAccountsViewController) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"C" forState:UIControlStateNormal];
        button;
    });
    
    [self.view addAutolayoutSubviews:@[ self.actionButtonAccount, self.actionButton ]];
    [CRLayout view:@[ self.actionButton, self.view ] type:CREdgeBottomRight constants:UIEdgeInsetsMake(0, 0, -16, -16)];
    [CRLayout view:@[ self.actionButton ] type:CRFixedEqual constants:UIEdgeInsetsMake(56, 56, 0, 0)];
    [CRLayout view:@[ self.actionButtonAccount, self.view ] type:CREdgeBottomRight constants:UIEdgeInsetsMake(0, 0, -( 32 + 56 ), -16)];
    [CRLayout view:@[ self.actionButtonAccount ] type:CRFixedEqual constants:UIEdgeInsetsMake(56, 56, 0, 0)];
}

- (void)doBear{
    self.bear = ({
        UITableView *bear = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        bear.translatesAutoresizingMaskIntoConstraints = NO;
        bear.sectionFooterHeight = 142.0f;
        bear.sectionFooterHeight = 0;
        bear.contentInset = UIEdgeInsetsMake(STATUS_BAR_HEIGHT + 0, 0, 0, 0);
        bear.contentOffset = CGPointMake(0, - 0 - STATUS_BAR_HEIGHT);
        bear.showsHorizontalScrollIndicator = NO;
        bear.showsVerticalScrollIndicator = NO;
        bear.backgroundColor = [UIColor whiteColor];
        bear.separatorStyle = UITableViewCellSeparatorStyleNone;
        bear.delegate = self;
        bear.dataSource = self;
        bear;
    });
    [self.view addSubview:self.bear];
    [CRLayout view:@[ self.bear, self.view ] type:CREdgeAround];
}

- (void)doHeaderViews{
    
    NSMutableArray *views = [NSMutableArray new];
    NSMutableArray *layoutGuide = [NSMutableArray new];
    NSArray *weekdays = @[ @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday" ];
    
    UIView *wrapper;
    UIImageView *imageView;
    UILabel *weekday;
    NSLayoutConstraint *con;
    for( int fox = 0; fox < 7; fox++ ){
        
        wrapper = ({
            UIView *wrapper = [UIView new];
            wrapper.clipsToBounds = YES;
            wrapper;
        });
        
        weekday = ({
            UILabel *weekday = [UILabel new];
            weekday.text = weekdays[fox];
            weekday.font = [CRSettings appFontOfSize:25];
            weekday;
        });
        
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"M%d.jpg", fox + 3]]];
        
        [wrapper addAutolayoutSubviews:@[ imageView, weekday ]];
        [CRLayout view:@[ weekday, wrapper ] type:CREdgeAround constants:UIEdgeInsetsMake(8, 56, -78, -56)];
        [CRLayout view:@[ imageView, wrapper ] type:CREdgeLeftRight];
        con = [NSLayoutConstraint constraintWithItem:imageView
                                           attribute:NSLayoutAttributeTop
                                           relatedBy:NSLayoutRelationEqual
                                              toItem:wrapper
                                           attribute:NSLayoutAttributeTop
                                          multiplier:1.0
                                            constant:-30];
        con.identifier = [NSString stringWithFormat:@"%d", fox];
        [wrapper addConstraint:con];
        [wrapper addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:imageView
                                                            attribute:NSLayoutAttributeHeight
                                                           multiplier:1.0
                                                             constant:0]];
        
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
        return 66.0f + 12.0f;
    
    return 56.0f + 12.0f;
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
    
    if( indexPath.section == 0 && indexPath.row == [self.testData[0] count] ){
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
    
    CRCell.wrapper.backgroundColor = [CRSettings CRAppColorTypes][[schedule.colorType lowercaseString]];
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
    [self animationFloatingButton:self.actionButton];
    
    CRClassSchedule *schedule = [CRTestFunction scheduleFromNSArray:self.testData[indexPath.section][indexPath.row]];
    
    CRClassScheduleAddViewController *CRClassScheduleAddVC = ({
        CRClassScheduleAddViewController *VC = [CRClassScheduleAddViewController new];
        VC.classSchedule = schedule;
        VC.isPreview = NO;
        VC;
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:CRClassScheduleAddVC animated:YES completion:nil];
    });
}

- (void)CRClassAddViewController{
    CRClassSchedule *schedule = [CRClassSchedule ClassCreateTempleSchedule];
    
    CRClassAddViewController *CRClassAddVC = ({
        CRClassAddViewController *CRClassAddVC = [CRClassAddViewController new];
        CRClassAddVC.model = CRViewModelDefault;
        CRClassAddVC.isPreview = NO;
        CRClassAddVC.classSchedule = schedule;
        CRClassAddVC;
    });
    
    CRClassScheduleAddViewController *CRClassScheduleAdd = [CRClassScheduleAddViewController new];
    CRClassScheduleAdd.type = 1;
    CRClassScheduleAdd.classSchedule = schedule;
    
    [self presentViewController:CRClassScheduleAdd animated:YES completion:nil];
}

- (void)CRAccountsViewController{
    CRAccountsViewController *accounts = [CRAccountsViewController new];
    [self presentViewController:accounts animated:YES completion:nil];
}

- (void)animationFloatingButton:(UIView *)view{
    if( self.CAAnimationFlag ) return;
    
    self.CAAnimationFlag = YES;
    
    CAKeyframeAnimation *scaleAnimation = ({
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        animation.values = @[ @1.0, @1.5, @1.0 ];
        animation;
    });
    
    CABasicAnimation *rotationAnimation = ({
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        animation.fromValue = [NSNumber numberWithFloat:0];
        animation.toValue = [NSNumber numberWithFloat:M_PI];
        animation;
    });
    
    CAAnimationGroup *attention = ({
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.4 :0 :0.2 :1];
        group.duration = 1.0f;
        group.removedOnCompletion = YES;
        group.animations = @[ scaleAnimation, rotationAnimation ];
        group;
    });
    
    attention.delegate = self;
    
    [view.layer addAnimation:attention forKey:@"attention"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    self.CAAnimationFlag = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
