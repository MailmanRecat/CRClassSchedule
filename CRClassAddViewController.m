//
//  CRClassAddViewController.m
//  CRClassSchedule
//
//  Created by caine on 12/1/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRClassAddViewController.h"
#import "UIView+CRLayout.h"
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

#import "CRTransitionAnimationObject.h"
#import "CRClassViewController.h"
#import "CRTimeOptionsViewController.h"
#import "CRTimeOptionViewController.h"
#import "CRTextFieldViewController.h"
#import "MOREColorPickerView.h"

@interface CRClassAddViewController()<UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate, CRColorPickerHandler, CRTextFieldVCHandler, CRTimeOptionsVCHandler, CRTimeOptionVCHandler>

@property( nonatomic, strong ) CRTransitionAnimationObject *transitionObject;

@property( nonatomic, strong ) UIView *park;
@property( nonatomic, strong ) UILabel *parkTitle;
@property( nonatomic, strong ) HuskyButton *dismissButton;
@property( nonatomic, strong ) HuskyButton *floatButton;
@property( nonatomic, strong ) NSLayoutConstraint *parkLayoutHeightGuide;
@property( nonatomic, strong ) NSLayoutConstraint *parkLayoutTitleGuide;

@property( nonatomic, strong ) UIView *bottomBear;
@property( nonatomic, strong ) NSLayoutConstraint *bottomBearLayoutGuide;
@property( nonatomic, strong ) UIButton *saveButton;
@property( nonatomic, strong ) UIButton *deleteButton;

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

@property( nonatomic, strong ) GGAnimationSunrise *sun;

@property( nonatomic, strong ) UIColor *testColor;
@property( nonatomic, assign ) BOOL shouldRender;

@end

@implementation CRClassAddViewController

- (instancetype)initFromClassSchedule:(CRClassSchedule *)classSchedule viewModel:(CRViewModel)model{
    self = [super init];
    if( self ){
        self.classSchedule = classSchedule;
        self.model = model;
    }
    return self;
}

+ (instancetype)shareFromClassSchedule:(CRClassSchedule *)classSchedule ViewModel:(CRViewModel)model{
    static CRClassAddViewController *instanceVC = nil;
    if( instanceVC ){
        instanceVC.classSchedule = classSchedule;
        instanceVC.model = model;
        return instanceVC;
    }
    
    static dispatch_once_t instanceVCMaker;
    dispatch_once(&instanceVCMaker, ^{
        instanceVC = [[CRClassAddViewController alloc] initFromClassSchedule:classSchedule viewModel:model];
    });
    return instanceVC;
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
        instanceVC = [[CRClassAddViewController alloc] initFromClassSchedule:classSchedule viewModel:CRViewModelDefault];
    });
    return instanceVC;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.sun = [[GGAnimationSunrise alloc] initWithType:GGAnimationSunriseTypeConcurrent blockOnCompletion:^(GGAnimationSunriseType type){
        self.park.backgroundColor = self.testColor;
    }];
    self.sun.duration = 0.57f;
    self.transitionObject = [CRTransitionAnimationObject defaultCRTransitionAnimation];
    
    [self doBear];
    [self doBearController];
    [self doPark];
    [self doBottomBear];
    
    if( self.model == CRViewModelDefault ){
        
    }
    
    [self addNotificationObserver];
}

-(NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    
    UIPreviewAction *deleteAction = [UIPreviewAction actionWithTitle:@"Delete" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewController) {
        
        if( self.previewActionHandler && [self.previewActionHandler respondsToSelector:@selector(CRClassAddPreviewAction:fromController:)] ){
            [self.previewActionHandler CRClassAddPreviewAction:action.title fromController:previewController];
        }
        
    }];
    
    UIPreviewAction *cancel = [UIPreviewAction actionWithTitle:@"Cancel" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewController){
        
        if( self.previewActionHandler && [self.previewActionHandler respondsToSelector:@selector(CRClassAddPreviewAction:fromController:)] ){
            [self.previewActionHandler CRClassAddPreviewAction:action.title fromController:previewController];
        }
    }];
    
    UIPreviewActionGroup *delete = [UIPreviewActionGroup actionGroupWithTitle:@"Delete" style:UIPreviewActionStyleDestructive actions:@[ deleteAction, cancel ]];
    
    UIPreviewAction *editAction = [UIPreviewAction actionWithTitle:@"Edit Class" style:UIPreviewActionStyleDefault handler:^( UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewController ){
        
        if( self.previewActionHandler && [self.previewActionHandler respondsToSelector:@selector(CRClassAddPreviewAction:fromController:)] ){
            [self.previewActionHandler CRClassAddPreviewAction:action.title fromController:previewController];
        }
    }];
    
    return @[ editAction, delete ];
}

