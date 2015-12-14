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
#import "CRLanguage.h"
#import "HuskyButton.h"
#import "UIColor+CRColor.h"
#import "CRTimeOptionItem.h"
#import "TimeTalkerBird.h"

@interface CRTimeOptionViewController ()<UITableViewDataSource, UITableViewDelegate>

@property( nonatomic, strong ) UIView *park;
@property( nonatomic, strong ) UIButton *dismissButton;
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
    if( self.type == CRTimeOptionTypeLanguage )
        [self.bear selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.lang inSection:0]
                               animated:NO
                         scrollPosition:UITableViewScrollPositionNone];
    
    if( self.themeColor )
        self.park.backgroundColor = self.themeColor;
}

- (void)checkOptionString{
    
    self.weeknames = @[ @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday" ];
    
    if( self.type == CRTimeOptionTypeClassmins ){
        self.optionString = self.option.text = [self classminsWithIndexPath:[NSIndexPath indexPathForRow:self.mins inSection:0]];
        self.optionName.text = @"Minutes";
        
    }else if( self.type == CRTimeOptionTypeWeekday ){
        self.optionString = self.option.text = self.weekday ? self.weeknames[self.weekday - 1] : [CRSettings weekday];
        self.optionName.text = @"weekday";
        
    }else if( self.type == CRTimeOptionTypeLanguage ){
        self.optionName.text = @"Language";
        NSString *lang = [CRLanguage currentLanguage];
        if( lang == CRLanguageEN ){
            self.lang = 0;
            self.optionString = CRLanguageEN;
            self.option.text = @"English";
        }else{
            self.lang = 1;
            self.optionString = CRLanguageCN;
            self.option.text = @"Chinese";
        }
    }
}

- (void)parkSunset{
    self.park.layer.shadowOpacity = 0.27;
}

- (void)parkSunrise{
    self.park.layer.shadowOpacity = 0;
}

- (void)doPark{
    
    self.park = ({
        UIView *park = [UIView new];
        park.translatesAutoresizingMaskIntoConstraints = NO;
        park.backgroundColor = [UIColor CRColorType:CRColorTypeGoogleMapBlue];
        [park makeShadowWithSize:CGSizeMake(0, 1) opacity:0 radius:1.7];
        park;
    });
    
    self.dismissButton = ({
        UIButton *dismiss = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, 56, 56)];
        dismiss.layer.cornerRadius = 56.0f / 2.0f;
        dismiss.titleLabel.font = [UIFont MaterialDesignIcons];
        [dismiss setTitle:[UIFont mdiArrowLeft] forState:UIControlStateNormal];
        [dismiss setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [dismiss addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
        dismiss;
    });
    
    UILabel *label;
    self.optionName = ({
        label = [UILabel new];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.font = [CRSettings appFontOfSize:25 weight:UIFontWeightRegular];
        label.textColor = [UIColor whiteColor];
        label;
    });
    
    self.option = ({
        label = [UILabel new];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.font = [CRSettings appFontOfSize:29 weight:UIFontWeightRegular];
        label.textColor = self.optionName.textColor;
        label;
    });
    
    [self.view addSubview:self.park];
    [self.park addSubview:self.dismissButton];
    [self.park addSubview:self.optionName];
    [self.park addSubview:self.option];
    
    [CRLayout view:@[ self.park, self.view ] type:CREdgeTopLeftRight constants:UIEdgeInsetsMake(0, 0, 0, 0)];
    [CRLayout view:@[ self.park ] type:CRFixedHeight constants:UIEdgeInsetsMake(0, 56 + 72 + STATUS_BAR_HEIGHT, 0, 0)];
    
    [CRLayout view:@[ self.optionName, self.park ] type:CREdgeAround constants:UIEdgeInsetsMake(STATUS_BAR_HEIGHT, 64, -72, -8)];
    [CRLayout view:@[ self.option, self.park ] type:CREdgeAround constants:UIEdgeInsetsMake(STATUS_BAR_HEIGHT + 56, 64, 0, -8)];
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
    if( self.type == CRTimeOptionTypeLanguage )
        return 2;
    
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
    
    if( self.type == CRTimeOptionTypeClassmins )
        cell.timeLabel.text = [self classminsWithIndexPath:indexPath];
    if( self.type == CRTimeOptionTypeWeekday )
        cell.timeLabel.text = self.weeknames[indexPath.row];
    if( self.type == CRTimeOptionTypeLanguage ){
        if( indexPath.row == 0 )
            cell.timeLabel.text = @"English";
        else
            cell.timeLabel.text = @"Chinese";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if( self.type == CRTimeOptionTypeClassmins )
        self.option.text = self.optionString = [self classminsWithIndexPath:indexPath];
    if( self.type == CRTimeOptionTypeWeekday )
        self.option.text = self.optionString = self.weeknames[indexPath.row];
    if( self.type == CRTimeOptionTypeLanguage ){
        if( indexPath.row == 0 ){
            self.optionString = CRLanguageEN;
            self.option.text = @"English";
        }else{
            self.optionString = CRLanguageCN;
            self.option.text = @"Chinese";
        }
    }
        
    
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
