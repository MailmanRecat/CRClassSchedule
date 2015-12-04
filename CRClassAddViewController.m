//
//  CRClassAddViewController.m
//  CRClassSchedule
//
//  Created by caine on 12/1/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRClassAddViewController.h"
#import "UIView+MOREShadow.h"
#import "UIView+MOREStackLayoutView.h"
#import "UIFont+MaterialDesignIcons.h"
#import "UIColor+Theme.h"
#import "CRSettings.h"
#import "HuskyButton.h"
#import "UIColor+CRColor.h"
#import "GGAnimationSunrise.h"
#import "CRLabelView.h"
#import "CRTextFieldView.h"
#import "CRButtonView.h"
#import "CRTextView.h"
#import "TimeTalkerBird.h"

#import "MORETransitionAnimationDelegate.h"
#import "CRTimeOptionsViewController.h"
#import "CRTimeOptionViewController.h"
#import "CRTextFieldViewController.h"
#import "MOREColorPickerView.h"

@interface CRClassAddViewController()<UITextFieldDelegate, CRColorPickerHandler, CRTextFieldVCHandler, CRTimeOptionsVCHandler, CRTimeOptionVCHandler>

@property( nonatomic, strong ) UIView *park;
@property( nonatomic, strong ) HuskyButton *dismissButton;
@property( nonatomic, strong ) CRLabelView *timeStart;
@property( nonatomic, strong ) CRLabelView *location;
@property( nonatomic, strong ) UILabel *classname;

@property( nonatomic, strong ) UIView *bottomBear;
@property( nonatomic, strong ) NSLayoutConstraint *bottomBearLayoutGuide;
@property( nonatomic, strong ) UIButton *saveButton;

@property( nonatomic, strong ) UIScrollView *bear;
@property( nonatomic, strong ) NSLayoutConstraint *bearBottomLayoutGuide;
@property( nonatomic, strong ) CRTextFieldView *teacher;
@property( nonatomic, strong ) CRButtonView *weekday;
@property( nonatomic, strong ) CRButtonView *timeLong;
@property( nonatomic, strong ) CRButtonView *colorType;
@property( nonatomic, strong ) CRTextView *userInfo;

@property( nonatomic, strong ) GGAnimationSunrise *sun;
@property( nonatomic, strong ) MORETransitionAnimationDelegate *transitionAnimationDelegate;

@property( nonatomic, strong ) UIColor *testColor;

@end

@implementation CRClassAddViewController

- (instancetype)initFromClassSchedule:(CRClassSchedule *)classSchedule{
    self = [super init];
    if( self ){
        self.classSchedule = classSchedule;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.transitionAnimationDelegate = [[MORETransitionAnimationDelegate alloc] initWithAnimationType:CRAnimationTypeDefault];
    self.sun = [[GGAnimationSunrise alloc] initWithType:GGAnimationSunriseTypeConcurrent blockOnCompletion:^(GGAnimationSunriseType type){
        self.park.backgroundColor = self.testColor;
    }];
    
    [self doBear];
    [self doPark];
    [self doBottomBear];
    
    [self addNotificationObserver];
    if( self.isPreview ) self.dismissButton.alpha = 0;
}

- (void)showDismissButton{
    self.dismissButton.alpha = 1;
}

- (void)addNotificationObserver{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self
               selector:@selector(willKeyBoardShow:)
                   name:UIKeyboardWillShowNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(willKeyBoardHide:)
                   name:UIKeyboardWillHideNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(willKeyBoardChangeFrame:)
                   name:UIKeyboardWillChangeFrameNotification
                 object:nil];
}

- (void)CRColorPickerDidDismissHandler:(UIColor *)color{
    self.testColor = color;
    [self.sun sunriseAtLand:self.park
                   location:CGPointMake(self.view.frame.size.width / 2.0f, (STATUS_BAR_HEIGHT + 56 + 72) / 2.0f)
                 lightColor:color];
}

- (void)CRTextFieldVCDidDismiss:(NSString *)textFieldString{
    self.classname.text = textFieldString;
}

- (void)CRTimeOptionVCDidDismissWithType:(CRTimeOptionType)type option:(NSString *)option{
    if( type == CRTimeOptionTypeClassmins )
        self.timeLong.textLabel.text = option;
    else if( type == CRTimeOptionTypeWeekday )
        self.weekday.textLabel.text = option;
}

