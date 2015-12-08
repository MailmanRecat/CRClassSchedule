//
//  CRClassViewController.m
//  CRClassSchedule
//
//  Created by caine on 12/6/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height

#import "CRClassViewController.h"
#import "UIView+MOREShadow.h"
#import "UIView+MOREStackLayoutView.h"
#import "UIView+CRLayout.h"
#import "HuskyButton.h"
#import "UIColor+CRColor.h"
#import "UIFont+MaterialDesignIcons.h"

#import "CRFuckCell.h"

@interface CRClassViewController ()<UITableViewDataSource, UITableViewDelegate>

@property( nonatomic, strong ) NSMutableArray *cons;

@property( nonatomic, strong ) UITableView *bear;

@property( nonatomic, strong ) NSArray *icons;

@end

@implementation CRClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    self.cons = [NSMutableArray new];
    
    self.icons = @[
                   [UIFont mdiBell],
                   [UIFont mdiMapMarker],
                   [UIFont mdiAccount],
                   [UIFont mdiCalendar],
                   [UIFont mdiClock],
                   [UIFont mdiPencil]
                   ];
    
    [self makeBear];
}

- (void)makeBear{
    self.bear = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    [self.view addAutolayoutSubviews:@[ self.bear ]];
    [self.view addConstraints:[CRLayoutCons Layout:@[ self.bear, self.view ] :CREAround]];
    
    _bear.sectionFooterHeight = 0;
    _bear.contentInset = UIEdgeInsetsMake(STATUS_BAR_HEIGHT + 56 + 72 + 20, 0, 0, 0);
    _bear.contentOffset = CGPointMake(0, - 0 - STATUS_BAR_HEIGHT);
    _bear.showsHorizontalScrollIndicator = NO;
    _bear.showsVerticalScrollIndicator = NO;
    _bear.backgroundColor = [UIColor whiteColor];
    _bear.separatorStyle = UITableViewCellSeparatorStyleNone;
    _bear.delegate = self;
    _bear.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.icons count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CRFuckCell *cell = [tableView dequeueReusableCellWithIdentifier:CRFuckCellID];
    if( !cell ){
        cell = [[CRFuckCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CRFuckCellID];
    }
    
    cell.icon.text = self.icons[indexPath.row];
    
    if( indexPath.row == 0 )
        cell.nameLabel.text = self.classSchedule.timeStart;
    else if( indexPath.row == 1 )
        cell.nameLabel.text = self.classSchedule.location;
    else if( indexPath.row == 2 )
        cell.nameLabel.text = self.classSchedule.teacher;
    else if( indexPath.row == 3 )
        cell.nameLabel.text = self.classSchedule.weekday;
    else if( indexPath.row == 4 )
        cell.nameLabel.text = self.classSchedule.timeLong;
    else if( indexPath.row == 5 )
        cell.nameLabel.text = self.classSchedule.userInfo;
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
