//
//  CRClassScheduleAddViewController.m
//  CRClassSchedule
//
//  Created by caine on 12/11/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRClassScheduleAddViewController.h"
#import "CRSettings.h"
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
    [self.view addSubview:viewModel.view];
    self.currentIndex = 0;
    
    [self makeToolBar];
    
    [self addNotificationObserver];
}

- (void)viewDidAppear:(BOOL)animated{
    [self perferItem:({
        UIButton *test = [UIButton new];
        test.tag = 1001;
        test;
    })];
}

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
    
    self.toolBarLayoutGuide.constant = -constant;
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

- (void)perferItem:(UIButton *)sender{
    
    if( sender.tag - 1000 == self.currentIndex ) return;
    
    if( sender.tag == 1000 ){
        self.leftButton.enabled = YES;
        [self.leftButton setTitleColor:[UIColor CRColorType:CRColorTypeGoogleTomato] forState:UIControlStateNormal];
        [self.rightButton makeButtonTitle:@"Edit"
                               titleColor:[UIColor CRColorType:CRColorTypeGoogleYellow]
                                    state:UIControlStateNormal];
    }else{
        self.leftButton.enabled = NO;
        [self.leftButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [self.rightButton makeButtonTitle:@"Save"
                               titleColor:[UIColor CRColorType:CRColorTypeGoogleMapBlue]
                                    state:UIControlStateNormal];
    }
    
    UIViewController *controller = self.items[sender.tag - 1000];
    [self.view insertSubview:controller.view belowSubview:self.toolBar];
    
    controller.view.frame = self.view.bounds;
    CGFloat fromPoint = sender.tag == 1000 ? -57 : 57;
    
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
    self.currentIndex = sender.tag - 1000;
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
    
    [self.leftButton makeButtonTitle:@"Detele" titleColor:[UIColor CRColorType:CRColorTypeGoogleTomato] state:UIControlStateNormal];
    [self.rightButton makeButtonTitle:@"Edit" titleColor:[UIColor CRColorType:CRColorTypeGoogleMapBlue] state:UIControlStateNormal];
    
    self.toolBar = ({
        UIView *toolBar = [[UIView alloc] init];
        toolBar.backgroundColor = [UIColor whiteColor];
        toolBar.translatesAutoresizingMaskIntoConstraints = NO;
        [toolBar makeShadowWithSize:CGSizeMake(0, -1) opacity:0.27 radius:3];
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
