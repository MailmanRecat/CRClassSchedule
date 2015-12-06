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

@interface CRClassAddViewController()<UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate, CRColorPickerHandler, CRTextFieldVCHandler, CRTimeOptionsVCHandler, CRTimeOptionVCHandler>

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
@property( nonatomic, assign ) BOOL shouldRender;

@end

@implementation CRClassAddViewController

- (instancetype)initFromClassSchedule:(CRClassSchedule *)classSchedule{
    self = [super init];
    if( self ){
        self.classSchedule = classSchedule;
    }
    return self;
}

+ (instancetype)shareFromClassSchedule:(CRClassSchedule *)classSchedule{
    static CRClassAddViewController *instanceVC= nil;
    if( instanceVC ){
        instanceVC.classSchedule = classSchedule;
        instanceVC.shouldRender = YES;
        return instanceVC;
    }
    
    static dispatch_once_t instanceVCMaker;
    dispatch_once(&instanceVCMaker, ^{
        instanceVC = [[CRClassAddViewController alloc] initFromClassSchedule:classSchedule];
        instanceVC.shouldRender = YES;
    });
    return instanceVC;
}

-(NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    
    UIPreviewAction *deleteAction = [UIPreviewAction actionWithTitle:@"Delete" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
        NSLog(@"action handler");
        
    }];
    
    UIPreviewAction *editAction = [UIPreviewAction actionWithTitle:@"Edit Class" style:UIPreviewActionStyleDefault handler:^( UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController ){
        
        NSLog(@"edit");
    }];
    
    return @[ editAction, deleteAction ];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.transitionAnimationDelegate = [[MORETransitionAnimationDelegate alloc] initWithAnimationType:CRAnimationTypeDefault];
    self.sun = [[GGAnimationSunrise alloc] initWithType:GGAnimationSunriseTypeConcurrent blockOnCompletion:^(GGAnimationSunriseType type){
        self.park.backgroundColor = self.testColor;
    }];
    self.sun.duration = 0.57f;
    
    [self doBear];
    [self doPark];
    [self doBottomBear];
    
    [self addNotificationObserver];
}

- (void)viewWillAppear:(BOOL)animated{
    if( self.isPreview ){
        self.isPreview = NO;
        self.dismissButton.hidden = YES;
        [self.teacher makeBorder:NO];
        [self.weekday makeBorder:NO];
        [self.timeLong makeBorder:NO];
        [self.colorType makeBorder:NO];
        [self.userInfo makeBorder:NO];
    }else{
        [self showDismissButton];
        [self.teacher makeBorder:YES];
        [self.weekday makeBorder:YES];
        [self.timeLong makeBorder:YES];
        [self.colorType makeBorder:YES];
        [self.userInfo makeBorder:YES];
    }
    
    if( self.isBeingPresented ){
        self.park.backgroundColor = [CRSettings CRAppColorTypes][[self.classSchedule.colorType lowercaseString]];
        [self.saveButton setTitleColor:[CRSettings CRAppColorTypes][[self.classSchedule.colorType lowercaseString]] forState:UIControlStateNormal];
        
        self.timeStart.strong.text = self.classSchedule.timeStart;
        
        self.location.strong.text = self.classSchedule.location;
        
        self.classname.text = self.classSchedule.classname;
        
        self.teacher.placeholder = self.classSchedule.teacher;
        self.teacher.tintColor = [UIColor CRColorType:CRColorTypeGoogleMapBlue];
        
        self.weekday.textLabel.text = self.classSchedule.weekday;
        
        self.timeLong.textLabel.text = self.classSchedule.timeLong;
        
        self.colorType.icon.textColor = self.park.backgroundColor;
        self.colorType.textLabel.text = self.classSchedule.colorType;
        
        self.userInfo.textView.text = self.classSchedule.userInfo;
    }
}

- (void)showDismissButton{
    self.dismissButton.alpha = 1;
}

