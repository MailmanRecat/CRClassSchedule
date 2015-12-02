//
//  CRTextFieldViewController.m
//  CRClassSchedule
//
//  Created by caine on 12/2/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height

#import "CRTextFieldViewController.h"
#import "UIView+MOREShadow.h"
#import "UIView+MOREStackLayoutView.h"
#import "UIFont+MaterialDesignIcons.h"
#import "UIColor+Theme.h"
#import "CRSettings.h"
#import "HuskyButton.h"
#import "UIColor+CRColor.h"

@interface CRTextFieldViewController ()<UITextFieldDelegate>

@property( nonatomic, strong ) UIView *park;
@property( nonatomic, strong ) HuskyButton *parkLeftButton;
@property( nonatomic, strong ) UITextField *parkTextField;

@end

@implementation CRTextFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"class name";
    
    [self doPark];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didKeyBoardHide)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [self.parkTextField becomeFirstResponder];
}

- (void)doPark{
    NSMutableArray *cons = [NSMutableArray new];
    self.park = [UIView new];
    self.parkLeftButton = [HuskyButton new];
    self.parkTextField = [UITextField new];
    [self.view addAutolayoutSubviews:@[ self.park ]];
    [self.park addAutolayoutSubviews:@[ self.parkLeftButton, self.parkTextField ]];
    CGFloat parkHeight = 48;
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.park to:self.view type:EdgeTopZero constant:STATUS_BAR_HEIGHT + 8]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.park to:self.view type:EdgeLeftRightZero constant:8]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.park type:SpactecledBearFixedHeight constant:parkHeight]];
    [self.view addConstraints:cons];
    [cons removeAllObjects];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.parkLeftButton to:self.park type:EdgeTopLeftBottomZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.parkLeftButton type:SpactecledBearFixedWidth constant:parkHeight]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.parkTextField to:self.park type:EdgeTopRightBottomZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.parkTextField to:self.park type:EdgeLeftZero constant:parkHeight]];
    [self.park addConstraints:cons];
    [cons removeAllObjects];
    
    self.park.backgroundColor = [UIColor whiteColor];
    self.park.layer.cornerRadius = 3.0f;
    [self.park makeShadowWithSize:CGSizeMake(0, 1) opacity:0.17 radius:1.7];
    
    self.parkLeftButton.layer.cornerRadius = parkHeight / 2.0f;
    self.parkLeftButton.titleLabel.font = [UIFont MaterialDesignIconsWithSize:21];
    [self.parkLeftButton setTitleColor:[UIColor colorWithWhite:137 / 255.0 alpha:1] forState:UIControlStateNormal];
    [self.parkLeftButton setTitle:[UIFont mdiArrowLeft] forState:UIControlStateNormal];
    
    self.parkTextField.delegate = self;
    self.parkTextField.placeholder = self.title;
    self.parkTextField.tintColor = [UIColor CRColorType:CRColorTypeGoogleMapBlue];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didKeyBoardHide{
    [self dismissSelf];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dismissSelf{
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:CRTextFieldViewControllerNotificationKey
                                                            object:self userInfo:@{ CRTextFieldStringKey: self.parkTextField.text }];
    }];
}

@end
