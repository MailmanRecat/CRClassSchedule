//
//  CRTimeOptionsViewController.m
//  CRClassSchedule
//
//  Created by caine on 12/1/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height

#import "CRTimeOptionsViewController.h"
#import "UIView+MOREShadow.h"
#import "UIView+MOREStackLayoutView.h"
#import "UIFont+MaterialDesignIcons.h"
#import "UIColor+Theme.h"
#import "CRSettings.h"
#import "HuskyButton.h"
#import "UIColor+CRColor.h"
#import "CRTimeOptionItem.h"

@interface CRTimeOptionsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property( nonatomic, strong ) UIView *park;
@property( nonatomic, strong ) UILabel *optionName;
@property( nonatomic, strong ) UILabel *option;

@property( nonatomic, strong ) UIView *bottomPark;
@property( nonatomic, strong ) UIButton *bottomLeftButton;

@property( nonatomic, strong ) NSString *timeString;
@property( nonatomic, assign ) NSUInteger hour;
@property( nonatomic, assign ) NSUInteger min;
@property( nonatomic, strong ) UITableView *houTable;
@property( nonatomic, strong ) UITableView *minTable;
@property( nonatomic, strong ) NSLayoutConstraint *swipeConstraint;

@end

@implementation CRTimeOptionsViewController

+ (instancetype)shareTimeOptions{
    static CRTimeOptionsViewController *timeOptions = nil;
    if( timeOptions ) return timeOptions;
    
    static dispatch_once_t t_tiemOptionsMaker;
    dispatch_once(&t_tiemOptionsMaker, ^{
        timeOptions = [CRTimeOptionsViewController new];
    });
    
    return timeOptions;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self doBear];
    [self doPark];
    [self doButton];
}

- (void)viewWillAppear:(BOOL)animated{
    self.timeString = self.curTimeString;
    self.option.text = self.curTimeString;
    self.hour = [[self.curTimeString substringWithRange:NSMakeRange(0, 2)] integerValue];
    self.min = [[self.curTimeString substringWithRange:NSMakeRange(3, 2)] integerValue];
    [self.houTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.hour inSection:0]
                               animated:NO
                         scrollPosition:UITableViewScrollPositionTop];
    [self.minTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.min / 5 inSection:0]
                               animated:NO
                         scrollPosition:UITableViewScrollPositionTop];
    
    if( self.themeColor )
        self.park.backgroundColor = self.themeColor;
}

- (void)parkSunset{
    self.park.layer.shadowOpacity = 0.27;
}

- (void)parkSunrise{
    self.park.layer.shadowOpacity = 0;
}

- (void)swipeToMinTable{
    self.bottomLeftButton.enabled = YES;
    self.optionName.text = @"Minute";
    self.swipeConstraint.constant = -self.view.frame.size.width;
    [UIView animateWithDuration:0.37
                     animations:^{
                         self.houTable.alpha = 0;
                         self.minTable.alpha = 1;
                         [self.view layoutIfNeeded];
                     }];
}

- (void)swipeToHouTable{
    self.bottomLeftButton.enabled = NO;
    self.optionName.text = @"Hour";
    self.swipeConstraint.constant = 0;
    [UIView animateWithDuration:0.37
                     animations:^{
                         self.houTable.alpha = 1;
                         self.minTable.alpha = 0;
                         [self.view layoutIfNeeded];
                     }];
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
    
    self.optionName.text = @"Hour";
    self.optionName.font = [CRSettings appFontOfSize:25 weight:UIFontWeightRegular];
    self.optionName.textColor = [UIColor whiteColor];
    
    self.option.font = [CRSettings appFontOfSize:29 weight:UIFontWeightRegular];
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
    UIButton *right = [UIButton new];
    UIButton *left = [UIButton new];
    UIView *border = [UIView new];
    [self.view addAutolayoutSubviews:@[ self.bottomPark ]];
    [self.bottomPark addAutolayoutSubviews:@[ right, left, border ]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.bottomPark to:self.view type:EdgeBottomLeftRightZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.bottomPark type:SpactecledBearFixedHeight constant:52]];
    [self.view addConstraints:cons];
    [cons removeAllObjects];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:right to:self.bottomPark type:EdgeTopRightBottomZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:left to:self.bottomPark type:EdgeTopLeftBottomZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint spactecledTwoBearFixed:right anotherBear:self.bottomPark
                                                                    type:SpactecledBearFixedWidth multiplier:0.5 constant:0]];
    [cons addObjectsFromArray:[NSLayoutConstraint spactecledTwoBearFixed:left anotherBear:self.bottomPark
                                                                    type:SpactecledBearFixedWidth multiplier:0.5 constant:0]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:border to:self.bottomPark type:EdgeTopBottomZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:border to:self.bottomPark type:EdgeCenterX]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:border type:SpactecledBearFixedWidth constant:1]];
    [self.bottomPark addConstraints:cons];
    [cons removeAllObjects];
    
    [self.bottomPark makeShadowWithSize:CGSizeMake(0, -1) opacity:0.17 radius:1.7];
    self.bottomPark.backgroundColor = [UIColor whiteColor];
    
    border.backgroundColor = [UIColor colorWithWhite:217 / 255.0 alpha:1];
    
    [right setTitleColor:[UIColor CRColorType:CRColorTypeGoogleMapBlue] forState:UIControlStateNormal];
    right.titleLabel.font = left.titleLabel.font = [CRSettings appFontOfSize:17 weight:UIFontWeightRegular];
    [right setTitle:@"OK" forState:UIControlStateNormal];
    [right addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    [left setTitleColor:[UIColor colorWithWhite:127 / 255.0 alpha:1] forState:UIControlStateNormal];
    [left setTitleColor:[UIColor colorWithWhite:127 / 255.0 alpha:0.3] forState:UIControlStateDisabled];
    [left setTitle:@"Back" forState:UIControlStateNormal];
    [left addTarget:self action:@selector(swipeToHouTable) forControlEvents:UIControlEventTouchUpInside];
    left.enabled = NO;
    
    self.bottomLeftButton = left;
}