- (void)CRTimeOptionsVCDidDismissWithOption:(NSString *)option{
    self.timeStart.strong.text = option;
}

- (void)willKeyBoardShow:(NSNotification *)keyboardInfo{
    NSDictionary *info = [keyboardInfo userInfo];
    CGFloat constant = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat duration = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationOptions option = [info[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [self layoutSaveButtonDuration:duration options:option constant:constant];
}

- (void)willKeyBoardHide:(NSNotification *)keyboardInfo{
    NSDictionary *info = [keyboardInfo userInfo];
    CGFloat duration = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationOptions option = [info[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [self layoutSaveButtonDuration:duration options:option constant:0];
}

- (void)layoutSaveButtonDuration:(CGFloat)duration options:(UIViewAnimationOptions)options constant:(CGFloat)constant{
    self.bottomBearLayoutGuide.constant = constant;
    self.bearBottomLayoutGuide.constant = constant;
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:options
                     animations:^{
                         [self.view layoutIfNeeded];
                     }completion:nil];
}

- (void)willKeyBoardChangeFrame:(NSNotification *)keyboardInfo{
//    NSLog(@"will change");
    NSDictionary *info = [keyboardInfo userInfo];
    CGRect bounds = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    NSLog(@"%@", info);
}

- (void)doPark{
    NSMutableArray *cons = [NSMutableArray new];
    self.park = [UIView new];
    self.timeStart = [CRLabelView new];
    self.location = [CRLabelView new];
    self.classname = [UILabel new];
    UIButton *classnameButton = [UIButton new];
    HuskyButton *backButton = [HuskyButton new];
    [self.view addAutolayoutSubviews:@[ self.park ]];
    [self.park addAutolayoutSubviews:@[ backButton, self.timeStart, self.location, classnameButton, self.classname ]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.park to:self.view type:EdgeTopLeftRightZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.park type:SpactecledBearFixedHeight
                                                             constant:56 + 72 + STATUS_BAR_HEIGHT]];
    [self.view addConstraints:cons];
    [cons removeAllObjects];
    CGFloat CRLabelHeight = 28;
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:backButton to:self.park type:EdgeLeftZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:backButton to:self.park type:EdgeTopZero
                                                            constant:STATUS_BAR_HEIGHT]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:backButton type:SpactecledBearFixedEqual constant:CRLabelHeight + 8 + 8]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.timeStart to:self.park type:EdgeTopZero
                                                            constant:STATUS_BAR_HEIGHT + 8]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.timeStart to:self.park type:EdgeLeftRightZero
                                                            constant:56]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.location to:self.park type:EdgeTopZero
                                                            constant:STATUS_BAR_HEIGHT + 8 + 8 + CRLabelHeight]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.location to:self.park type:EdgeLeftRightZero
                                                            constant:56]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.timeStart type:SpactecledBearFixedHeight constant:CRLabelHeight]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.location type:SpactecledBearFixedHeight constant:CRLabelHeight]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.classname to:self.park type:EdgeBottomZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.classname to:self.park type:EdgeLeftRightZero constant:56]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.classname type:SpactecledBearFixedHeight
                                                             constant:(56 + 72) - 8 - CRLabelHeight - 8 - CRLabelHeight]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:classnameButton to:self.park type:EdgeBottomZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:classnameButton to:self.park type:EdgeLeftRightZero constant:56]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:classnameButton type:SpactecledBearFixedHeight
                                                             constant:(56 + 72) - 8 - CRLabelHeight - 8 - CRLabelHeight]];
    [self.park addConstraints:cons];
    [cons removeAllObjects];
    
    self.park.backgroundColor = [UIColor CRColorType:CRColorTypeGoogleMapBlue];
    
    self.timeStart.light.text = @"start:";
    self.timeStart.strong.text = self.classSchedule.timeStart;
    self.location.light.text = @"location:";
    self.location.strong.text = self.classSchedule.location;
    self.classname.text = self.classSchedule.classname;
    self.classname.font = [CRSettings appFontOfSize:21];
    self.classname.textColor = [UIColor colorWithWhite:1 alpha:0.7];
    
    classnameButton.backgroundColor = [UIColor clearColor];
    [classnameButton addTarget:self action:@selector(CRTextFieldViewController) forControlEvents:UIControlEventTouchUpInside];
    
    [self.timeStart.button addTarget:self action:@selector(CRTimeOptionsViewController) forControlEvents:UIControlEventTouchUpInside];
    
    backButton.layer.cornerRadius = 56.0f / 2.0f;
    backButton.titleLabel.font = [UIFont MaterialDesignIcons];
    [backButton setTitle:[UIFont mdiArrowLeft] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    self.dismissButton = backButton;
}

