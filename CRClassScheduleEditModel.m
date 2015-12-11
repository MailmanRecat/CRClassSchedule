//
//  CRClassScheduleEditModel.m
//  CRClassSchedule
//
//  Created by caine on 12/11/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height

#import "CRClassScheduleEditModel.h"
#import "CRSettings.h"
#import "UIColor+CRColor.h"
#import "UIFont+MaterialDesignIcons.h"
#import "UIView+MOREShadow.h"
#import "UIView+MOREStackLayoutView.h"
#import "GGAnimationSunrise.h"

#import "CRLabelView.h"
#import "CRTextFieldView.h"
#import "CRButtonView.h"
#import "CRTextView.h"
#import "TimeTalkerBird.h"

#import "CRClassScheduleAddViewController.h"
#import "CRTransitionAnimationObject.h"
#import "CRTimeOptionsViewController.h"
#import "CRTimeOptionViewController.h"
#import "CRTextFieldViewController.h"
#import "MOREColorPickerView.h"

@interface CRClassScheduleEditModel()<UIScrollViewDelegate, UITextFieldDelegate, CRColorPickerHandler, CRTextFieldVCHandler, CRTimeOptionsVCHandler, CRTimeOptionVCHandler>

@property( nonatomic, strong ) CRTransitionAnimationObject *transitionObject;

@property( nonatomic, strong ) GGAnimationSunrise *sun;
@property( nonatomic, strong ) UIColor *targetColor;
@property( nonatomic, strong ) UIView *park;
@property( nonatomic, strong ) UILabel *parkTitle;
@property( nonatomic, strong ) UIButton *dismissButton;

@property( nonatomic, strong ) UIScrollView *bear;
@property( nonatomic, strong ) NSLayoutConstraint *bearBottomLayoutGuide;
@property( nonatomic, strong ) CRTextFieldView *classname;
@property( nonatomic, strong ) CRButtonView *timeStart;
@property( nonatomic, strong ) CRButtonView *location;
@property( nonatomic, strong ) CRTextFieldView *teacher;
@property( nonatomic, strong ) CRButtonView *weekday;
@property( nonatomic, strong ) CRButtonView *timeLong;
@property( nonatomic, strong ) CRButtonView *colorType;
@property( nonatomic, strong ) CRTextView *userInfo;

@end

@implementation CRClassScheduleEditModel

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.transitionObject = [CRTransitionAnimationObject defaultCRTransitionAnimation];
    self.sun = [[GGAnimationSunrise alloc] initWithType:GGAnimationSunriseTypeSerial
                                      blockOnCompletion:^(GGAnimationSunriseType type){
                                          self.park.backgroundColor = self.targetColor;
                                      }];
    
    [self makeBear];
    [self makePark];
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"will appear");
    self.timeStart.textLabel.text = self.classSchedule.timeStart;
    self.location.textLabel.text = self.classSchedule.location;
    self.classname.text = self.classSchedule.classname;
    self.teacher.placeholder = self.classSchedule.teacher;
    self.teacher.tintColor = [UIColor CRColorType:CRColorTypeGoogleMapBlue];
    self.weekday.textLabel.text = self.classSchedule.weekday;
    self.timeLong.textLabel.text = self.classSchedule.timeLong;
    self.colorType.icon.textColor = self.park.backgroundColor;
    self.colorType.textLabel.text = self.classSchedule.colorType;
    self.userInfo.textView.text = self.classSchedule.userInfo;
}

