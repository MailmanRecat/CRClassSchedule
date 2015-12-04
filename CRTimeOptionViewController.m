//
//  CRTimeOptionViewController.m
//  CRClassSchedule
//
//  Created by caine on 12/2/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height

#import "CRTimeOptionViewController.h"
#import "UIView+MOREShadow.h"
#import "UIView+MOREStackLayoutView.h"
#import "UIFont+MaterialDesignIcons.h"
#import "UIColor+Theme.h"
#import "CRSettings.h"
#import "HuskyButton.h"
#import "UIColor+CRColor.h"
#import "CRTimeOptionItem.h"
#import "TimeTalkerBird.h"

@interface CRTimeOptionViewController ()<UITableViewDataSource, UITableViewDelegate>

@property( nonatomic, strong ) UIView *park;
@property( nonatomic, strong ) UILabel *optionName;
@property( nonatomic, strong ) UILabel *option;

@property( nonatomic, strong ) UITableView *bear;

@property( nonatomic, strong ) UIView *bottomPark;

@property( nonatomic, strong ) NSArray *weeknames;
@property( nonatomic, strong ) NSString *optionString;

@end

@implementation CRTimeOptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self doBear];
    [self doPark];
//    [self doButton];
    [self checkOptionString];
}

- (void)viewWillAppear:(BOOL)animated{
    if( self.type == CRTimeOptionTypeWeekday )
        [self.bear selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.weekday ? self.weekday - 1 : [TimeTalkerBird currentDate].weekday - 1
                                                           inSection:0]
                               animated:NO
                         scrollPosition:UITableViewScrollPositionNone];
    if( self.type == CRTimeOptionTypeClassmins )
        [self.bear selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.mins inSection:0]
                               animated:NO
                         scrollPosition:UITableViewScrollPositionTop];
}

- (void)checkOptionString{
    
    self.weeknames = @[ @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday" ];
    
    if( self.type == CRTimeOptionTypeClassmins ){
        self.optionString = self.option.text = [self classminsWithIndexPath:[NSIndexPath indexPathForRow:self.mins inSection:0]];
        self.optionName.text = @"Minutes";
    }else if( self.type == CRTimeOptionTypeWeekday ){
        self.optionString = self.option.text = self.weekday ? self.weeknames[self.weekday - 1] : [CRSettings weekday];
        self.optionName.text = @"weekday";
    }
}

- (void)parkSunset{
    self.park.layer.shadowOpacity = 0.27;
}

- (void)parkSunrise{
    self.park.layer.shadowOpacity = 0;
}

- (void)doPark{
    NSMutableArray *cons = [NSMutableArray new];
    self.park = [UIView new];
    self.optionName = [UILabel new];
    self.option = [UILabel new];
    HuskyButton *backButton = [HuskyButton new];
    [self.view addAutolayoutSubviews:@[ self.park ]];
    [self.park addAutolayoutSubviews:@[ backButton, self.optionName, self.option ]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.park to:self.view type:EdgeTopLeftRightZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.park type:SpactecledBearFixedHeight
                                                             constant:56 + 72 + STATUS_BAR_HEIGHT]];
    [self.view addConstraints:cons];
    [cons removeAllObjects];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.optionName to:self.park type:EdgeTopZero constant:STATUS_BAR_HEIGHT]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.optionName to:self.park type:EdgeRightZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.optionName type:SpactecledBearFixedHeight constant:56]];
    [cons addObject:[NSLayoutConstraint constraintWithItem:backButton
                                                 attribute:NSLayoutAttributeRight
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:self.optionName
                                                 attribute:NSLayoutAttributeLeft
                                                multiplier:1.0
                                                  constant:-8]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.option to:self.park type:EdgeLeftRightZero constant:56 + 8]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.option to:self.park type:EdgeBottomZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.option type:SpactecledBearFixedHeight constant:72]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:backButton to:self.park type:EdgeLeftZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:backButton to:self.park type:EdgeTopZero
                                                            constant:STATUS_BAR_HEIGHT]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:backButton type:SpactecledBearFixedEqual constant:56]];
    [self.park addConstraints:cons];
    [cons removeAllObjects];
    
    self.park.backgroundColor = [UIColor CRColorType:CRColorTypeGoogleMapBlue];
    [self.park makeShadowWithSize:CGSizeMake(0, 1) opacity:0 radius:1.7];
    
    self.optionName.font = [CRSettings appFontOfSize:25];
    self.optionName.textColor = [UIColor whiteColor];
    
    self.option.font = [CRSettings appFontOfSize:29];
    self.option.textColor = [UIColor whiteColor];
    
    backButton.layer.cornerRadius = 56.0f / 2.0f;
    backButton.titleLabel.font = [UIFont MaterialDesignIcons];
    [backButton setTitle:[UIFont mdiArrowLeft] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
}

