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
#import "TimeTalkerBird.h"
#import "GoogleInboxLoadingView.h"

#import "CRTransitionAnimationObject.h"
#import "CRAccountsViewController.h"
#import "CRClassScheduleAddViewController.h"

#import "CRTestFunction.h"
#import "UIWindow+CRAction.h"

static NSString *const TIME_LINE_NOW = @"TIME_LINE_NOW";

@interface ViewController ()<CRClassAddViewControllerPreviewActionHandler,
    UIScrollViewDelegate,
    UIViewControllerPreviewingDelegate,
    UITableViewDataSource,
    UITableViewDelegate
>

@property( nonatomic, strong ) CRTransitionAnimationObject *transitionAnimationDafult;

@property( nonatomic, strong ) UIView *park;
@property( nonatomic, strong ) NSLayoutConstraint *parkLayoutGuide;
@property( nonatomic, strong ) UILabel *titleLabel;
@property( nonatomic, strong ) UIImageView *parkImageView;

@property( nonatomic, strong ) GoogleInboxLoadingView *loadingView;
@property( nonatomic, strong ) UIButton *actionButton;
@property( nonatomic, strong ) UIButton *actionButtonAccount;
@property( nonatomic, assign ) BOOL CAAnimationFlag;

@property( nonatomic, strong ) UITableView *bear;
@property( nonatomic, strong ) NSArray *headerViews;
@property( nonatomic, strong ) NSArray *headerViewsLayoutGuide;
@property( nonatomic, strong ) NSMutableArray *shouldRelayoutGuide;

@property( nonatomic, strong ) NSIndexPath *previewIndexPath;
@property( nonatomic, strong ) CRClassSchedule *previewSchedule;

@property( nonatomic, strong ) UIColor *themeColor;
@property( nonatomic, strong ) NSString *accountID;
@property( nonatomic, strong ) NSArray *testData;

@property( nonatomic, assign ) NSUInteger timeLineIndexSection;
@property( nonatomic, assign ) NSUInteger timeLineIndexRow;

@property( nonatomic, assign ) BOOL isViewDidAppear;
@property( nonatomic, assign ) BOOL shouldPresentAddClassViewController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.isViewDidAppear = NO;
    
    self.transitionAnimationDafult = [CRTransitionAnimationObject defaultCRTransitionAnimation];
    self.shouldRelayoutGuide = [NSMutableArray new];
    
    [self doBear];
    [self doPark];
    [self doActionButton];
    [self doHeaderViews];
    [self makeLoading];
    
    [self addNotificationObserver];
    [self check3DTouch];
    
    [self makeClassAccount];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if( !self.isViewDidAppear ){
        
        [self.bear scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.timeLineIndexSection]
                         atScrollPosition:UITableViewScrollPositionTop
                                 animated:NO];
        [self layoutHeaderView:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.isViewDidAppear = YES;
    
    if( self.shouldPresentAddClassViewController ){
        [self CRClassAddViewController];
        self.shouldPresentAddClassViewController = NO;
    }
}

- (void)makeClassAccount{
    CRClassAccount *currentAccount = [CRClassCurrent account];
    self.themeColor = [CRSettings CRAppColorTypes][[currentAccount.colorType lowercaseString]];
    
    self.titleLabel.text = currentAccount.ID;
    self.park.backgroundColor = self.actionButtonAccount.backgroundColor = self.view.backgroundColor = self.themeColor;
    [self.actionButtonAccount setTitle:[[currentAccount.ID substringToIndex:1] uppercaseString] forState:UIControlStateNormal];
    
    [self makeClassSchedule];
}

- (void)makeClassSchedule{
    
    [self makeFullClassSchedule];
    [self.bear reloadData];
    [self layoutHeaderView:YES];
}