- (void)viewWillAppear:(BOOL)animated{
    if( self.isPreview ){
        
    }else{
        
    }
    
    if( self.isBeingPresented ){
        self.park.backgroundColor = [CRSettings CRAppColorTypes][[self.classSchedule.colorType lowercaseString]];
        [self.saveButton setTitleColor:[CRSettings CRAppColorTypes][[self.classSchedule.colorType lowercaseString]] forState:UIControlStateNormal];
        
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
}

- (void)showDismissButton{
    self.dismissButton.alpha = 1;
}

- (void)addNotificationObserver{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];

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
                   location:CGPointMake(self.view.frame.size.width / 2.0f, (STATUS_BAR_HEIGHT + 56) / 2.0f)
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
//    self.timeStart.strong.text = option;
    self.classSchedule.timeStart = option;
}


- (void)layoutSaveButtonDuration:(CGFloat)duration options:(UIViewAnimationOptions)options constant:(CGFloat)constant{
    self.bottomBearLayoutGuide.constant = constant;
    self.bearBottomLayoutGuide.constant = constant;
    
    if( [self.userInfo.textView isFirstResponder] ){
        [self.saveButton setTitle:@"Done" forState:UIControlStateNormal];
        [UIView animateWithDuration:duration
                         animations:^{
                             self.bear.contentOffset = CGPointMake(0, self.userInfo.frame.origin.y - STATUS_BAR_HEIGHT - 56 - 72);
                         }];
    }
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:options
                     animations:^{
                         [self.view layoutIfNeeded];
                     }completion:^( BOOL isFinished ){
//                         if( [self.userInfo.textView isFirstResponder] ){
//                             [self.saveButton setTitle:@"Done" forState:UIControlStateNormal];
//                             [UIView animateWithDuration:duration
//                                              animations:^{
//                                                  self.bear.contentOffset = CGPointMake(0, self.userInfo.frame.origin.y - STATUS_BAR_HEIGHT - 56 - 72);
//                                              }];
//                         }
                     }];
}

