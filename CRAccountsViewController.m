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

#import "CRTransitionAnimationObject.h"
#import "CRAccountsTableViewCell.h"
#import "CRAccountAddViewController.h"
#import "CRInfoViewController.h"
#import "CRTextFieldViewController.h"

#import "CRClassAddViewController.h"

@interface CRAccountsViewController()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property( nonatomic, strong ) NSMutableArray *cons;
@property( nonatomic, strong ) CRTransitionAnimationObject *transitionAnimationObject;

@property( nonatomic, strong ) UIView *park;
@property( nonatomic, strong ) UILabel *nameplate;
@property( nonatomic, strong ) UIButton *dismissButton;

@property( nonatomic, strong ) UITableView *bear;

@property( nonatomic, assign ) NSUInteger selectedRow;
@property( nonatomic, strong ) NSArray *accounts;

@end

@implementation CRAccountsViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.cons = [NSMutableArray new];
    self.transitionAnimationObject = [CRTransitionAnimationObject defaultCRTransitionAnimation];
    
    [self doBear];
    [self doPark];
}

- (void)viewWillAppear:(BOOL)animated{
    self.accounts = [CRClassDatabase selectClassAccountFromAll];
    [self.bear reloadData];
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
    if( indexPath.row == [self.accounts count] + 1 ) return 52;
    
    return 56.0 + STATUS_BAR_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.accounts count] + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ACELL_ID = @"ACELL_ID";
    static NSString *BCELL_ID = @"BCELL_ID";
    static NSString *ADDCELL_ID = @"ADDCELL)ID";
    
    if( indexPath.row == [self.accounts count] + 1 ){
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
    CRAccountsTableViewCell *cell;
    
    if( indexPath.row == [self.accounts count] ){
        cell = [tableView dequeueReusableCellWithIdentifier:ADDCELL_ID];
        if( !cell ){
            cell = [[CRAccountsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ADDCELL_ID];
            [cell makeBorderBottom];
            cell.icon.font = [UIFont MaterialDesignIcons];
            cell.icon.text = [UIFont mdiPlus];
            cell.icon.textColor = [UIColor colorWithWhite:157 / 255.0 alpha:1];
            cell.icon.backgroundColor = [UIColor clearColor];
            cell.accountName.text = @"Add account";
        }
        return cell;
    }
    
    CRClassAccount *account = (CRClassAccount *)self.accounts[indexPath.row];

    cell = [tableView dequeueReusableCellWithIdentifier:ACELL_ID];
    if( !cell ){
        cell = [[CRAccountsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ACELL_ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.icon.text = [[account.ID substringToIndex:1] uppercaseString];
    cell.icon.backgroundColor = [CRSettings CRAppColorTypes][[account.colorType lowercaseString]];
    cell.accountName.text = account.ID;
    
    if( [account.current isEqualToString:@"YES"] ){
        [cell makeCheck];
        if( !self.selectedRow ) self.selectedRow = indexPath.row;
    }else{
        [cell makeUnCheck];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if( indexPath.row == [self.accounts count] + 1 )
        dispatch_async(dispatch_get_main_queue(), ^{
            [self CRInfoViewController];
        });
    
    else if( indexPath.row == [self.accounts count] )
        dispatch_async(dispatch_get_main_queue(), ^{
            [self CRAccountAddViewController];
        });
    
    else if( indexPath.row != self.selectedRow ){
        CRClassAccount *account = (CRClassAccount *)self.accounts[indexPath.row];

        CRAccountsTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedRow inSection:0]];
        [cell makeUnCheck];
        cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell makeCheck];
        
        self.selectedRow = indexPath.row;
        [CRClassDatabase changeCRClassAccountCurrent:account];
        self.accounts = [CRClassDatabase selectClassAccountFromAll];
    }
}

- (void)CRTextFieldViewController{
    CRTextFieldViewController *textField = [CRTextFieldViewController new];
    textField.placeholderString = @"name";
    textField.returnKeyType = UIReturnKeyNext;
    textField.transitioningDelegate = self.transitioningDelegate;
    [self presentViewController:textField animated:YES completion:nil];
}

- (void)CRAccountAddViewController{
    CRAccountAddViewController *accountAdd = [CRAccountAddViewController new];
    accountAdd.transitioningDelegate = self.transitionAnimationObject;
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