- (void)makeFullClassSchedule{
    
    [self.loadingView ON];
    NSArray *schedules = ({
        NSString *nowTimeString = ({
            NSDateComponents *now = [TimeTalkerBird currentDate];
            
            NSString *(^formatTimeFromStirng)(NSUInteger) = ^(NSUInteger time){
                return time < 10 ? [NSString stringWithFormat:@"0%ld", (unsigned long)time] : [NSString stringWithFormat:@"%ld", (unsigned long)time];
            };
            
            [NSString stringWithFormat:@"%@:%@", formatTimeFromStirng(now.hour), formatTimeFromStirng(now.minute)];
        });
        
        CRClassSchedule *current = ({
            CRClassSchedule *current = [CRClassSchedule ClassCreateTempleSchedule];
            current.scheduleID = TIME_LINE_NOW;
            current.timeStart = nowTimeString;
            current;
        });
        
        NSUInteger weekday = ({
            NSUInteger weekday = [CRSettings weekdayFromString:[CRSettings weekday]] - 1;
            weekday == -2 ? 0 : weekday;
        });
        
        NSMutableArray *schedules = [[NSMutableArray alloc] initWithArray:[CRClassCurrent classSchedule]];
        
        NSArray *row, *schedule;
        NSMutableArray *todaySchedules = [[NSMutableArray alloc] initWithArray:schedules[weekday]];
        row = [CRClassDatabase rowFromCRClassSchedule:current];
        [todaySchedules addObject:row];
        schedule = [CRClassDatabase sortCRClassScheduleByTime:(NSArray *)todaySchedules];
        
        self.timeLineIndexSection = weekday;
        self.timeLineIndexRow = [schedule indexOfObject:row];
        
        [schedules replaceObjectAtIndex:weekday withObject:schedule];
        
        (NSArray *)schedules;
    });
    
    self.testData = schedules;
    [self.loadingView OFF];
}

- (void)addNotificationObserver{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self
               selector:@selector(handlerShortcut)
                   name:@"FUCK"
                 object:nil];
    
    [center addObserver:self
               selector:@selector(makeClassSchedule)
                   name:CRClassScheduleUpdatedNotification
                 object:nil];
    
    [center addObserver:self
               selector:@selector(makeClassAccount)
                   name:CRClassAccountDidChangeNotification
                 object:nil];
    
    [center addObserver:self
               selector:@selector(testing)
                   name:UIApplicationDidBecomeActiveNotification
                 object:nil];
}

- (void)testing{
    if( self.isViewDidAppear ){
        [self makeClassSchedule];
    }
}

- (void)check3DTouch{
    BOOL support3DTouch = YES;
    
    if( self.traitCollection.forceTouchCapability != UIForceTouchCapabilityAvailable ) support3DTouch = NO;
    if( ![self.traitCollection respondsToSelector:@selector(forceTouchCapability)] ) support3DTouch = NO;
    
    if( support3DTouch )
        [self registerForPreviewingWithDelegate:self sourceView:self.bear];
}

- (void)handlerShortcut{
    if( self.isViewDidAppear )
        [self CRClassAddViewController];
    else
        self.shouldPresentAddClassViewController = YES;
}