- (void)addNotificationObserver{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
//    [center addObserver:self
//               selector:@selector(willKeyBoardShow:)
//                   name:UIKeyboardWillShowNotification
//                 object:nil];
//    [center addObserver:self
//               selector:@selector(willKeyBoardHide:)
//                   name:UIKeyboardWillHideNotification
//                 object:nil];
    [center addObserver:self
               selector:@selector(willKeyBoardChangeFrame:)
                   name:UIKeyboardWillChangeFrameNotification
                 object:nil];
}

- (void)CRColorPickerDidDismissHandler:(UIColor *)color name:(NSString *)name{
    self.testColor = color;
    self.colorType.icon.textColor = color;
    [self.saveButton setTitleColor:color forState:UIControlStateNormal];
    self.colorType.textLabel.text = name;
    self.classSchedule.colorType = name;
    [self.sun sunriseAtLand:self.park
                   location:CGPointMake(self.view.frame.size.width / 2.0f, (STATUS_BAR_HEIGHT + 56 + 72) / 2.0f)
                 lightColor:color];
}

- (void)CRTextFieldVCDidDismiss:(NSString *)textFieldString{
    if( [textFieldString isEqualToString:@""] ) return;
    self.classname.text = textFieldString;
    self.classSchedule.classname = textFieldString;
}

- (void)CRTimeOptionVCDidDismissWithType:(CRTimeOptionType)type option:(NSString *)option{
    if( type == CRTimeOptionTypeClassmins ){
        self.timeLong.textLabel.text = option;
        self.classSchedule.timeLong = option;
    }
    else if( type == CRTimeOptionTypeWeekday ){
        self.weekday.textLabel.text = option;
        self.classSchedule.weekday = option;
    }
}

- (void)CRTimeOptionsVCDidDismissWithOption:(NSString *)option{
    self.timeStart.strong.text = option;
    self.classSchedule.timeStart = option;
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
                     }completion:^( BOOL isFinished ){
                         if( [self.userInfo.textView isFirstResponder] ){
                             [self.saveButton setTitle:@"Done" forState:UIControlStateNormal];
                             [UIView animateWithDuration:duration
                                              animations:^{
                                                  self.bear.contentOffset = CGPointMake(0, self.userInfo.frame.origin.y - STATUS_BAR_HEIGHT - 56 - 72);
                                              }];
                         }
                     }];
}