- (void)makePark{
    self.park = ({
        UIView *park = [UIView new];
        park.translatesAutoresizingMaskIntoConstraints = NO;
        park.backgroundColor = [UIColor CRColorType:CRColorTypeGoogleYellow];
        [park makeShadowWithSize:CGSizeMake(0, 1) opacity:0 radius:1.7];
        park;
    });
    
    self.parkTitle = ({
        UILabel *parkTitle = [UILabel new];
        parkTitle.translatesAutoresizingMaskIntoConstraints = NO;
        parkTitle.text = @"New Class";
        parkTitle.textColor = [UIColor whiteColor];
        parkTitle.font = [CRSettings appFontOfSize:21 weight:UIFontWeightMedium];
        parkTitle;
    });
    
    self.dismissButton = ({
        UIButton *dismiss = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, 56, 56)];
        dismiss.layer.cornerRadius = 56.0f / 2.0f;
        dismiss.tag = 1000;
        dismiss.titleLabel.font = [UIFont MaterialDesignIcons];
        [dismiss setTitle:[UIFont mdiArrowLeft] forState:UIControlStateNormal];
        [dismiss setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [dismiss addTarget:self.parentViewController action:@selector(perferItem:) forControlEvents:UIControlEventTouchUpInside];
        dismiss;
    });
    
    [self.view addSubview:self.park];
    [CRLayout view:@[ self.park, self.view ] type:CREdgeTopLeftRight];
    [CRLayout view:@[ self.park ] type:CRFixedHeight constants:UIEdgeInsetsMake(0, STATUS_BAR_HEIGHT + 56, 0, 0)];
    
    [self.park addSubview:self.dismissButton];
    [self.park addSubview:self.parkTitle];
    
    [CRLayout view:@[ self.parkTitle, self.park ] type:CREdgeAround constants:UIEdgeInsetsMake(STATUS_BAR_HEIGHT, 72, 0, -16)];
}

- (void)makeBear{
    
    self.bear = ({
        UIScrollView *bear = [UIScrollView new];
        bear.translatesAutoresizingMaskIntoConstraints = NO;
        bear.showsHorizontalScrollIndicator = NO;
        bear.showsVerticalScrollIndicator = NO;
        bear.delegate = self;
        bear;
    });
    [self.view addSubview:self.bear];
    [CRLayout view:@[ self.bear, self.view ] type:CREdgeTopLeftRight];
    self.bearBottomLayoutGuide = [NSLayoutConstraint constraintWithItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.bear
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:0];
    [self.view addConstraint:self.bearBottomLayoutGuide];
    
    self.classname = ({
        CRTextFieldView *classname = [[CRTextFieldView alloc] initWithoutIcon];
        classname.placeholder = @"Class name";
        classname;
    });
    
    self.timeStart = ({
        CRButtonView *timeStart = [CRButtonView new];
        timeStart.icon.text = [UIFont mdiBell];
        [timeStart addTarget:self action:@selector(CRTimeOptionsViewController) forControlEvents:UIControlEventTouchUpInside];
        timeStart;
    });
    
    self.location = ({
        CRButtonView *location = [CRButtonView new];
        location.icon.text = [UIFont mdiMapMarker];
        [location addTarget:self action:@selector(CRTextFieldViewController) forControlEvents:UIControlEventTouchUpInside];
        location;
    });
    
    self.teacher = ({
        CRTextFieldView *teacher = [CRTextFieldView new];
        teacher.delegate = self;
        teacher.icon.text = [UIFont mdiAccount];
        teacher;
    });
    
    self.weekday = ({
        CRButtonView *weekday = [CRButtonView new];
        weekday.icon.text = [UIFont mdiCalendar];
        [weekday addTarget:self action:@selector(CRWeekdayViewController) forControlEvents:UIControlEventTouchUpInside];
        weekday;
    });
    
    self.timeLong = ({
        CRButtonView *timeLong = [CRButtonView new];
        timeLong.icon.text = [UIFont mdiClock];
        [timeLong addTarget:self action:@selector(CRTimeOptionViewController) forControlEvents:UIControlEventTouchUpInside];
        timeLong;
    });
    
    self.colorType = ({
        CRButtonView *colorType = [CRButtonView new];
        colorType.icon.text = [UIFont mdiCheckboxBlankCircle];
        [colorType addTarget:self action:@selector(CRColorPickerViewController) forControlEvents:UIControlEventTouchUpInside];
        colorType;
    });
    
    self.userInfo = ({
        CRTextView *userInfo = [CRTextView new];
        userInfo.icon.text = [UIFont mdiPencil];
//        userInfo.textView.delegate = self;
        userInfo.textView.font = [CRSettings appFontOfSize:17];
        userInfo.textView.textColor = [UIColor colorWithWhite:117 / 255.0 alpha:1];
        userInfo;
    });
    
    UIView *edgeBottom = ({
        UIView *edge = [UIView new];
        edge.backgroundColor = [UIColor clearColor];
        edge;
    });
    
    [self.bear autolayoutSubviews:@[ self.classname, self.timeStart, self.location, self.teacher, self.weekday, self.timeLong, self.colorType, self.userInfo, edgeBottom ]
                       edgeInsets:UIEdgeInsetsMake(STATUS_BAR_HEIGHT + 56, 0, 0, 0)
                       multiplier:1.0
                         constant:0
                        constants:@[ @64, @64, @64, @64, @64, @64, @64, @192, @52 ]
                 stackOrientation:autolayoutStackOrientationVertical
                        direction:autolayoutStackDirectionTop
                           option:autolayoutStackOptionTrailing];
}

