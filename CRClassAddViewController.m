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
#import "CRLabelView.h"
#import "CRTextFieldView.h"
#import "CRButtonView.h"
#import "CRTextView.h"

#import "MORETransitionAnimationDelegate.h"
#import "CRTimeOptionsViewController.h"
#import "CRTimeOptionViewController.h"
#import "CRTextFieldViewController.h"

@interface CRClassAddViewController()<UITextFieldDelegate>

@property( nonatomic, strong ) UIView *park;
@property( nonatomic, strong ) CRLabelView *timeStart;
@property( nonatomic, strong ) CRLabelView *location;
@property( nonatomic, strong ) UILabel *classname;

@property( nonatomic, strong ) UIView *bottomBear;
@property( nonatomic, strong ) UIButton *saveButton;

@property( nonatomic, strong ) UIScrollView *bear;
@property( nonatomic, strong ) NSLayoutConstraint *bearBottomLayoutGuide;
@property( nonatomic, strong ) CRTextFieldView *teacher;
@property( nonatomic, strong ) CRButtonView *weekday;
@property( nonatomic, strong ) CRButtonView *timeLong;
@property( nonatomic, strong ) CRButtonView *colorType;
@property( nonatomic, strong ) CRTextView *userInfo;

@property( nonatomic, strong ) MORETransitionAnimationDelegate *transitionAnimationDelegate;

@end

@implementation CRClassAddViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.transitionAnimationDelegate = [[MORETransitionAnimationDelegate alloc] initWithAnimationType:CRAnimationTypeDefault];
    
    [self doBear];
    [self doPark];
    [self doBottomBear];
    
    [self addNotificationObserver];
}

