//
//  CRClassScheduleAddViewController.m
//  CRClassSchedule
//
//  Created by caine on 12/11/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRClassScheduleAddViewController.h"
#import "CRSettings.h"
#import "CRClassDatabase.h"
#import "UIColor+CRColor.h"
#import "UIView+MOREShadow.h"
#import "UIView+MOREStackLayoutView.h"

#import "CRClassScheduleViewModel.h"
#import "CRClassScheduleEditModel.h"

@interface CRClassScheduleAddViewController()

@property( nonatomic, assign ) NSUInteger currentIndex;

@property( nonatomic, strong ) UIView *toolBar;
@property( nonatomic, strong ) NSLayoutConstraint *toolBarLayoutGuide;
@property( nonatomic, strong ) UIButton *leftButton;
@property( nonatomic, strong ) UIButton *rightButton;

@property( nonatomic, strong ) NSArray<UIViewController *> *items;

@end

@implementation CRClassScheduleAddViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CRClassScheduleViewModel *viewModel = ({
        CRClassScheduleViewModel *view = [CRClassScheduleViewModel new];
        view.classSchedule = self.classSchedule;
        view;
    });
    
    CRClassScheduleEditModel *editModel = ({
        CRClassScheduleEditModel *edit = [CRClassScheduleEditModel new];
        edit.classSchedule = self.classSchedule;
        edit;
    });
    
    self.items = @[ viewModel, editModel ];
    
    [self addChildViewController:viewModel];
    [self addChildViewController:editModel];
    
    if( self.type == 1 ){
        [self.view addSubview:editModel.view];
        self.currentIndex = 1;
        editModel.title = @"New Class";
    }else{
        [self.view addSubview:viewModel.view];
        self.currentIndex = 0;
        editModel.title = @"Edit Class";
    }
    
    [self makeToolBar];
    [self addNotificationObserver];
}

