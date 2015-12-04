//
//  CRAccountsViewController.m
//  CRClassSchedule
//
//  Created by caine on 12/1/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height

#import "CRAccountsViewController.h"
#import "UIView+MOREShadow.h"
#import "UIView+MOREStackLayoutView.h"
#import "UIFont+MaterialDesignIcons.h"
#import "CRSettings.h"
#import "CRClassDatabase.h"
#import "UIColor+CRColor.h"

#import "CRAccountsTableViewCell.h"
#import "CRAccountAddViewController.h"
#import "CRInfoViewController.h"

@interface CRAccountsViewController()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property( nonatomic, strong ) NSMutableArray *cons;

@property( nonatomic, strong ) UIView *park;
@property( nonatomic, strong ) UILabel *nameplate;
@property( nonatomic, strong ) UIButton *dismissButton;

@property( nonatomic, strong ) UITableView *bear;

@property( nonatomic, assign ) NSUInteger selectedRow;

@end

@implementation CRAccountsViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.cons = [NSMutableArray new];
    self.selectedRow = 0;
    
    [self doBear];
    [self doPark];
}

- (void)parkSunset{
    self.park.layer.shadowOpacity = 0.27;
}

- (void)parkSunrise{
    self.park.layer.shadowOpacity = 0;
}

- (void)doPark{
    self.park = [UIView new];
    self.dismissButton = [UIButton new];
    self.nameplate = [UILabel new];
    [self.view addAutolayoutSubviews:@[ self.park ]];
    [self.park addAutolayoutSubviews:@[ self.dismissButton, self.nameplate ]];
    [self.cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.park to:self.view type:EdgeTopLeftRightZero]];
    [self.cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.park type:SpactecledBearFixedHeight constant:56 + STATUS_BAR_HEIGHT]];
    [self.view addConstraints:self.cons];
    [self.cons removeAllObjects];
    [self.cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.dismissButton to:self.park type:EdgeBottomLeftZero]];
    [self.cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.dismissButton type:SpactecledBearFixedEqual constant:56]];
    [self.cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.nameplate to:self.park type:EdgeBottomRightZero]];
    [self.cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.nameplate to:self.park type:EdgeTopZero
                                                                 constant:STATUS_BAR_HEIGHT]];
    [self.cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.nameplate to:self.park type:EdgeLeftZero constant:56 + 8]];
    [self.park addConstraints:self.cons];
    [self.cons removeAllObjects];
    
    self.park.backgroundColor = [UIColor whiteColor];
    [self.park makeShadowWithSize:CGSizeMake(0, 1) opacity:0.0f radius:1.7];
    
    self.dismissButton.titleLabel.font = [UIFont MaterialDesignIcons];
    [self.dismissButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.dismissButton setTitle:[UIFont mdiArrowLeft] forState:UIControlStateNormal];
    [self.dismissButton addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    
    self.nameplate.font = [CRSettings appFontOfSize:21];
    self.nameplate.text = @"Select accounts";
}

- (void)doBear{
    _bear = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    [self.view addAutolayoutSubviews:@[ _bear ]];
    [self.view bringSubviewToFront:self.park];
    [self.view addConstraints:[NSLayoutConstraint SpactecledBearEdeg:_bear to:self.view type:EdgeAroundZero]];
    
    _bear.sectionHeaderHeight = 0.0f;
    _bear.sectionFooterHeight = 0.0f;
    _bear.contentInset = UIEdgeInsetsMake(STATUS_BAR_HEIGHT + 56 + 0, 0, 0, 0);
    _bear.contentOffset = CGPointMake(0, - 56 - STATUS_BAR_HEIGHT);
    _bear.showsHorizontalScrollIndicator = NO;
    _bear.showsVerticalScrollIndicator = NO;
    _bear.backgroundColor = [UIColor colorWithWhite:237 / 255.0 alpha:1];
    _bear.separatorStyle = UITableViewCellSeparatorStyleNone;
    _bear.delegate = self;
    _bear.dataSource = self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    if( point.y > -(56 + STATUS_BAR_HEIGHT) ){
        [self parkSunset];
    }else{
        [self parkSunrise];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if( indexPath.row == 4 ) return 52;
    
    return 56.0 + STATUS_BAR_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ACELL_ID = @"ACELL_ID";
    static NSString *BCELL_ID = @"BCELL_ID";
    if( indexPath.row == 4 ){
        UITableViewCell *bcell = [tableView dequeueReusableCellWithIdentifier:BCELL_ID];
        if( !bcell ){
            bcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BCELL_ID];
            bcell.textLabel.textAlignment = NSTextAlignmentRight;
            bcell.textLabel.text = @"APP INFO";
            bcell.textLabel.textColor = [UIColor CRColorType:CRColorTypeGoogleMapBlue];
            bcell.backgroundColor = [UIColor clearColor];
            bcell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return bcell;
    }
    
    CRAccountsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ACELL_ID];
    if( !cell ){
        cell = [[CRAccountsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ACELL_ID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.icon.text = @"C";
    cell.accountName.text = @"craig";
    if( indexPath.row == 0 ) [cell check];
    if( indexPath.row == 3 ){
        [cell makeBorderBottom];
        cell.icon.font = [UIFont MaterialDesignIcons];
        cell.icon.text = [UIFont mdiPlus];
        cell.icon.textColor = [UIColor colorWithWhite:157 / 255.0 alpha:1];
        cell.icon.backgroundColor = [UIColor clearColor];
        cell.accountName.text = @"Add account";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if( indexPath.row == 4 ){
        [self CRInfoViewController];
        return;
    }
    
    if( indexPath.row == 3 ){
        [self CRAccountAddViewController];
        return;
    }
    
    if( indexPath.row == self.selectedRow ) return;
    CRAccountsTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedRow inSection:0]];
    [cell unCheck];
    cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell check];
    self.selectedRow = indexPath.row;
}

- (void)CRAccountAddViewController{
    CRAccountAddViewController *accountAdd = [CRAccountAddViewController new];
    accountAdd.transitioningDelegate = self.transitioningDelegate;
    [self presentViewController:accountAdd animated:YES completion:nil];
}

- (void)CRInfoViewController{
    CRInfoViewController *info = [CRInfoViewController new];
    info.transitioningDelegate = self.transitioningDelegate;
    [self presentViewController:info animated:YES completion:nil];
}

- (void)dismissSelf{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
