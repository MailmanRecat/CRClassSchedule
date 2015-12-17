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
#import "GGAnimationSunrise.h"

#import "MOREColorPickerView.h"

@interface CRAccountAddViewController ()<CRColorPickerHandler, UITextFieldDelegate>

@property( nonatomic, strong ) GGAnimationSunrise *sun;

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

@property( nonatomic, strong ) UIView *keyboardView;
@property( nonatomic, strong ) UIColor *testColor;

@end

@implementation CRAccountAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.sun = [[GGAnimationSunrise alloc] initWithType:GGAnimationSunriseTypeSerial blockOnCompletion:^( GGAnimationSunriseType type ){
        self.view.backgroundColor = self.testColor;
    }];
    self.sun.duration = .77f;
    
    [self makePark];
    [self makeStep];
    [self addNotificationObserver];
    
    self.account = [CRClassAccount accountFromDefault];
    
    self.saveable = NO;
    self.shouldDismiss = NO;
}

- (void)addNotificationObserver{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self
               selector:@selector(willKeyboardShow)
                   name:UIKeyboardWillShowNotification
                 object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if( self.isBeingPresented ){
        [self.textField becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    __block CGRect frame = self.keyboardView.frame;
    frame.origin.x = self.view.frame.size.width;
    
    [self.transitionCoordinator animateAlongsideTransitionInView:self.keyboardView
                                                       animation:^(id<UIViewControllerTransitionCoordinatorContext> context){
                                                           
                                                           self.keyboardView.frame = frame;
                                                       }completion:^(id<UIViewControllerTransitionCoordinatorContext> context){
                                                           
                                                           self.keyboardView.hidden = YES;
                                                           self.keyboardView = nil;
                                                       }];
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
    self.textField.placeholder = @"name";
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
    self.guideText.hidden = YES;
    self.guideText.textColor = defaultColor;
    self.view.backgroundColor = defaultColor;
    self.guideText.text = @"Done";
    self.guideText.textAlignment = NSTextAlignmentCenter;
    
    self.doneButton.layer.cornerRadius = self.nextButton.layer.cornerRadius = 56 / 2.0f;
    self.doneButton.backgroundColor = [UIColor whiteColor];
    self.nextButton.backgroundColor = [UIColor whiteColor];
    self.doneButton.titleLabel.font = self.nextButton.titleLabel.font = [UIFont MaterialDesignIcons];
    [self.doneButton setTitle:[UIFont mdiCheck] forState:UIControlStateNormal];
    [self.nextButton setTitle:[UIFont mdiChevronRight] forState:UIControlStateNormal];
    [self.doneButton setTitleColor:defaultColor forState:UIControlStateNormal];
    [self.nextButton setTitleColor:defaultColor forState:UIControlStateNormal];
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

- (void)willKeyboardShow{
    
    for( UIWindow *window in [[UIApplication sharedApplication] windows] ){
        if( [window isKindOfClass:NSClassFromString(@"UIRemoteKeyboardWindow")] ){
            for( UIView *subview in window.subviews ){
                if( [subview isKindOfClass:NSClassFromString(@"UIInputSetContainerView")] ){
                    for( UIView *subsubview in subview.subviews ){
                        if( [subsubview isKindOfClass:NSClassFromString(@"UIInputSetHostView")] ){
                            self.keyboardView = subsubview;
                        }
                    }
                }
            }
        }
    }
    
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
    self.testColor = color;
    [self.sun sunriseAtLand:self.view location:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2) lightColor:color];
    [self.doneButton setTitleColor:color forState:UIControlStateNormal];
    [self.nextButton setTitleColor:color forState:UIControlStateNormal];
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
    if( self.saveable ){
        [CRClassDatabase insertCRClassAccount:self.account];
        [CRClassDatabase changeCRClassAccountCurrent:self.account];
        [[NSNotificationCenter defaultCenter] postNotificationName:CRClassAccountDidChangeNotification object:nil];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