- (void)CRTimeOptionsViewController{
    CRTimeOptionsViewController *timeOptions = [CRTimeOptionsViewController shareTimeOptions];
    timeOptions.transitioningDelegate = self.transitionObject;
    timeOptions.curTimeString = self.classSchedule.timeStart;
    timeOptions.handler = self;
    [self presentViewController:timeOptions animated:YES completion:nil];
}
- (void)CRTimeOptionsVCDidDismissWithOption:(NSString *)option{
    self.classSchedule.timeStart = option;
}

- (void)CRTimeOptionViewController{
    
    NSDictionary *timeMap = @{
                              @"5 mins": @0,
                              @"10 mins": @1,
                              @"15 mins": @2,
                              @"20 mins": @3,
                              @"25 mins": @4,
                              @"30 mins": @5,
                              @"35 mins": @6,
                              @"40 mins": @7,
                              @"45 mins": @8,
                              @"50 mins": @9,
                              @"55 mins": @10,
                              @"1 hour": @11,
                              @"1 hour 10 mins": @12,
                              @"1 hour 20 mins": @13,
                              @"1 hour 30 mins": @14,
                              @"1 hour 40 mins": @15,
                              @"1 hour 50 mins": @16,
                              @"2 hours": @17,
                              @"2 hours 30 mins": @18,
                              @"3 hours": @19,
                              };
    
    NSString *minString = self.timeLong.textLabel.text;
    CRTimeOptionViewController *timeOption = ({
        CRTimeOptionViewController *timeOption  = [CRTimeOptionViewController new];
        timeOption.transitioningDelegate = self.transitionObject;
        timeOption.handler = self;
        timeOption.type = CRTimeOptionTypeClassmins;
        timeOption.mins = timeMap[ minString ] ? [timeMap[ minString ] integerValue] : 0;
        timeOption;
    });
    
    [self presentViewController:timeOption animated:YES completion:nil];
}

- (void)CRWeekdayViewController{
    
    CRTimeOptionViewController *weekdayOption = ({
        CRTimeOptionViewController *weekdayOption = [CRTimeOptionViewController new];
        weekdayOption.transitioningDelegate = self.transitionObject;
        weekdayOption.handler = self;
        weekdayOption.weekday = [CRSettings weekdayFromString:self.weekday.textLabel.text];
        weekdayOption.type = CRTimeOptionTypeWeekday;
        weekdayOption;
    });
    
    [self presentViewController:weekdayOption animated:YES completion:nil];
}
- (void)CRTimeOptionVCDidDismissWithType:(CRTimeOptionType)type option:(NSString *)option{
    
}

- (void)CRTextFieldViewController{
    
    CRTextFieldViewController *textField = ({
        CRTextFieldViewController *textField = [CRTextFieldViewController new];
        textField.transitioningDelegate = self.transitionObject;
        textField.handler = self;
        textField;
    });
    
    [self presentViewController:textField animated:YES completion:nil];
}
- (void)CRTextFieldVCDidDismiss:(NSString *)textFieldString{
    
}
- (BOOL)CRTextFieldVCShouldReturn:(UIViewController *)viewController{
    return YES;
}

- (void)CRColorPickerViewController{
    MOREColorPickerView *colorPicker = ({
        MOREColorPickerView *picker = [MOREColorPickerView new];
        picker.transitioningDelegate = self.transitionObject;
        picker.curString = self.classSchedule.colorType;
        picker.handler = self;
        picker;
    });
    
    [self presentViewController:colorPicker animated:YES completion:nil];
}
- (void)CRColorPickerDidDismissHandler:(UIColor *)color name:(NSString *)name{
    self.classSchedule.colorType = self.colorType.textLabel.text = name;
    self.targetColor = self.colorType.icon.textColor = color;
    [self.sun sunriseAtLand:self.park
                   location:CGPointMake(self.park.frame.size.width / 2.0, (STATUS_BAR_HEIGHT + 56) / 2.0f)
                 lightColor:color];
}

@end
