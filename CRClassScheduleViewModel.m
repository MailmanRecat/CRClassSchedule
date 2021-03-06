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

- (void)viewWillAppear:(BOOL)animated{
    self.park.backgroundColor = [CRSettings CRAppColorTypes][[self.classSchedule.colorType lowercaseString]];
    self.parkTitle.text = [self.classSchedule.classname isEqualToString:@"Class name"] ? @"No class name" : self.classSchedule.classname;
    if( !animated )
        [self.bear reloadData];
}

- (void)parkSunset{
    self.park.layer.shadowOpacity = 0.27;
}

- (void)parkSunrise{
    self.park.layer.shadowOpacity = 0;
}

- (void)makePark{
    
    self.park = ({
        UIView *park = [UIView new];
        park.translatesAutoresizingMaskIntoConstraints = NO;
        [park makeShadowWithSize:CGSizeMake(0, 1) opacity:0 radius:1.7];
        park;
    });
    
    self.parkTitle = ({
        UILabel *parkTitle = [UILabel new];
        parkTitle.translatesAutoresizingMaskIntoConstraints = NO;
        parkTitle.textColor = [UIColor whiteColor];
        parkTitle.font = [CRSettings appFontOfSize:37 weight:UIFontWeightRegular];
        parkTitle.adjustsFontSizeToFitWidth = YES;
        parkTitle.numberOfLines = 0;
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
    [CRLayout view:@[ self.parkTitle, self.park ] type:CREdgeBottomLeftRight constants:UIEdgeInsetsMake(0, 72, -4, -8)];
    
    [self.parkTitle.heightAnchor constraintGreaterThanOrEqualToConstant:72].active = YES;
    [self.parkTitle.heightAnchor constraintLessThanOrEqualToConstant:56 + 72 - 4].active = YES;
}

- (void)makeBear{
    self.bear = ({
        UITableView *bear = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        bear.translatesAutoresizingMaskIntoConstraints = NO;
        bear.sectionFooterHeight = 0;
        bear.contentInset = UIEdgeInsetsMake(STATUS_BAR_HEIGHT + 56 + 72 + 16, 0, 52, 0);
        bear.contentOffset = CGPointMake(0, - 56 - 72 - 16 - STATUS_BAR_HEIGHT);
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if( scrollView.contentOffset.y > -148 )
        [self parkSunset];
    else
        [self parkSunrise];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.icons count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if( indexPath.row == 5 )
        return 256.0f;
    
    return 68.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CRFuckCell *cell;
    if( indexPath.row == 5 ){
        cell = [tableView dequeueReusableCellWithIdentifier:CRFuckCellNoteID];
        if( !cell ){
            cell = [[CRFuckCell alloc] initNoteType];
            cell.subLabel.font = [CRSettings appFontOfSize:15 weight:UIFontWeightRegular];
            cell.nameText.font = [CRSettings appFontOfSize:19 weight:UIFontWeightRegular];
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:CRFuckCellID];
        if( !cell ){
            cell = [[CRFuckCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CRFuckCellID];
            cell.subLabel.font = [CRSettings appFontOfSize:15 weight:UIFontWeightRegular];
            cell.nameLabel.font = [CRSettings appFontOfSize:19 weight:UIFontWeightRegular];
        }
    }
    
    cell.icon.text = self.icons[indexPath.row];
    
    if( indexPath.row == 0 ){
        cell.subLabel.text = @"When";
        cell.nameLabel.text = self.classSchedule.timeStart;
    }else if( indexPath.row == 1 ){
        cell.subLabel.text = @"Where";
        cell.nameLabel.text = [self.classSchedule.location isEqualToString:@"Location"] ? @"Unknow classroom" : self.classSchedule.location;
    }else if( indexPath.row == 2 ){
        cell.subLabel.text = @"Who";
        cell.nameLabel.text = [self.classSchedule.teacher isEqualToString:@"Teacher"] ? @"Unknow teacher" : self.classSchedule.teacher;
    }else if( indexPath.row == 3 ){
        cell.subLabel.text = @"Weekday";
        cell.nameLabel.text = self.classSchedule.weekday;
    }else if( indexPath.row == 4 ){
        cell.subLabel.text = @"How long";
        cell.nameLabel.text = self.classSchedule.timeLong;
    }else if( indexPath.row == 5 ){
        cell.subLabel.text = @"Note";
        cell.nameText.text = self.classSchedule.userInfo;
    }
    
    return cell;
}

- (void)dismissSelf{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
