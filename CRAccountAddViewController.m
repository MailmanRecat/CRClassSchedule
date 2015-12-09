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
#import "HuskyButton.h"
#import "CRSettings.h"
#import "CRClassDatabase.h"
#import "UIColor+CRColor.h"

#import "MOREColorPickerView.h"

@interface CRAccountAddViewController ()<CRColorPickerHandler, UITextFieldDelegate>

@property( nonatomic, strong ) NSLayoutConstraint *parkLeyoutGuide;
@property( nonatomic, strong ) UIView *park;
@property( nonatomic, strong ) UITextField *textField;
@property( nonatomic, strong ) UIView *border;
@property( nonatomic, strong ) UILabel *infomation;
@property( nonatomic, strong ) HuskyButton *dismissButton;

@property( nonatomic, strong ) UIButton *doneButton;
@property( nonatomic, strong ) UIButton *nextButton;
@property( nonatomic, strong ) UILabel *guideText;

@property( nonatomic, assign ) BOOL saveable;

@property( nonatomic, assign ) BOOL shouldDismiss;

@end

@implementation CRAccountAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self makePark];
    [self makeStep];
    [self addNotificationObserver];
    
    self.account = [CRClassAccount accountFromDictionary:@{
                                                           CRClassAccountCurrentKEY: @"NO",
                                                           CRClassAccountIDKEY: @"no",
                                                           CRClassAccountColorTypeKEY: @"default"
                                                           }];
    self.saveable = NO;
    self.shouldDismiss = NO;
}

- (void)addNotificationObserver{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(didKeyBoardHide)
                   name:UIKeyboardDidHideNotification
                 object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    if( self.isBeingPresented ){
        [self.textField becomeFirstResponder];
    }
}