- (void)CRClassAddPreviewAction:(NSString *)type fromController:(UIViewController *)controller{
    if( [type isEqualToString:@"Edit Class"] ){
        
        [self presentViewController:({
            CRClassScheduleAddViewController *vc = [CRClassScheduleAddViewController new];
            vc.title = @"Edit class";
            vc.type = 1;
            vc.classSchedule = self.previewSchedule;
            vc;
        })
                           animated:YES
                         completion:nil];
        
    }
    
    if( [type isEqualToString:@"Delete"] ){
        BOOL delete = [CRClassDatabase deleteCRClassSchedule:self.previewSchedule];
        if( delete ){
            [self makeFullClassSchedule];
            if( [self tableView:self.bear numberOfRowsInSection:self.previewIndexPath.section] == 1 )
                [self.bear reloadData];
            else
                [self.bear deleteRowsAtIndexPaths:@[ self.previewIndexPath ] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
    
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit{
    
    CRClassScheduleAddViewController *VC = (CRClassScheduleAddViewController *)viewControllerToCommit;
    VC.isPreview = NO;
    
    [self presentViewController:viewControllerToCommit animated:YES completion:nil];
}

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location{
    
    NSIndexPath *indexPath = [self.bear indexPathForRowAtPoint:location];
    
    BOOL makeReturn = NO;
    
    if( [self.testData[indexPath.section] count] == 0 ) makeReturn = YES;
    if( indexPath.section == self.timeLineIndexSection && indexPath.row == self.timeLineIndexRow ) makeReturn = YES;
    
    if( makeReturn ) return nil;
    if( !indexPath ) return nil;
    
    CRClassTableViewCell *cell = [self.bear cellForRowAtIndexPath:indexPath];

    previewingContext.sourceRect = cell.frame;

    self.previewSchedule = [CRTestFunction scheduleFromNSArray:self.testData[indexPath.section][indexPath.row]];
    self.previewIndexPath = indexPath;
    
    return ({
        CRClassScheduleAddViewController *VC = [CRClassScheduleAddViewController new];
        VC.previewActionHandler = self;
        VC.classSchedule = self.previewSchedule;
        VC.title = @"Edit class";
        VC.isPreview = YES;
        VC;
    });
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
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.alpha = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [CRSettings appFontOfSize:27 weight:UIFontWeightRegular];
        [label makeShadowWithSize:CGSizeMake(0, 1) opacity:0.27 radius:1];
        label;
    });
    
    [self.view addAutolayoutSubviews:@[ self.park ]];
    [self.park addSubview:self.titleLabel];
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
        [button.titleLabel makeShadowWithSize:CGSizeMake(0, 1) opacity:0.3f radius:0.3];
        [button makeShadowWithSize:CGSizeMake(0.0f, 1.7f) opacity:0.3f radius:1.7f];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:[UIFont mdiPlus] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(CRClassAddViewController) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    self.actionButtonAccount = ({
        UIButton *button = [UIButton new];
        button.layer.cornerRadius = 56 / 2.0f;
        button.titleLabel.font = [CRSettings appFontOfSize:25 weight:UIFontWeightRegular];
        button.backgroundColor = [UIColor CRColorType:CRColorTypeGoogleYellow];
        [button.titleLabel makeShadowWithSize:CGSizeMake(0, 1) opacity:0.3f radius:0.3];
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

- (void)makeLoading{
    self.loadingView = ({
        GoogleInboxLoadingView *loading = [GoogleInboxLoadingView new];
        loading.translatesAutoresizingMaskIntoConstraints = NO;
        loading;
    });
    [self.view addSubview:self.loadingView];
    
    [CRLayout view:@[ self.loadingView, self.view ] type:CREdgeBottomLeftRight];
    [CRLayout view:@[ self.loadingView ] type:CRFixedHeight constants:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self.loadingView layoutIfNeeded];
}

- (void)doBear{
    self.bear = ({
        UITableView *bear = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        bear.translatesAutoresizingMaskIntoConstraints = NO;
        bear.sectionHeaderHeight = 142.0f;
        bear.sectionFooterHeight = 0;
        bear.contentInset = UIEdgeInsetsMake(STATUS_BAR_HEIGHT, 0, 0, 0);
        bear.contentOffset = CGPointMake(0, - STATUS_BAR_HEIGHT);
        bear.showsHorizontalScrollIndicator = NO;
        bear.showsVerticalScrollIndicator = NO;
        bear.backgroundColor = [UIColor clearColor];
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
    
    UIView *borderTop;
    UIView *borderBottom;
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
            weekday.textColor = [UIColor whiteColor];
            weekday.backgroundColor = [UIColor clearColor];
            weekday.font = [CRSettings appFontOfSize:25 weight:UIFontWeightRegular];
            weekday;
        });
        
        if( fox != 0 )
            borderTop = ({
                UIView *border = [UIView new];
                border.translatesAutoresizingMaskIntoConstraints = NO;
                border.backgroundColor = [UIColor whiteColor];
                border;
            });
        
        borderBottom = ({
            UIView *border = [UIView new];
            border.backgroundColor = [UIColor whiteColor];
            border;
        });
        
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"M%d.jpg", fox + 5]]];
        
        [wrapper addAutolayoutSubviews:@[ imageView, weekday, borderBottom ]];
        
        [CRLayout view:@[ weekday, wrapper ] type:CREdgeAround constants:UIEdgeInsetsMake(8, 56, -78, -56)];
        [CRLayout view:@[ imageView, wrapper ] type:CREdgeLeftRight];
        [CRLayout view:@[ borderBottom, wrapper ] type:CREdgeBottomLeftRight constants:UIEdgeInsetsMake(0, 0, 8, 0)];
        [CRLayout view:@[ borderBottom ] type:CRFixedHeight constants:UIEdgeInsetsMake(0, 16, 0, 0)];
        
        if( borderTop ){
            [wrapper addSubview:borderTop];
            [CRLayout view:@[ borderTop, wrapper ] type:CREdgeTopLeftRight constants:UIEdgeInsetsMake(-8, 0, 0, 0)];
            [CRLayout view:@[ borderTop ] type:CRFixedHeight constants:UIEdgeInsetsMake(0, 16, 0, 0)];
        }
        
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

- (void)layoutHeaderView:(BOOL)layoutIfNeed{
    __block UIView *view;
    [self.shouldRelayoutGuide enumerateObjectsUsingBlock:^(id obj, NSUInteger i, BOOL *sS){
        NSLayoutConstraint *con = (NSLayoutConstraint *)obj;
        con.constant = ({
            view = self.headerViews[[con.identifier integerValue]];
            CGFloat fuck = view.frame.origin.y - self.view.frame.size.height - self.bear.contentOffset.y;
            fuck / 4;
        });
    }];
    
    if( layoutIfNeed )
        [self.bear layoutIfNeeded];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.testData[section] count] == 0 ? 1 : [self.testData[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 158.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if( section == 6 )
        return 8.0f;
    
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if( section != 6 )
        return ({ [UIView new]; });
    
    return ({
        UIView *footer = [UIView new];
        footer.backgroundColor = [UIColor whiteColor];
        footer;
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUInteger numberOfRowInSection = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    if( self.timeLineIndexSection == indexPath.section && self.timeLineIndexRow == indexPath.row )
        return 20.0f + 20.0f;
    
    if( [self.testData[indexPath.section] count] == 1 )
        return 56.0f + 20.0f;
    
    if( numberOfRowInSection == 1 )
        return 36.0f + 20.0f;
    
    return 56.0f + 20.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerViews[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CRClassTableViewCell *CRCell;
    
    if( [self.testData[indexPath.section] count] == 0 ){
        
        CRCell = [tableView dequeueReusableCellWithIdentifier:CRClassCellNoClassID];
        return CRCell ? CRCell : [[CRClassTableViewCell alloc] initFromNoClass];
    }
    
    CRClassSchedule *schedule = [CRTestFunction scheduleFromNSArray:self.testData[indexPath.section][indexPath.row]];
    
    if( [schedule.scheduleID isEqualToString:TIME_LINE_NOW] ){
        CRCell = [tableView dequeueReusableCellWithIdentifier:CRClassCellMomentID];
        return CRCell ?
        ({
            [CRCell setMomentColor:self.themeColor];
            CRCell;
        })
        :
        ({
            [[CRClassTableViewCell alloc] initFromMomentWithColor:self.themeColor];
        });
    }
    
    CRCell = [tableView dequeueReusableCellWithIdentifier:CRClassCellDefaultID];
    if( !CRCell ){
        CRCell = [[CRClassTableViewCell alloc] initFromDefault];
    }
    
    CRCell = ({
        CRCell = [tableView dequeueReusableCellWithIdentifier:CRClassCellDefaultID];
        if( !CRCell )
            CRCell = [[CRClassTableViewCell alloc] initFromDefault];
        
        CRCell.wrapper.backgroundColor = [CRSettings CRAppColorTypes][[schedule.colorType lowercaseString]];
        CRCell.startTime.text = schedule.timeStart;
        CRCell.startTime.textColor = CRCell.wrapper.backgroundColor;
        CRCell.className.text = [schedule.classname isEqualToString:@"Class name"] ? @"No class Name" : schedule.classname;
        CRCell.location.text = [schedule.location isEqualToString:@"Location"] ? @"Unknow classroom" : schedule.location;
        CRCell;
    });
    
    return CRCell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint scrollPoint = scrollView.contentOffset;
    
    CGFloat scale;
    if( scrollPoint.y < -20 ){
        CGFloat offset = fabs(scrollPoint.y);
        CGFloat alpha = (offset - 56) / 56.0;
        if( alpha <= 1 && alpha >= 0 ) self.titleLabel.alpha = alpha;
        if( alpha >  1 && self.titleLabel.alpha != 1 ) self.titleLabel.alpha = 1;
        scale = alpha;
        self.parkLayoutGuide.constant = offset;
    }else{
        self.titleLabel.alpha = scale = 0;
        self.parkLayoutGuide.constant = STATUS_BAR_HEIGHT;
    }

    [self layoutHeaderView:NO];
    
    [self.view layoutIfNeeded];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    [self.shouldRelayoutGuide addObject:self.headerViewsLayoutGuide[section]];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section{
    [self.shouldRelayoutGuide removeObject:self.headerViewsLayoutGuide[section]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BOOL makeAnimation = NO;
    
    if( [self.testData[indexPath.section] count] == 0 ) makeAnimation = YES;
    if( indexPath.section == self.timeLineIndexSection && indexPath.row == self.timeLineIndexRow ) makeAnimation = YES;
    
    if( makeAnimation ){
        [self animationFloatingButton:self.actionButton];
        return;
    }
    
    CRClassSchedule *schedule = [CRTestFunction scheduleFromNSArray:self.testData[indexPath.section][indexPath.row]];
    
    CRClassScheduleAddViewController *CRClassScheduleAddVC = ({
        CRClassScheduleAddViewController *VC = [CRClassScheduleAddViewController new];
        VC.title = @"Edit class";
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
    
    [self presentViewController:({
        CRClassScheduleAddViewController *vc = [CRClassScheduleAddViewController new];
        vc.title = @"New class";
        vc.type = 1;
        vc.classSchedule = schedule;
        vc;
    }) animated:YES completion:nil];
}

- (void)CRAccountsViewController{

    [self presentViewController:({
        
        [CRAccountsViewController new];
        
    }) animated:YES completion:nil];
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