- (void)doBottomBear{
    NSMutableArray *cons = [NSMutableArray new];
    self.bottomBear = [UIView new];
    [self.view addAutolayoutSubviews:@[ self.bottomBear ]];
    self.saveButton = [UIButton new];
    [self.bottomBear addAutolayoutSubviews:@[ self.saveButton ]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.bottomBear to:self.view type:EdgeLeftRightZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.bottomBear type:SpactecledBearFixedHeight constant:52]];
    self.bottomBearLayoutGuide = [NSLayoutConstraint constraintWithItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.bottomBear
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:0];
    [cons addObject:self.bottomBearLayoutGuide];
    [self.view addConstraints:cons];
    [cons removeAllObjects];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.saveButton to:self.bottomBear type:EdgeTopBottomZero constant:8]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.saveButton to:self.bottomBear type:EdgeRightZero constant:8]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.saveButton type:SpactecledBearFixedWidth constant:72]];
    [self.bottomBear addConstraints:cons];
    [cons removeAllObjects];
    
    self.saveButton.backgroundColor = [UIColor clearColor];
    self.saveButton.titleLabel.font = [CRSettings appFontOfSize:17];
    [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor CRColorType:CRColorTypeGoogleMapBlue] forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(CRSaveClass) forControlEvents:UIControlEventTouchUpInside];
}

- (void)doBear{
    NSMutableArray *cons = [NSMutableArray new];
    self.bear = [UIScrollView new];
    [self.view addAutolayoutSubviews:@[ self.bear ]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.bear to:self.view type:EdgeTopLeftRightZero]];
    self.bearBottomLayoutGuide = [NSLayoutConstraint constraintWithItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.bear
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:0];
    [self.view addConstraint:self.bearBottomLayoutGuide];
    [self.view addConstraints:cons];
    [cons removeAllObjects];
    
    self.teacher = [CRTextFieldView new];
    self.weekday = [CRButtonView new];
    self.timeLong = [CRButtonView new];
    self.colorType = [CRButtonView new];
    self.userInfo = [CRTextView new];
    UIView *edgeBottom = [UIView new];
    [self.bear autolayoutSubviews:@[ self.teacher, self.weekday, self.timeLong, self.colorType, self.userInfo, edgeBottom ]
                       edgeInsets:UIEdgeInsetsMake(STATUS_BAR_HEIGHT + 56 + 72, 0, 0, 0)
                       multiplier:1.0
                         constant:0
                        constants:@[ @64, @64, @64, @64, @192, @52 ]
                 stackOrientation:autolayoutStackOrientationVertical
                        direction:autolayoutStackDirectionTop
                           option:autolayoutStackOptionTrailing];
    
    self.teacher.delegate = self;
    self.teacher.icon.text = [UIFont mdiAccount];
    self.teacher.placeholder = self.classSchedule.teacher;
    self.teacher.tintColor = [UIColor CRColorType:CRColorTypeGoogleMapBlue];
    
    self.weekday.icon.text = [UIFont mdiCalendar];
    self.weekday.textLabel.text = self.classSchedule.weekday;
    [self.weekday addTarget:self action:@selector(CRWeekdayViewController) forControlEvents:UIControlEventTouchUpInside];
    
    self.timeLong.icon.text = [UIFont mdiClock];
    self.timeLong.textLabel.text = self.classSchedule.timeLong;
    [self.timeLong addTarget:self action:@selector(CRTimeOptionViewController) forControlEvents:UIControlEventTouchUpInside];
    
    self.colorType.icon.text = [UIFont mdiCheckboxBlankCircle];
    self.colorType.icon.textColor = [UIColor CRColorType:CRColorTypeGoogleMapBlue];
    self.colorType.textLabel.text = self.classSchedule.colorType;
    [self.colorType addTarget:self action:@selector(CRColorPickerViewController) forControlEvents:UIControlEventTouchUpInside];
    
    self.userInfo.icon.text = [UIFont mdiPencil];
    self.userInfo.textView.text = self.classSchedule.userInfo;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)CRTimeOptionsViewController{
    CRTimeOptionsViewController *timeOptions = [CRTimeOptionsViewController new];
    
    
    
    timeOptions.handler = self;
    timeOptions.transitioningDelegate = self.transitionAnimationDelegate;
    [self presentViewController:timeOptions animated:YES completion:nil];
}