- (void)makePark{
    self.park = [UIView new];
    self.textField = [UITextField new];
    self.infomation = [UILabel new];
    self.border = [UIView new];
    self.dismissButton = [HuskyButton new];
    [self.view addAutolayoutSubviews:@[ self.park ]];
    [self.park addAutolayoutSubviews:@[ self.infomation, self.border, self.textField, self.dismissButton ]];
    self.parkLeyoutGuide = [NSLayoutConstraint constraintWithItem:self.park
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0
                                                         constant:48];
    [self.park addConstraint:self.parkLeyoutGuide];
    [CRLayout view:@[ self.park, self.view ] type:CREdgeTopLeftRight constants:UIEdgeInsetsMake(STATUS_BAR_HEIGHT + 8, 8, 0, -8)];
    [CRLayout view:@[ self.dismissButton, self.park ] type:CREdgeTopLeft constants:UIEdgeInsetsMake(0, 0, 0, 0)];
    [CRLayout view:@[ self.dismissButton ] type:CRFixedEqual constants:UIEdgeInsetsMake(48, 48, 0, 0)];
    [CRLayout view:@[ self.textField, self.park ] type:CREdgeTopLeftRight constants:UIEdgeInsetsMake(0, 56, 0, -56)];
    [CRLayout view:@[ self.textField ] type:CRFixedHeight constants:UIEdgeInsetsMake(0, 48, 0, 0)];
    [CRLayout view:@[ self.infomation, self.park ] type:CREdgeBottomLeftRight constants:UIEdgeInsetsMake(0, 56, 0, -56)];
    [CRLayout view:@[ self.infomation ] type:CRFixedHeight constants:UIEdgeInsetsMake(0, 48, 0, 0)];
    [CRLayout view:@[ self.border, self.park ] type:CREdgeTopLeftRight constants:UIEdgeInsetsMake(48, 0, 0, 0)];
    [CRLayout view:@[ self.border ] type:CRFixedHeight constants:UIEdgeInsetsMake(0, 1, 0, 0)];
    
    self.park.backgroundColor = [UIColor whiteColor];
    self.park.layer.cornerRadius = 2.0f;
    [self.park makeShadowWithSize:CGSizeMake(0, 1) opacity:0.17 radius:1.7];
    
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.delegate = self;
    
    self.infomation.text = @"infomation";
    self.infomation.alpha = 0;
    self.infomation.textColor = [UIColor CRColorType:CRColorTypeGoogleTomato];
    self.border.backgroundColor = [UIColor colorWithWhite:237 / 255.0 alpha:1];
    self.border.alpha = 0;
    
    self.dismissButton.layer.cornerRadius = 48 / 2.0f;
    self.dismissButton.titleLabel.font = [UIFont MaterialDesignIconsWithSize:21];
    [self.dismissButton setTitleColor:[UIColor colorWithWhite:137 / 255.0 alpha:1] forState:UIControlStateNormal];
    [self.dismissButton setTitle:[UIFont mdiArrowLeft] forState:UIControlStateNormal];
    [self.dismissButton addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
}

- (void)makeStep{
    self.doneButton = [UIButton new];
    self.nextButton = [UIButton new];
    self.guideText = [UILabel new];
    [self.view addAutolayoutSubviews:@[ self.doneButton, self.nextButton, self.guideText ]];
    [CRLayout view:@[ self.doneButton, self.view ] type:CRCenterX];
    [CRLayout view:@[ self.doneButton, self.view ] type:CREdgeBottom constants:UIEdgeInsetsMake(0, 0, -56, 0)];
    [CRLayout view:@[ self.doneButton ] type:CRFixedEqual constants:UIEdgeInsetsMake(56, 56, 0, 0)];
    [CRLayout view:@[ self.nextButton, self.view ] type:CREdgeBottomRight constants:UIEdgeInsetsMake(0, 0, -56, -16)];
    [CRLayout view:@[ self.nextButton ] type:CRFixedEqual constants:UIEdgeInsetsMake(56, 56, 0, 0)];
    [CRLayout view:@[ self.guideText, self.view ] type:CREdgeBottomLeftRight constants:UIEdgeInsetsMake(0, 16, -8, -16)];
    [CRLayout view:@[ self.guideText ] type:CRFixedHeight constants:UIEdgeInsetsMake(0, 48, 0, 0)];
    
    UIColor *defaultColor = [CRSettings MORESettingColorPickerOptionsColor][0];
    self.guideText.textColor = defaultColor;
    self.guideText.text = @"Done";
    self.guideText.textAlignment = NSTextAlignmentCenter;
    
    self.doneButton.layer.cornerRadius = self.nextButton.layer.cornerRadius = 56 / 2.0f;
    self.doneButton.backgroundColor = defaultColor;
    self.nextButton.backgroundColor = defaultColor;
    self.doneButton.titleLabel.font = self.nextButton.titleLabel.font = [UIFont MaterialDesignIcons];
    [self.doneButton setTitle:[UIFont mdiCheck] forState:UIControlStateNormal];
    [self.nextButton setTitle:[UIFont mdiChevronRight] forState:UIControlStateNormal];
    [self.doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.doneButton makeShadowWithSize:CGSizeMake(0.0f, 6.0f) opacity:0.3f radius:7.0f];
    [self.nextButton makeShadowWithSize:CGSizeMake(0.0f, 6.0f) opacity:0.3f radius:7.0f];
    [self.doneButton addTarget:self action:@selector(saveAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton addTarget:self action:@selector(CRColorPickerViewController) forControlEvents:UIControlEventTouchUpInside];
}

- (void)makeInfomation:(NSString *)information automiss:(BOOL)automiss{
    self.infomation.text = information;
    
    if( self.parkLeyoutGuide.constant == 48 * 2 ) return;
    
    self.parkLeyoutGuide.constant = 48 * 2;
    [UIView animateWithDuration:0.37f
                     animations:^{
                         self.infomation.alpha = 1;
                         self.border.alpha = 1;
                         [self.park layoutIfNeeded];
                     }completion:^(BOOL isFinished){
                         if( automiss ){
                             [NSTimer scheduledTimerWithTimeInterval:3.0f
                                                              target:self
                                                            selector:@selector(dismissInfomation)
                                                            userInfo:nil
                                                             repeats:NO];
                         }
                     }];
    
}

- (void)dismissInfomation{
    if( self.parkLeyoutGuide.constant == 48 ) return;
    
    self.parkLeyoutGuide.constant = 48;
    [UIView animateWithDuration:0.37f
                     animations:^{
                         self.infomation.alpha = 0;
                         self.border.alpha = 0;
                         [self.park layoutIfNeeded];
                     }completion:nil];
}

- (void)didKeyBoardHide{
    if( self.shouldDismiss )
        [self dismissSelf];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSString *text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if( [CRClassDatabase haveCRClassAccount:text] ){
        [self makeInfomation:@"account exists" automiss:NO];
        self.saveable = NO;
    }else if( [text isEqualToString:@""] ){
        [self makeInfomation:@"invalid name" automiss:NO];
        self.saveable = NO;
    }else{
        self.account.ID = text;
        self.saveable = YES;
    }
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self dismissInfomation];
    
    return YES;
}

- (void)CRColorPickerDidDismissHandler:(UIColor *)color name:(NSString *)name{
    self.doneButton.backgroundColor = self.guideText.textColor = self.nextButton.backgroundColor = color;
    self.account.colorType = name;
}

- (void)CRColorPickerViewController{
    MOREColorPickerView *colorPicker = [MOREColorPickerView new];
    colorPicker.transitioningDelegate = self.transitioningDelegate;
    colorPicker.curString = self.account.colorType;
    colorPicker.handler = self;
    [self presentViewController:colorPicker animated:YES completion:nil];
}

- (void)saveAccount{
    NSLog(@"%d", self.saveable);
    NSLog(@"%@ %@", self.account.ID, self.account.colorType);
    if( self.saveable ){
        [CRClassDatabase insertCRClassAccount:self.account];
        [self dismissSelf];
    }else{
        if( ![self.infomation.text isEqualToString:@"account exists"] ){
            [self makeInfomation:@"invalid name" automiss:YES];
        }else{
            [self makeInfomation:@"account exists" automiss:YES];
        }
    }
}

- (void)dismissSelf{
    if( [self.textField isFirstResponder] ){
        [self.view endEditing:YES];
        self.shouldDismiss = YES;
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
