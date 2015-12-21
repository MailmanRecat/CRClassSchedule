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
#import "CRClassCurrent.h"
#import "UIColor+CRColor.h"

#import "CRTransitionAnimationObject.h"
#import "CRAccountsTableViewCell.h"
#import "CRAccountAddViewController.h"
#import "CRInfoViewController.h"
#import "CRTextFieldViewController.h"
#import "UIWindow+CRAction.h"
#import "CRDebugViewController.h"

@interface CRAccountsViewController()<CRActionHandler, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property( nonatomic, strong ) NSMutableArray *cons;
@property( nonatomic, strong ) CRTransitionAnimationObject *transitionAnimationObject;

@property( nonatomic, strong ) UIView *park;
@property( nonatomic, strong ) UILabel *nameplate;
@property( nonatomic, strong ) UIButton *dismissButton;
@property( nonatomic, strong ) UIButton *editButton;

@property( nonatomic, strong ) UITableView *bear;

@property( nonatomic, assign ) NSUInteger selectedRow;
@property( nonatomic, strong ) NSArray *accounts;

@property( nonatomic, assign ) BOOL isEditing;

@property( nonatomic, strong ) CRClassAccount *deleteAccount;

@end

@implementation CRAccountsViewController

- (instancetype)init{
    self = [super init];
    if( self ){
        self.title = @"Accounts";
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.cons = [NSMutableArray new];
    self.transitionAnimationObject = [CRTransitionAnimationObject defaultCRTransitionAnimation];
    
    [self doBear];
    [self.crnavigationController.leftItemButton setTitle:@"Edit" forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated{
    self.accounts = [CRClassDatabase selectClassAccountFromAll];
    self.crnavigationController.leftItemButton.hidden = NO;
    self.crnavigationController.leftItemButton.enabled = YES;
    if( ![self.crnavigationController.leftItemButton respondsToSelector:@selector(removeAccount)] ){
        [self.crnavigationController.leftItemButton addTarget:self
                                                       action:@selector(removeAccount)
                                             forControlEvents:UIControlEventTouchUpInside];
    }
    [self.bear reloadData];
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
        park.backgroundColor = [UIColor whiteColor];
        [park makeShadowWithSize:CGSizeMake(0, 1) opacity:0.0f radius:1.7];
        park;
    });
    
    UIButton *button;
    self.dismissButton = ({
        button = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, 56, 56)];
        button.titleLabel.font = [UIFont MaterialDesignIcons];
        [button setTitleColor:[UIColor colorWithWhite:157 / 255.0 alpha:1] forState:UIControlStateNormal];
        [button setTitle:[UIFont mdiArrowLeft] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    self.editButton = ({
        button = [UIButton new];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        button.titleLabel.font = [CRSettings appFontOfSize:17 weight:UIFontWeightRegular];
        [button setTitleColor:[UIColor colorWithWhite:157 / 255.0 alpha:1] forState:UIControlStateNormal];
        [button setTitle:@"Edit" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(removeAccount) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    self.nameplate = ({
        UILabel *name = [UILabel new];
        name.translatesAutoresizingMaskIntoConstraints = NO;
        name.font = [CRSettings appFontOfSize:21 weight:UIFontWeightRegular];
        name.text = @"Accounts";
        name.textColor = [UIColor colorWithWhite:57 / 255.0 alpha:1];
        name;
    });
    
    [self.view addSubview:self.park];
    [self.park addSubview:self.dismissButton];
    [self.park addSubview:self.editButton];
    [self.park addSubview:self.nameplate];
    
    [CRLayout view:@[ self.park, self.view ] type:CREdgeTopLeftRight];
    [CRLayout view:@[ self.park ] type:CRFixedHeight constants:UIEdgeInsetsMake(0, 56 + STATUS_BAR_HEIGHT, 0, 0)];
    [CRLayout view:@[ self.nameplate, self.park ] type:CREdgeAround constants:UIEdgeInsetsMake(STATUS_BAR_HEIGHT, 64, 0, -72)];
    [CRLayout view:@[ self.editButton, self.park ] type:CREdgeTopRightBottom constants:UIEdgeInsetsMake(STATUS_BAR_HEIGHT, 0, 0, 0)];
    [CRLayout view:@[ self.editButton ] type:CRFixedWidth constants:UIEdgeInsetsMake(64, 0, 0, 0)];
}

- (void)doBear{
    self.bear = ({
        UITableView *bear = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        bear.translatesAutoresizingMaskIntoConstraints = NO;
        bear.sectionFooterHeight = 0.0f;
        bear.sectionHeaderHeight = 0.0f;
        bear.contentInset = UIEdgeInsetsMake(STATUS_BAR_HEIGHT + 56, 0, 0, 0);
        bear.contentOffset = CGPointMake(0, -( 56 + STATUS_BAR_HEIGHT ));
        bear.showsHorizontalScrollIndicator = bear.showsVerticalScrollIndicator = NO;
        bear.backgroundColor = [UIColor colorWithWhite:237 / 255.0 alpha:1];
        bear.separatorStyle = UITableViewCellSeparatorStyleNone;
        bear.delegate = self;
        bear.dataSource = self;
        bear;
    });
    [self.view addSubview:self.bear];
    
    [CRLayout view:@[ self.bear, self.view ] type:CREdgeAround];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    if( point.y > -(56 + STATUS_BAR_HEIGHT) ){
        [self.crnavigationController parkSunset];
    }else{
        [self.crnavigationController parkSunrise];
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
    
    if( [account.current isEqualToString:CRClassAccountCurrentYESKEY] ){
        [cell makeCheck];
        if( !self.selectedRow ) self.selectedRow = indexPath.row;
    }else{
        [cell makeUnCheck];
    }
    
    if( self.isEditing )
        [cell editStyle:YES];
    else
        [cell editStyle:NO];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if( indexPath.row == [self.accounts count] + 1 )
        dispatch_async(dispatch_get_main_queue(), ^{
            self.crnavigationController.leftItemButton.enabled = NO;
            self.crnavigationController.leftItemButton.hidden = YES;
            [self CRInfoViewController];
        });
    
    else if( indexPath.row == [self.accounts count] )
        dispatch_async(dispatch_get_main_queue(), ^{
            [self CRAccountAddViewController];
        });
    
    else{
        
        CRClassAccount *account = (CRClassAccount *)self.accounts[indexPath.row];

        if( self.isEditing ){
            
            self.deleteAccount = account;
            [self.view.window actionRemoveWithHandler:self];
            
        }else if( indexPath.row != self.selectedRow ){
            
            CRAccountsTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedRow inSection:0]];
            [cell makeUnCheck];
            cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell makeCheck];
            
            self.selectedRow = indexPath.row;
            [CRClassDatabase changeCRClassAccountCurrent:account];
            self.accounts = [CRClassDatabase selectClassAccountFromAll];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:CRClassAccountDidChangeNotification object:nil];
        }
        
    }
}

- (void)actionConfrim:(NSString *)type{
    [CRClassDatabase deleteCRClassAccountFromID:self.deleteAccount.ID];
    
    if( [self.deleteAccount.current isEqualToString:CRClassAccountCurrentYESKEY] ){
        if( [self.accounts count] > 0 ){
            [CRClassDatabase changeCRClassAccountCurrent:self.accounts[0]];
            self.accounts = [CRClassDatabase selectClassAccountFromAll];
        }else{
            self.accounts = @[ [CRClassCurrent account] ];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CRClassAccountDidChangeNotification object:nil];
    }else{
        self.accounts = [CRClassDatabase selectClassAccountFromAll];
    }
    
    [self.bear reloadData];
}

- (void)removeAccount{
    if( self.isEditing ){
        self.isEditing = NO;
        [self.crnavigationController.leftItemButton setTitle:@"Edit" forState:UIControlStateNormal];
    }else{
        self.isEditing = YES;
        [self.crnavigationController.leftItemButton setTitle:@"Done" forState:UIControlStateNormal];
    }
    [self.bear reloadData];
}

- (void)CRTextFieldViewController{
    CRTextFieldViewController *textField = [CRTextFieldViewController new];
    textField.placeholderString = @"User name";
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
    
    [self.crnavigationController crpushViewController:info animated:YES];
}

- (void)CRDebugViewController{
    CRDebugViewController *debug = [CRDebugViewController new];
    [self presentViewController:debug animated:YES completion:nil];
}

- (void)dismissSelf{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