- (void)CRTimeOptionViewController{
    CRTimeOptionViewController *timeOption  = [CRTimeOptionViewController new];
    timeOption.handler = self;
    
    NSString *minString = self.timeLong.textLabel.text;
    if( [minString isEqualToString:@"5 mins"] )
        timeOption.mins = 0;
    else if( [minString isEqualToString:@"10 mins"] )
        timeOption.mins = 1;
    else if( [minString isEqualToString:@"15 mins"] )
        timeOption.mins = 2;
    else if( [minString isEqualToString:@"20 mins"] )
        timeOption.mins = 3;
    else if( [minString isEqualToString:@"25 mins"] )
        timeOption.mins = 4;
    else if( [minString isEqualToString:@"30 mins"] )
        timeOption.mins = 5;
    else if( [minString isEqualToString:@"35 mins"] )
        timeOption.mins = 6;
    else if( [minString isEqualToString:@"40 mins"] )
        timeOption.mins = 7;
    else if( [minString isEqualToString:@"45 mins"] )
        timeOption.mins = 8;
    else if( [minString isEqualToString:@"50 mins"] )
        timeOption.mins = 9;
    else if( [minString isEqualToString:@"55 mins"] )
        timeOption.mins = 10;
    else if( [minString isEqualToString:@"1 hour"] )
        timeOption.mins = 11;
    else if( [minString isEqualToString:@"1 hour 10 mins"] )
        timeOption.mins = 12;
    else if( [minString isEqualToString:@"1 hour 20 mins"] )
        timeOption.mins = 13;
    else if( [minString isEqualToString:@"1 hour 30 mins"] )
        timeOption.mins = 14;
    else if( [minString isEqualToString:@"1 hour 40 mins"] )
        timeOption.mins = 15;
    else if( [minString isEqualToString:@"1 hour 50 mins"] )
        timeOption.mins = 16;
    else if( [minString isEqualToString:@"2 hours"] )
        timeOption.mins = 17;
    else if( [minString isEqualToString:@"2 hours 30 mins"] )
        timeOption.mins = 18;
    else if( [minString isEqualToString:@"3 hours"] )
        timeOption.mins = 19;
    else
        timeOption.mins = 0;
    
    timeOption.type = CRTimeOptionTypeClassmins;
    timeOption.transitioningDelegate = self.transitionAnimationDelegate;
    [self presentViewController:timeOption animated:YES completion:nil];
}

- (void)CRWeekdayViewController{
    CRTimeOptionViewController *weekdayOption = [CRTimeOptionViewController new];
    weekdayOption.handler = self;
    weekdayOption.weekday = [CRSettings weekdayFromString:self.weekday.textLabel.text];
    weekdayOption.type = CRTimeOptionTypeWeekday;
    weekdayOption.transitioningDelegate = self.transitionAnimationDelegate;
    [self presentViewController:weekdayOption animated:YES completion:nil];
}

- (void)CRTextFieldViewController{
    CRTextFieldViewController *textField = [CRTextFieldViewController new];
    textField.handler = self;
    textField.transitioningDelegate = self.transitionAnimationDelegate;
    [self presentViewController:textField animated:YES completion:nil];
}

- (void)CRColorPickerViewController{
    MOREColorPickerView *colorPicker = [MOREColorPickerView new];
    colorPicker.handler = self;
    colorPicker.transitioningDelegate = self.transitionAnimationDelegate;
    [self presentViewController:colorPicker animated:YES completion:nil];
}

- (void)CRSaveClass{
    NSLog(@"%@", self.classSchedule.user);
    NSLog(@"%@", self.classSchedule.weekday);
    NSLog(@"%@", self.classSchedule.timeStart);
    NSLog(@"%@", self.classSchedule.location);
    NSLog(@"%@", self.classSchedule.classname);
    NSLog(@"%@", self.classSchedule.teacher);
    NSLog(@"%@", self.classSchedule.timeLong);
    NSLog(@"%@", self.classSchedule.colorType);
    NSLog(@"%@", self.classSchedule.userInfo);
    NSLog(@"%@", self.classSchedule.type);
}

- (void)dismissSelf{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