- (void)doButton{
    NSMutableArray *cons = [NSMutableArray new];
    self.bottomPark = [UIView new];
    UIButton *confirm = [UIButton new];
    [self.view addAutolayoutSubviews:@[ self.bottomPark ]];
    [self.bottomPark addAutolayoutSubviews:@[ confirm ]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.bottomPark to:self.view type:EdgeBottomLeftRightZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.bottomPark type:SpactecledBearFixedHeight constant:52]];
    [self.view addConstraints:cons];
    [cons removeAllObjects];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:confirm to:self.bottomPark type:EdgeAroundZero]];
    [self.bottomPark addConstraints:cons];
    [cons removeAllObjects];
    
    [self.bottomPark makeShadowWithSize:CGSizeMake(0, -1) opacity:0.17 radius:1.7];
    self.bottomPark.backgroundColor = [UIColor whiteColor];
    
    [confirm setTitleColor:[UIColor CRColorType:CRColorTypeGoogleMapBlue] forState:UIControlStateNormal];
    [confirm setTitle:@"OK" forState:UIControlStateNormal];
    [confirm addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
}

- (void)doBear{
    NSMutableArray *cons = [NSMutableArray new];
    self.bear = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    [self.view addAutolayoutSubviews:@[ self.bear ]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.bear to:self.view type:EdgeAroundZero]];
    [self.view addConstraints:cons];
    [cons removeAllObjects];
    
    self.bear.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.bear.contentInset = UIEdgeInsetsMake(56 + 72 + STATUS_BAR_HEIGHT, 0, 0, 0);
    self.bear.contentOffset = CGPointMake(0, -(56 + 72 + STATUS_BAR_HEIGHT));
    self.bear.showsVerticalScrollIndicator = NO;
    self.bear.delegate = self;
    self.bear.dataSource = self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    if( point.y > -(56 + 72 + STATUS_BAR_HEIGHT) ){
        [self parkSunset];
    }else{
        [self parkSunrise];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if( self.type == CRTimeOptionTypeClassmins )
        return 20;
    if( self.type == CRTimeOptionTypeWeekday )
        return 7;
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CELL_ID = @"CELL_ID";
    CRTimeOptionItem *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    if( !cell ){
        cell = [[CRTimeOptionItem alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_ID];
    }
    
    cell.timeLabel.font = [CRSettings appFontOfSize:19];
    cell.timeLabel.textColor = [UIColor colorWithWhite:127 / 255.0  alpha:1];
    
    if( self.type == CRTimeOptionTypeClassmins )
        cell.timeLabel.text = [self classminsWithIndexPath:indexPath];
    if( self.type == CRTimeOptionTypeWeekday )
        cell.timeLabel.text = self.weeknames[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if( self.type == CRTimeOptionTypeClassmins )
        self.option.text = self.optionString = [self classminsWithIndexPath:indexPath];
    if( self.type == CRTimeOptionTypeWeekday )
        self.option.text = self.optionString = self.weeknames[indexPath.row];
    
    [self dismissSelf];
}

- (NSString *)classminsWithIndexPath:(NSIndexPath *)indexPath{
    NSString *text;
    if( indexPath.row < 11 )
        text = [NSString stringWithFormat:@"%ld mins", (indexPath.row + 1) * 5];
    if( indexPath.row == 11 )
        text = [NSString stringWithFormat:@"1 hour"];
    if( indexPath.row < 17 && indexPath.row >= 12  )
        text = [NSString stringWithFormat:@"1 hour %ld mins", (indexPath.row - 11) * 10];
    if( indexPath.row == 17 )
        text = [NSString stringWithFormat:@"2 hours"];
    if( indexPath.row < 19 && indexPath.row > 17 )
        text = [NSString stringWithFormat:@"2 hours %ld mins", (indexPath.row - 17) * 30];
    if( indexPath.row == 19 )
        text = [NSString stringWithFormat:@"3 hours"];
    
    return text;
}

- (void)dismissSelf{
    [self dismissViewControllerAnimated:YES completion:^{
        if( self.handler && [self.handler respondsToSelector:@selector(CRTimeOptionVCDidDismissWithType:option:)] )
            [self.handler CRTimeOptionVCDidDismissWithType:self.type option:self.optionString];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