- (void)willKeyBoardChangeFrame:(NSNotification *)keyboardInfo{
    NSDictionary *info = [keyboardInfo userInfo];
    CGFloat constant = self.view.frame.size.height - [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    CGFloat duration = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationOptions option = [info[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [self layoutSaveButtonDuration:duration options:option constant:constant];
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
                                                            constant:56 + 8]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.location to:self.park type:EdgeTopZero
                                                            constant:STATUS_BAR_HEIGHT + 8 + 8 + CRLabelHeight]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.location to:self.park type:EdgeLeftRightZero
                                                            constant:56 + 8]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.timeStart type:SpactecledBearFixedHeight constant:CRLabelHeight]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.location type:SpactecledBearFixedHeight constant:CRLabelHeight]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.classname to:self.park type:EdgeBottomZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.classname to:self.park type:EdgeLeftRightZero constant:56 + 8]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.classname type:SpactecledBearFixedHeight
                                                             constant:(56 + 72) - 8 - CRLabelHeight - 8 - CRLabelHeight]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:classnameButton to:self.park type:EdgeBottomZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:classnameButton to:self.park type:EdgeLeftZero constant:56 + 8]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:classnameButton to:self.park type:EdgeRightZero constant:8]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:classnameButton type:SpactecledBearFixedHeight
                                                             constant:(56 + 72) - 8 - CRLabelHeight - 8 - CRLabelHeight]];
    [self.park addConstraints:cons];
    [cons removeAllObjects];
    
    self.timeStart.light.text = @"start:";
    self.location.light.text = @"location:";
    self.classname.font = [CRSettings appFontOfSize:21];
    self.classname.textColor = [UIColor colorWithWhite:1 alpha:1];
    self.classname.numberOfLines = 1;
    self.classname.adjustsFontSizeToFitWidth = YES;
    
    classnameButton.backgroundColor = [UIColor clearColor];
    [classnameButton addTarget:self action:@selector(CRTextFieldViewController) forControlEvents:UIControlEventTouchUpInside];
    
    [self.timeStart.button addTarget:self action:@selector(CRTimeOptionsViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.location.button addTarget:self action:@selector(CRTextFieldViewController) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    self.bottomBear.backgroundColor = [UIColor whiteColor];
    [self.bottomBear makeShadowWithSize:CGSizeMake(0, -1) opacity:0.17 radius:1.7];
    
    self.saveButton.backgroundColor = [UIColor clearColor];
    self.saveButton.titleLabel.font = [CRSettings appFontOfSize:17 weight:UIFontWeightMedium];
    [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[CRSettings CRAppColorTypes][[self.classSchedule.colorType lowercaseString]] forState:UIControlStateNormal];
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
    
    self.weekday.icon.text = [UIFont mdiCalendar];
    [self.weekday addTarget:self action:@selector(CRWeekdayViewController) forControlEvents:UIControlEventTouchUpInside];
    
    self.timeLong.icon.text = [UIFont mdiClock];
    [self.timeLong addTarget:self action:@selector(CRTimeOptionViewController) forControlEvents:UIControlEventTouchUpInside];
    
    self.colorType.icon.text = [UIFont mdiCheckboxBlankCircle];
    [self.colorType addTarget:self action:@selector(CRColorPickerViewController) forControlEvents:UIControlEventTouchUpInside];
    
    self.userInfo.icon.text = [UIFont mdiPencil];
    self.userInfo.textView.delegate = self;
    self.userInfo.textView.font = [CRSettings appFontOfSize:17];
    self.userInfo.textView.textColor = [UIColor colorWithWhite:117 / 255.0 alpha:1];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if( [textView.text isEqualToString:@"Add note"] ){
        textView.textColor = [UIColor blackColor];
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextField *)textField{
    [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
    NSLog(@"end");
    NSString *text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"--%@", text);
    
    if( [text isEqualToString:@""] ){
        textField.text = @"Add note";
        textField.textColor = [UIColor colorWithWhite:117 / 255.0 alpha:1];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)CRTimeOptionsViewController{
    CRTimeOptionsViewController *timeOptions = [CRTimeOptionsViewController shareTimeOptions];
    timeOptions.curTimeString = self.classSchedule.timeStart;
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
    MOREColorPickerView *colorPicker = [MOREColorPickerView shareColorPicker];
    colorPicker.curString = self.classSchedule.colorType;
    colorPicker.handler = self;
    colorPicker.transitioningDelegate = self.transitionAnimationDelegate;
    [self presentViewController:colorPicker animated:YES completion:nil];
}

- (void)CRSaveClass{
    
    if( [self.userInfo.textView isFirstResponder] ){
        [self.userInfo.textView resignFirstResponder];
    }
    
//    self.classSchedule.userInfo = self.userInfo.textView.text;
//    self.classSchedule.teacher = self.teacher.text;
//    NSLog(@"%@", self.classSchedule.user);
//    NSLog(@"%@", self.classSchedule.weekday);
//    NSLog(@"%@", self.classSchedule.timeStart);
//    NSLog(@"%@", self.classSchedule.location);
//    NSLog(@"%@", self.classSchedule.classname);
//    NSLog(@"%@", self.classSchedule.teacher);
//    NSLog(@"%@", self.classSchedule.timeLong);
//    NSLog(@"%@", self.classSchedule.colorType);
//    NSLog(@"%@", self.classSchedule.userInfo);
//    NSLog(@"%@", self.classSchedule.type);
}

- (void)dismissSelf{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