- (void)willKeyBoardChangeFrame:(NSNotification *)keyboardInfo{
    NSDictionary *info = [keyboardInfo userInfo];
    CGFloat constant = self.view.frame.size.height - [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    CGFloat duration = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationOptions option = [info[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [self layoutSaveButtonDuration:duration options:option constant:constant];
}

- (void)parkSunset{
    self.park.layer.shadowOpacity = 0.27;
}

- (void)parkSunrise{
    self.park.layer.shadowOpacity = 0;
}

- (void)doPark{
    
    self.park = ({
        UIView *park = [UIView new];
        park.translatesAutoresizingMaskIntoConstraints = NO;
        [park makeShadowWithSize:CGSizeMake(0, 1) opacity:0 radius:1.7];
        park;
    });
    
    self.parkTitle = ({
        UILabel *parkTitle = [UILabel new];
        parkTitle.text = @"New Class";
        parkTitle.textColor = [UIColor whiteColor];
        parkTitle.font = [CRSettings appFontOfSize:21 weight:UIFontWeightMedium];
        parkTitle;
    });
    
    self.dismissButton = ({
        HuskyButton *dismiss = [[HuskyButton alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, 56, 56)];
        dismiss.layer.cornerRadius = 56.0f / 2.0f;
        dismiss.titleLabel.font = [UIFont MaterialDesignIcons];
        [dismiss setTitle:[UIFont mdiClose] forState:UIControlStateNormal];
        [dismiss setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [dismiss addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
        dismiss;
    });
    
    self.floatButton = ({
        HuskyButton *floatButton = [HuskyButton new];
        floatButton.layer.cornerRadius = 40 / 2.0f;
        floatButton.backgroundColor = [UIColor CRColorType:CRColorTypeGoogleTomato];
        floatButton.titleLabel.font = [UIFont MaterialDesignIcons];
        [floatButton setTitle:[UIFont mdiPencil] forState:UIControlStateNormal];
        [floatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [floatButton makeShadowWithSize:CGSizeMake(0.0f, 6.0f) opacity:0.47f radius:3.7f];
        floatButton;
    });
    
    [self.view addSubview:self.park];
    [CRLayout view:@[ self.park, self.view ] type:CREdgeTopLeftRight];
    self.parkLayoutHeightGuide = [NSLayoutConstraint constraintWithItem:self.park
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:STATUS_BAR_HEIGHT + 56];
    [self.park addConstraint:self.parkLayoutHeightGuide];
    
    [self.park addSubview:self.dismissButton];
    [self.park addAutolayoutSubviews:@[ self.floatButton, self.parkTitle ]];
    
    [CRLayout view:@[ self.floatButton, self.park ] type:CREdgeBottomLeft constants:UIEdgeInsetsMake(0, 16, 20, 0)];
    [CRLayout view:@[ self.floatButton ] type:CRFixedEqual constants:UIEdgeInsetsMake(40, 40, 0, 0)];
    [CRLayout view:@[ self.parkTitle, self.park ] type:CREdgeBottomLeftRight constants:UIEdgeInsetsMake(0, 72, 0, -16)];
    [CRLayout view:@[ self.parkTitle ] type:CRFixedHeight constants:UIEdgeInsetsMake(0, 56, 0, 0)];
}

- (void)editModelWithAnimation:(BOOL)animation{
    self.parkLayoutHeightGuide.constant = STATUS_BAR_HEIGHT + 56 + 72;
    self.parkLayoutTitleGuide.constant = 72;
    
    CRClassViewController *class = [CRClassViewController new];
    class.classSchedule = self.classSchedule;
    
    [self addChildViewController:class];
    [self.view insertSubview:class.view belowSubview:self.park];
    
    self.parkTitle.text = self.classSchedule.classname;
    self.bear.hidden = YES;
    if( animation ){
        class.view.alpha = 0;
        class.view.frame = CGRectMake(0, 72, self.view.frame.size.width, self.view.frame.size.height);
        [UIView animateWithDuration:0.25f
                         animations:^{
                             self.floatButton.transform = CGAffineTransformMakeScale(1, 1);
                             class.view.alpha = 1;
                             class.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                             [self.park layoutIfNeeded];
                         }completion:nil];
    }else{
        [self.park layoutIfNeeded];
    }
}

- (void)viewModelWithAnimation:(BOOL)animation{
    self.parkLayoutHeightGuide.constant = STATUS_BAR_HEIGHT + 56;
    self.parkLayoutTitleGuide.constant = 56;
    
    CRClassViewController *class = self.childViewControllers.firstObject;
    
    self.parkTitle.text = @"New class event";
    self.bear.hidden = NO;
    if( animation ){
        class.view.alpha = 1;
        class.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [UIView animateWithDuration:0.25f
                         animations:^{
                             self.floatButton.transform = CGAffineTransformMakeScale(0, 0);
                             class.view.alpha = 0;
                             class.view.frame = CGRectMake(0, 72, self.view.frame.size.width, self.view.frame.size.height);
                             [self.park layoutIfNeeded];
                         }completion:^( BOOL isFinished ){
                             if( isFinished ){
                                 [class.view removeFromSuperview];
                                 [class removeFromParentViewController];
                             }
                         }];
    }else{
        [self.park layoutIfNeeded];
        [class.view removeFromSuperview];
        [class removeFromParentViewController];
    }
}

- (void)doBottomBear{
    
    self.bottomBear = ({
        UIView *bottomBear = [UIView new];
        bottomBear.translatesAutoresizingMaskIntoConstraints = NO;
        bottomBear.backgroundColor = [UIColor whiteColor];
        [bottomBear makeShadowWithSize:CGSizeMake(0, -1) opacity:0.17 radius:1.7];
        bottomBear;
    });
    
    self.saveButton = ({
        UIButton *save = [UIButton new];
        save.backgroundColor = [UIColor clearColor];
        save.titleLabel.font = [CRSettings appFontOfSize:17 weight:UIFontWeightMedium];
        [save setTitle:@"Save" forState:UIControlStateNormal];
        [save setTitleColor:[CRSettings CRAppColorTypes][[self.classSchedule.colorType lowercaseString]] forState:UIControlStateNormal];
        [save addTarget:self action:@selector(CRSaveClass) forControlEvents:UIControlEventTouchUpInside];
        save;
    });
    
    self.deleteButton = ({
        UIButton *delete = [UIButton new];
        delete.backgroundColor = [UIColor clearColor];
        delete.titleLabel.font = [CRSettings appFontOfSize:17 weight:UIFontWeightMedium];
        [delete setTitle:@"Delete" forState:UIControlStateNormal];
        [delete setTitleColor:[UIColor CRColorType:CRColorTypeGoogleTomato] forState:UIControlStateNormal];
        [delete addTarget:self action:@selector(CRSaveClass) forControlEvents:UIControlEventTouchUpInside];
        delete;
    });
    
    [self.view addSubview:self.bottomBear];
    [self.bottomBear addAutolayoutSubviews:@[ self.saveButton, self.deleteButton ]];
    
    [CRLayout view:@[ self.bottomBear, self.view ] type:CREdgeLeftRight];
    [CRLayout view:@[ self.bottomBear ] type:CRFixedHeight constants:UIEdgeInsetsMake(0, 52, 0, 0)];
    self.bottomBearLayoutGuide = [NSLayoutConstraint constraintWithItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.bottomBear
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:0];
    [self.view addConstraint:self.bottomBearLayoutGuide];
    
    [CRLayout view:@[ self.saveButton, self.bottomBear ] type:CREdgeTopRightBottom constants:UIEdgeInsetsMake(8, 0, 8, -8)];
    [CRLayout view:@[ self.saveButton ] type:CRFixedWidth constants:UIEdgeInsetsMake(72, 0, 0, 0)];
    [CRLayout view:@[ self.deleteButton, self.bottomBear ] type:CREdgeTopLeftBottom constants:UIEdgeInsetsMake(8, 8, 8, 0)];
    [CRLayout view:@[ self.deleteButton ] type:CRFixedWidth constants:UIEdgeInsetsMake(72, 0, 0, 0)];
}

- (void)doBear{
    
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
        userInfo.textView.delegate = self;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if( scrollView.contentOffset.y > 0 )
        [self parkSunset];
    else
        [self parkSunrise];
}

- (void)doBearController{
//    CRClassViewController *class = [CRClassViewController new];
//    class.classSchedule = self.classSchedule;
//    [self addChildViewController:class];
//    [self.view addSubview:class.view];
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
    timeOptions.transitioningDelegate = self.transitionObject;
    timeOptions.curTimeString = self.classSchedule.timeStart;
    timeOptions.handler = self;
    [self presentViewController:timeOptions animated:YES completion:nil];
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

- (void)CRTextFieldViewController{
    CRTextFieldViewController *textField = [CRTextFieldViewController new];
    textField.transitioningDelegate = self.transitionObject;
    textField.handler = self;
    [self presentViewController:textField animated:YES completion:nil];
}

- (void)CRColorPickerViewController{
    MOREColorPickerView *colorPicker = [MOREColorPickerView shareColorPicker];
    colorPicker.transitioningDelegate = self.transitionObject;
    colorPicker.curString = self.classSchedule.colorType;
    colorPicker.handler = self;
    [self presentViewController:colorPicker animated:YES completion:nil];
}

- (void)CRSaveClass{
    
    [self editModelWithAnimation:YES];
    
    if( [self.userInfo.textView isFirstResponder] ){
        [self.userInfo.textView resignFirstResponder];
    }
    
    self.classSchedule.userInfo = self.userInfo.textView.text;
    self.classSchedule.teacher = self.teacher.text;
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
    [self viewModelWithAnimation:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