- (void)viewWillAppear:(BOOL)animated{
    [self perferRightButtonColor:[CRSettings CRAppColorTypes][[self.classSchedule.colorType lowercaseString]]];
    
    if( self.isPreview ){
        ((CRClassScheduleViewModel *)self.items[0]).dismissButton.hidden = YES;
        self.toolBar.hidden = YES;
    }else{
        ((CRClassScheduleViewModel *)self.items[0]).dismissButton.hidden = NO;
        self.toolBar.hidden = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated{}

- (void)addNotificationObserver{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(willKeyBoardChangeFrame:)
                   name:UIKeyboardWillChangeFrameNotification
                 object:nil];
}

- (void)willKeyBoardChangeFrame:(NSNotification *)keyboardInfo{
    NSDictionary *info = [keyboardInfo userInfo];
    CGFloat constant = self.view.frame.size.height - [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    CGFloat duration = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationOptions option = [info[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    if( constant != 0 ){
        [self.rightButton removeTarget:self action:@selector(perferItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightButton addTarget:self action:@selector(viewEndEdit) forControlEvents:UIControlEventTouchUpInside];
    }

    [(CRClassScheduleEditModel *)self.items[1] bearBottomLayout:constant];
    self.toolBarLayoutGuide.constant = -constant > 0 ? 0 : -constant;
    [self.rightButton setTitle:@"Done" forState:UIControlStateNormal];
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:option
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL isFinished){}];
}

- (void)viewEndEdit{
    [self.view endEditing:YES];
    [self.rightButton removeTarget:self action:@selector(viewEndEdit) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton addTarget:self action:@selector(perferItem:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setTitle:@"Save" forState:UIControlStateNormal];
}


- (void)perferRightButtonColor:(UIColor *)color{
    [self.rightButton setTitleColor:color forState:UIControlStateNormal];
}

- (void)scheduleSave{
    NSLog(@"%@", self.classSchedule.scheduleID);
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
    
    if( [self.classSchedule.scheduleID isEqualToString:ClassScheduleInvalidID] )
        [CRClassDatabase insertCRClassSchedule:self.classSchedule];
    else
        [CRClassDatabase updateCRClassSchedule:self.classSchedule];
}

- (void)perferItem:(UIButton *)sender{
    
    NSUInteger tag = sender.tag - 1000;
    
    if( tag == self.currentIndex ){
        if( [self.rightButton.titleLabel.text isEqualToString:@"Save"] ){
            tag = 0;
            [self scheduleSave];
            NSLog(@"Save");
        }else{
            return;
        }
    };
    
    if( tag == 0 ){
        self.leftButton.enabled = YES;
        [self.leftButton setTitleColor:[UIColor CRColorType:CRColorTypeGoogleTomato] forState:UIControlStateNormal];
        [self.rightButton setTitle:@"Edit" forState:UIControlStateNormal];
    }else{
        self.leftButton.enabled = NO;
        [self.leftButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [self.rightButton setTitle:@"Save" forState:UIControlStateNormal];
    }
    
    UIViewController *controller = self.items[tag];
    UIViewController *missController = self.items[self.currentIndex];
    [self.view insertSubview:controller.view belowSubview:self.toolBar];
    
    CGFloat fromPoint = tag == 0 ? -37 : 37;
    
    CABasicAnimation *animation;
    CABasicAnimation *opacityAnimation = ({
        animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation.fromValue = [NSNumber numberWithFloat:0.0f];
        animation.toValue = [NSNumber numberWithFloat:1.0f];
        animation;
    });
    
    CABasicAnimation *positionAnimation = ({
        animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
        animation.fromValue = [NSNumber numberWithFloat:self.view.frame.size.width / 2 + fromPoint];
        animation.toValue = [NSNumber numberWithFloat:self.view.frame.size.width / 2];
        animation;
    });
    
    CABasicAnimation *opacityReverseAnimation = ({
        CABasicAnimation *rAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        rAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
        rAnimation.toValue = [NSNumber numberWithFloat:0.0f];
        rAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.4 :0 :0.2 :1];
        rAnimation.duration = 0.27;
        rAnimation.removedOnCompletion = YES;
        rAnimation;
    });
    
    CAAnimationGroup *group = ({
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.animations = @[ opacityAnimation, positionAnimation ];
        group.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.4 :0 :0.2 :1];
        group.duration = 0.37f;
        group.delegate = self;
        group.removedOnCompletion = YES;
        group;
    });
    
    [controller.view.layer addAnimation:group forKey:@"changeViewController"];
//    [missController.view.layer addAnimation:opacityReverseAnimation forKey:@"missViewController"];
    self.currentIndex = tag;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if( flag ){
        [(UIView *)( self.currentIndex == 0 ? self.items[1].view : self.items[0].view ) removeFromSuperview];
    }
}

- (void)makeToolBar{
    UIButton *(^makeButton)(NSUInteger) = ^(NSUInteger tag){
        UIButton *button = [[UIButton alloc] init];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        button.tag = tag;
        button.titleLabel.font = [CRSettings appFontOfSize:17 weight:UIFontWeightBold];
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(perferItem:) forControlEvents:UIControlEventTouchUpInside];
        return button;
    };
    
    self.leftButton = makeButton( 1000 );
    self.rightButton = makeButton( 1001 );
    
    NSString *actionName = self.type == 1 ? @"Save" : @"Edit";
    UIColor *actionColor = self.type == 1 ? [UIColor clearColor] : [UIColor CRColorType:CRColorTypeGoogleTomato];
    
    [self.leftButton makeButtonTitle:@"Detele" titleColor:actionColor state:UIControlStateNormal];
    [self.rightButton makeButtonTitle:actionName titleColor:[UIColor CRColorType:CRColorTypeGoogleMapBlue] state:UIControlStateNormal];
    
    self.toolBar = ({
        UIView *toolBar = [[UIView alloc] init];
        toolBar.backgroundColor = [UIColor whiteColor];
        toolBar.translatesAutoresizingMaskIntoConstraints = NO;
        [toolBar makeShadowWithSize:CGSizeMake(0, -1) opacity:0.07 radius:3];
        toolBar;
    });
    
    [self.view addSubview:self.toolBar];
    [CRLayout view:@[ self.toolBar, self.view ] type:CREdgeLeftRight];
    [CRLayout view:@[ self.toolBar ] type:CRFixedHeight constants:UIEdgeInsetsMake(0, 52, 0, 0)];
    self.toolBarLayoutGuide = [NSLayoutConstraint constraintWithItem:self.toolBar
                                                       attribute:NSLayoutAttributeBottom
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:self.view
                                                       attribute:NSLayoutAttributeBottom
                                                      multiplier:1.0
                                                        constant:0];
    [self.view addConstraint:self.toolBarLayoutGuide];
    
    [self.toolBar addSubview:self.leftButton];
    [self.toolBar addSubview:self.rightButton];
    [CRLayout view:@[ self.leftButton, self.toolBar ] type:CREdgeTopLeftBottom constants:UIEdgeInsetsMake(8, 8, -8, 0)];
    [CRLayout view:@[ self.leftButton ] type:CRFixedWidth constants:UIEdgeInsetsMake(72, 0, 0, 0)];
    [CRLayout view:@[ self.rightButton, self.toolBar ] type:CREdgeTopRightBottom constants:UIEdgeInsetsMake(8, 0, -8, -8)];
    [CRLayout view:@[ self.rightButton ] type:CRFixedWidth constants:UIEdgeInsetsMake(72, 0, 0, 0)];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
