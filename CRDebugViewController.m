//
//  CRDebugViewController.m
//  CRClassSchedule
//
//  Created by caine on 12/12/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height

#import "CRDebugViewController.h"
#import "UIView+MOREShadow.h"
#import "UIView+MOREStackLayoutView.h"
#import "UIFont+MaterialDesignIcons.h"
#import "CRSettings.h"
#import "CRClassDatabase.h"
#import "CRClassCurrent.h"
#import "UIColor+CRColor.h"
#import "CRClassTableViewCell.h"

@interface CRDebugViewController()

@property( nonatomic, strong ) UIView *park;
@property( nonatomic, strong ) UILabel *parkTitle;
@property( nonatomic, strong ) UIButton *dismissButton;

@end

@implementation CRDebugViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self makeButton];
    [self makePark];
}

- (void)makeAction:(UIButton *)sender{
    NSUInteger tag = sender.tag - 1000;

    if( tag == 0 ){
        [CRClassDatabase dropCRClassAccount];
    }
}

- (void)makePark{
    self.park = ({
        UIView *park = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, STATUS_BAR_HEIGHT + 56)];
        park.backgroundColor = [UIColor CRColorType:CRColorTypeGoogleYellow];
        [park makeShadowWithSize:CGSizeMake(0, 1) opacity:0.27 radius:1.7];
        park;
    });
    [self.view addSubview:self.park];
    
    self.dismissButton = ({
        UIButton *dismiss = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, 56, 56)];
        dismiss.titleLabel.font = [UIFont MaterialDesignIcons];
        [dismiss setTitle:[UIFont mdiClose] forState:UIControlStateNormal];
        [dismiss setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [dismiss addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
        dismiss;
    });
    [self.park addSubview:self.dismissButton];
    
    self.parkTitle = ({
        UILabel *title = [[UILabel alloc] initWithFrame:({
            CGRect frame = self.view.frame;
            frame.origin.x = 56;
            frame.origin.y = STATUS_BAR_HEIGHT;
            frame.size.width = frame.size.width - 56;
            frame.size.height = 56;
            frame;
        })];
        title.text = @"Debug";
        title.textColor = [UIColor whiteColor];
        title;
    });
    [self.park addSubview:self.parkTitle];
}

- (void)makeButton{
    UIButton *(^makeBtn)(NSUInteger, CGRect, NSString *) = ^(NSUInteger tag, CGRect frame, NSString *title){
        UIButton *button = [[UIButton alloc] initWithFrame:frame];
        button.tag = tag;
        button.backgroundColor = [UIColor CRColorType:CRColorTypeGoogleTomato];
        [button setTitle:title forState:UIControlStateNormal];
        [button addTarget:self action:@selector(makeAction:) forControlEvents:UIControlEventTouchUpInside];
        return button;
    };
    
    CGFloat width = self.view.frame.size.width;
    
    UIButton *clearAllAccount = makeBtn( 1000, CGRectMake(0, STATUS_BAR_HEIGHT + 56 + 10, width, 56), @"Clear All Accounts" );
    [self.view addSubview:clearAllAccount];
    
}

- (void)dismissSelf{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