- (void)addNotificationObserver{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(willKeyBoardShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(willKeyBoardHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willKeyBoardChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    [center addObserver:self
               selector:@selector(CRTimeDidSelected:)
                   name:CRTimeOptionsDidSelectedNotificationKey object:nil];
    [center addObserver:self
               selector:@selector(CRTimeLongDidSelected:)
                   name:CRTimeOptionDidSelectedNotificationKey object:nil];
    [center addObserver:self
               selector:@selector(CRClassnameDidChange:)
                   name:CRTextFieldViewControllerNotificationKey object:nil];
}

- (void)CRClassnameDidChange:(NSNotification *)userInfo{
    NSDictionary *info = [userInfo userInfo];
    NSLog(@"%@", (NSString *)info[CRTextFieldStringKey]);
}

- (void)CRTimeDidSelected:(NSNotification *)userInfo{
    NSDictionary *info = [userInfo userInfo];
    self.timeStart.strong.text = (NSString *)info[CRTimeStringKey];
}

- (void)CRTimeLongDidSelected:(NSNotification *)userInfo{
    NSDictionary *info = [userInfo userInfo];
    CRTimeOptionType type = [info[CRTimeOptionTypeKey] integerValue];
    if( type == CRTimeOptionTypeClassmins )
        self.timeLong.textLabel.text = (NSString *)info[CRTimeStringKey];
    if( type == CRTimeOptionTypeWeekday )
        self.weekday.textLabel.text = (NSString *)info[CRTimeStringKey];
}

- (void)willKeyBoardShow:(NSNotification *)keyboardInfo{
    NSLog(@"will show");
    NSDictionary *info = [keyboardInfo userInfo];
    CGRect bounds = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.bearBottomLayoutGuide.constant = -bounds.size.height;
    [UIView animateWithDuration:[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]
                          delay:0.0f
                        options:(UIViewAnimationOptions)[info objectForKey:UIKeyboardAnimationCurveUserInfoKey]
                     animations:^{
                         NSLog(@"layout");
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
}

- (void)willKeyBoardHide:(NSNotification *)keyboardInfo{
    NSLog(@"will hide");
    NSDictionary *info = [keyboardInfo userInfo];
    self.bearBottomLayoutGuide.constant = 0;
    [UIView animateWithDuration:[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]
                          delay:0.0f
                        options:(UIViewAnimationOptions)[info objectForKey:UIKeyboardAnimationCurveUserInfoKey]
                     animations:^{
                         NSLog(@"layout");
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
}

- (void)willKeyBoardChangeFrame:(NSNotification *)keyboardInfo{
    NSLog(@"will change");

    NSLog(@"%f", self.view.frame.size.height);
    NSDictionary *info = [keyboardInfo userInfo];
//    NSLog(@"%@", info);
    CGRect bounds = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    NSLog(@"%f", bounds.size.height);
    self.bearBottomLayoutGuide.constant = self.view.frame.size.height - bounds.origin.y + 0;
    [UIView animateWithDuration:[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]
                          delay:0.0f
                        options:(UIViewAnimationOptions)[info objectForKey:UIKeyboardAnimationCurveUserInfoKey]
                     animations:^{
                         NSLog(@"layout");
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];

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
    self.timeStart.strong.text = @"7:00";
    self.location.light.text = @"location:";
    self.location.strong.text = @"localtion";
    self.classname.text = @"Edit class name here";
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
}

- (void)doBottomBear{
    NSMutableArray *cons = [NSMutableArray new];
    self.bottomBear = [UIView new];
    [self.view addAutolayoutSubviews:@[ self.bottomBear ]];
    self.saveButton = [UIButton new];
    [self.bottomBear addAutolayoutSubviews:@[ self.saveButton ]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.bottomBear to:self.view type:EdgeBottomLeftRightZero]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.bottomBear type:SpactecledBearFixedHeight constant:52]];
    [self.view addConstraints:cons];
    [cons removeAllObjects];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.saveButton to:self.bottomBear type:EdgeTopBottomZero constant:8]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearEdeg:self.saveButton to:self.bottomBear type:EdgeRightZero constant:8]];
    [cons addObjectsFromArray:[NSLayoutConstraint SpactecledBearFixed:self.saveButton type:SpactecledBearFixedWidth constant:72]];
    [self.bottomBear addConstraints:cons];
    [cons removeAllObjects];
    
    self.saveButton.backgroundColor = [UIColor clearColor];
    self.saveButton.titleLabel.font = [CRSettings appFontOfSize:15];
    [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor CRColorType:CRColorTypeGoogleMapBlue] forState:UIControlStateNormal];
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
    [self.bear autolayoutSubviews:@[ self.teacher, self.weekday, self.timeLong, self.colorType, self.userInfo ]
                       edgeInsets:UIEdgeInsetsMake(STATUS_BAR_HEIGHT + 56 + 72, 0, 0, 0)
                       multiplier:1.0
                         constant:0
                        constants:@[ @64, @64, @64, @64, @192 ]
                 stackOrientation:autolayoutStackOrientationVertical
                        direction:autolayoutStackDirectionTop
                           option:autolayoutStackOptionTrailing];
    
    self.teacher.delegate = self;
    self.teacher.icon.text = [UIFont mdiAccount];
    self.teacher.placeholder = @"Edit teacher";
    self.teacher.tintColor = [UIColor CRColorType:CRColorTypeGoogleMapBlue];
    
    self.weekday.icon.text = [UIFont mdiCalendar];
    self.weekday.textLabel.text = [CRSettings weekday];
    [self.weekday addTarget:self action:@selector(CRWeekdayViewController) forControlEvents:UIControlEventTouchUpInside];
    
    self.timeLong.icon.text = [UIFont mdiClock];
    self.timeLong.textLabel.text = @"40 mins";
    [self.timeLong addTarget:self action:@selector(CRTimeOptionViewController) forControlEvents:UIControlEventTouchUpInside];
    
    self.colorType.icon.text = [UIFont mdiCheckboxBlankCircle];
    self.colorType.icon.textColor = [UIColor CRColorType:CRColorTypeGoogleMapBlue];
    self.colorType.textLabel.text = @"color type";
    
    self.userInfo.icon.text = [UIFont mdiPencil];
    self.userInfo.textView.text = @"Add note";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)CRTimeOptionsViewController{
    CRTimeOptionsViewController *timeOptions = [CRTimeOptionsViewController new];
    timeOptions.transitioningDelegate = self.transitionAnimationDelegate;
    [self presentViewController:timeOptions animated:YES completion:nil];
}

- (void)CRTimeOptionViewController{
    CRTimeOptionViewController *timeOption = [CRTimeOptionViewController new];
    timeOption.type = CRTimeOptionTypeClassmins;
    timeOption.transitioningDelegate = self.transitionAnimationDelegate;
    [self presentViewController:timeOption animated:YES completion:nil];
}

- (void)CRWeekdayViewController{
    CRTimeOptionViewController *weekday = [CRTimeOptionViewController new];
    weekday.type = CRTimeOptionTypeWeekday;
    weekday.transitioningDelegate = self.transitionAnimationDelegate;
    [self presentViewController:weekday animated:YES completion:nil];
}

- (void)CRTextFieldViewController{
    CRTextFieldViewController *textField = [CRTextFieldViewController new];
    textField.transitioningDelegate = self.transitionAnimationDelegate;
    [self presentViewController:textField animated:YES completion:nil];
}

- (void)dismissSelf{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
