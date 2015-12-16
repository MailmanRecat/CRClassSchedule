//
//  CRInfoViewController.m
//  CRClassSchedule
//
//  Created by caine on 12/4/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height

#import "CRInfoViewController.h"
#import "UIView+MOREShadow.h"
#import "UIView+MOREStackLayoutView.h"
#import "UIFont+MaterialDesignIcons.h"
#import "CRSettings.h"

@interface CRInfoViewController ()

@property( nonatomic, strong ) NSMutableArray *cons;

@property( nonatomic, strong ) UIView *park;
@property( nonatomic, strong ) UIButton *dismissButton;
@property( nonatomic, strong ) UILabel *nameplate;

@end

@implementation CRInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.cons = [NSMutableArray new];
    
    [self makePark];
}

- (void)makePark{
    
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
    
    self.nameplate = ({
        UILabel *name = [UILabel new];
        name.translatesAutoresizingMaskIntoConstraints = NO;
        name.font = [CRSettings appFontOfSize:21 weight:UIFontWeightRegular];
        name.text = @"About";
        name.textColor = [UIColor colorWithWhite:57 / 255.0 alpha:1];
        name;
    });
    
    [self.view addSubview:self.park];
    [self.park addSubview:self.dismissButton];
    [self.park addSubview:self.nameplate];
    
    [CRLayout view:@[ self.park, self.view ] type:CREdgeTopLeftRight];
    [CRLayout view:@[ self.park ] type:CRFixedHeight constants:UIEdgeInsetsMake(0, 56 + STATUS_BAR_HEIGHT, 0, 0)];
    [CRLayout view:@[ self.nameplate, self.park ] type:CREdgeAround constants:UIEdgeInsetsMake(STATUS_BAR_HEIGHT, 64, 0, -72)];

}

- (void)dismissSelf{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
