//
//  CRClassScheduleViewModel.m
//  CRClassSchedule
//
//  Created by caine on 12/11/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height

#import "CRClassScheduleViewModel.h"
#import "CRSettings.h"
#import "UIColor+CRColor.h"
#import "UIFont+MaterialDesignIcons.h"
#import "UIView+MOREShadow.h"
#import "UIView+MOREStackLayoutView.h"

#import "CRFuckCell.h"

@interface CRClassScheduleViewModel()<UITableViewDelegate, UITableViewDataSource>

@property( nonatomic, strong ) UIView *park;
@property( nonatomic, strong ) UILabel *parkTitle;
@property( nonatomic, strong ) UIButton *dismissButton;

@property( nonatomic, strong ) UITableView *bear;
@property( nonatomic, strong ) NSArray *icons;

@end

@implementation CRClassScheduleViewModel

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor CRColorType:CRColorTypeGoogleTomato];
    self.icons = @[
                   [UIFont mdiBell],
                   [UIFont mdiMapMarker],
                   [UIFont mdiAccount],
                   [UIFont mdiCalendar],
                   [UIFont mdiClock],
                   [UIFont mdiPencil]
                   ];
    [self makeBear];
    [self makePark];
}

- (void)makePark{
    
    self.park = ({
        UIView *park = [UIView new];
        park.translatesAutoresizingMaskIntoConstraints = NO;
        park.backgroundColor = [UIColor CRColorType:CRColorTypeGoogleYellow];
        [park makeShadowWithSize:CGSizeMake(0, 1) opacity:0 radius:1.7];
        park;
    });
    
    self.parkTitle = ({
        UILabel *parkTitle = [UILabel new];
        parkTitle.text = @"New Class";
        parkTitle.translatesAutoresizingMaskIntoConstraints = NO;
        parkTitle.textColor = [UIColor whiteColor];
        parkTitle.font = [CRSettings appFontOfSize:21 weight:UIFontWeightMedium];
        parkTitle;
    });
    
    self.dismissButton = ({
        UIButton *dismiss = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, 56, 56)];
        dismiss.layer.cornerRadius = 56.0f / 2.0f;
        dismiss.titleLabel.font = [UIFont MaterialDesignIcons];
        [dismiss setTitle:[UIFont mdiClose] forState:UIControlStateNormal];
        [dismiss setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [dismiss addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
        dismiss;
    });
    
    [self.view addSubview:self.park];
    [CRLayout view:@[ self.park, self.view ] type:CREdgeTopLeftRight];
    [CRLayout view:@[ self.park ] type:CRFixedHeight constants:UIEdgeInsetsMake(0, STATUS_BAR_HEIGHT + 56 + 72, 0, 0)];
 
    [self.park addSubview:self.dismissButton];
    [self.park addSubview:self.parkTitle];
    [CRLayout view:@[ self.parkTitle, self.park ] type:CREdgeAround constants:UIEdgeInsetsMake(STATUS_BAR_HEIGHT + 56, 72, 0, -16)];
}

- (void)makeBear{
    self.bear = ({
        UITableView *bear = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        bear.translatesAutoresizingMaskIntoConstraints = NO;
        bear.sectionFooterHeight = 0;
        bear.contentInset = UIEdgeInsetsMake(STATUS_BAR_HEIGHT + 56 + 72, 0, 0, 0);
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

- (void)dismissSelf{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