- (void)doBear{
    NSMutableArray *cons = [NSMutableArray new];
    self.houTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    self.minTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    [self.view addAutolayoutSubviews:@[ self.houTable, self.minTable ]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.houTable to:self.view type:EdgeTopBottomZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.minTable to:self.view type:EdgeTopBottomZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint spactecledTwoBearFixed:self.houTable anotherBear:self.view type:SpactecledBearFixedEqual]];
    [cons addObjectsFromArray:[NSLayoutConstraint spactecledTwoBearFixed:self.minTable anotherBear:self.view type:SpactecledBearFixedEqual]];
    [cons addObject:[NSLayoutConstraint constraintWithItem:self.houTable
                                                 attribute:NSLayoutAttributeRight
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:self.minTable
                                                 attribute:NSLayoutAttributeLeft
                                                multiplier:1.0
                                                  constant:0]];
    self.swipeConstraint = [NSLayoutConstraint constraintWithItem:self.houTable
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0
                                                         constant:0];
    [cons addObject:self.swipeConstraint];
    [self.view addConstraints:cons];
    [cons removeAllObjects];
    
    self.houTable.tag = 1024;
    self.minTable.tag = 1060;
    self.minTable.alpha = 0;
    
    for( UITableView *table in @[ self.houTable, self.minTable ] ){
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.contentInset = UIEdgeInsetsMake(56 + 72 + STATUS_BAR_HEIGHT, 0, 52, 0);
        table.contentOffset = CGPointMake(0, - 56 - 72 - STATUS_BAR_HEIGHT);
        table.showsVerticalScrollIndicator = NO;
        table.delegate = self;
        table.dataSource = self;
    }
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
    if( tableView.tag == 1024 )
        return 24;
    else if( tableView.tag == 1060 )
        return 12;
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CELL_ID = @"CELL_ID";
    CRTimeOptionItem *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    if( !cell ){
        cell = [[CRTimeOptionItem alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_ID];
        cell.timeLabel.font = [CRSettings appFontOfSize:19 weight:UIFontWeightRegular];
        cell.timeLabel.textColor = [UIColor colorWithWhite:127 / 255.0  alpha:1];
    }
    
    NSString *text;
    if( tableView.tag == 1024 ){
        
        text = indexPath.row < 10 ? [NSString stringWithFormat:@"0%ld o'clock", (long)indexPath.row] :
        [NSString stringWithFormat:@"%ld o'clock", (long)indexPath.row];
        
        cell.timeLabel.text = text;
    }else if( tableView.tag == 1060 ){
        text = indexPath.row * 5 < 10 ? [NSString stringWithFormat:@"0%ld minutes", indexPath.row * 5] :
        [NSString stringWithFormat:@"%ld minutes", indexPath.row * 5];
        
        cell.timeLabel.text = text;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if( tableView.tag == 1024 )
        [self swipeToMinTable];
    
    if( tableView.tag == 1024 ){
        self.hour = indexPath.row;
    }else if( tableView.tag == 1060 ){
        self.min = indexPath.row * 5;
    }

    NSString *optionMin, *optionHou;
    optionHou = self.hour < 10 ? [NSString stringWithFormat:@"0%ld", (unsigned long)self.hour] : [NSString stringWithFormat:@"%ld", self.hour];
    optionMin = self.min  < 10 ? [NSString stringWithFormat:@"0%ld", (unsigned long)self.min]  : [NSString stringWithFormat:@"%ld", self.min];
    self.option.text = [NSString stringWithFormat:@"%@:%@", optionHou, optionMin];
    
    self.timeString = self.option.text;
    
    if( tableView.tag == 1060 )
        [self dismissSelf];
}

- (void)dismissSelf{
    [self dismissViewControllerAnimated:YES completion:^{
        if( self.handler && [self.handler respondsToSelector:@selector(CRTimeOptionsVCDidDismissWithOption:)] )
            [self.handler CRTimeOptionsVCDidDismissWithOption:self.timeString];
        
        [self swipeToHouTable];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
