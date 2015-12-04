//
//  CRAccountAddViewController.m
//  CRClassSchedule
//
//  Created by caine on 12/4/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height

#import "CRAccountAddViewController.h"
#import "UIView+MOREShadow.h"
#import "UIView+MOREStackLayoutView.h"
#import "UIFont+MaterialDesignIcons.h"
#import "CRSettings.h"
#import "CRClassDatabase.h"
#import "UIColor+CRColor.h"

@interface CRAccountAddViewController ()

@property( nonatomic, strong ) NSMutableArray *cons;

@property( nonatomic, strong ) UIView *park;
@property( nonatomic, strong ) UILabel *nameplate;
@property( nonatomic, strong ) UIButton *dismissButton;

@end

@implementation CRAccountAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.cons = [NSMutableArray new];
    
    [self doPark];
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
    self.nameplate.text = @"Add account";
}

- (void)dismissSelf{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
