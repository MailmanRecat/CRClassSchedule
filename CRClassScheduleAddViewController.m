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

#import "UIWindow+CRAction.h"
#import "CRClassScheduleViewModel.h"
#import "CRClassScheduleEditModel.h"

@interface CRClassScheduleAddViewController()<CRActionHandler>

@property( nonatomic, assign ) NSUInteger currentIndex;

@property( nonatomic, strong ) UIView *toolBar;
@property( nonatomic, strong ) NSLayoutConstraint *toolBarLayoutGuide;
@property( nonatomic, strong ) UIButton *leftButton;
@property( nonatomic, strong ) UIButton *rightButton;

@property( nonatomic, strong ) NSArray<UIViewController *> *items;

@end

@implementation CRClassScheduleAddViewController

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

- (void)actionConfrim:(NSString *)type{
    if( [type isEqualToString:@"Delete"] ){
        [CRClassDatabase deleteCRClassSchedule:self.classSchedule];
        [[NSNotificationCenter defaultCenter] postNotificationName:CRClassScheduleUpdatedNotification object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

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
    
    if( self.type == 1 ){
        self.leftButton.enabled = NO;
        self.leftButton.hidden = YES;
    }
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

- (void)viewDidAppear:(BOOL)animated{
    [self addNotificationObserver];
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

- (void)scheduleSave:(BOOL)dismiss{
    
    BOOL saved;
    if( [self.classSchedule.scheduleID isEqualToString:ClassScheduleInvalidID] )
        saved = [CRClassDatabase insertCRClassSchedule:self.classSchedule];
    else
        saved = [CRClassDatabase updateCRClassSchedule:self.classSchedule];
    
    if( saved && dismiss ){
        [self dismissViewControllerAnimated:YES completion:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CRClassScheduleUpdatedNotification object:nil];
    }
}

- (void)perferItem:(UIButton *)sender{
    
    NSUInteger tag = sender.tag - 1000;
    
    if( self.type == 1 ){
        
        if( tag == 1 )
            [self scheduleSave:YES];
        
        if( tag == 2 )
            [self dismissViewControllerAnimated:YES completion:nil];
        
        return;
        
    }else{
        
        if( tag == 0 ){
            [self.view.window actionDeleteWithHandler:self];
            return;
        }
        
        if( tag == 1 ){
            if( self.currentIndex == 1 ){
                [self scheduleSave:NO];
                [self pop];
                return;
            }else{
                [self push];
                return;
            }
        }
        
        if( tag == 2 ){
            [self pop];
        }
        
    }
}

- (void)push{
    if( self.currentIndex == 1 ) return;
    
    self.leftButton.enabled = NO;
    self.leftButton.hidden = YES;
    [self.rightButton setTitle:@"Save" forState:UIControlStateNormal];
    
    UIViewController *controller = self.items[1];
    [self.view insertSubview:controller.view belowSubview:self.toolBar];
    CGFloat fromPoint = 37;
    [controller.view.layer addAnimation:[self transitionAnimation:fromPoint] forKey:@"changeViewController"];
    
    self.currentIndex = 1;
}

- (void)pop{
    if( self.currentIndex == 0 ) return ;
    
    self.leftButton.enabled = YES;
    self.leftButton.hidden = NO;
    [self.rightButton setTitle:@"Edit" forState:UIControlStateNormal];
    
    CGFloat fromPoint = -37;
    UIViewController *controller = self.items[0];
    [self.view insertSubview:controller.view belowSubview:self.toolBar];
    [controller.view.layer addAnimation:[self transitionAnimation:fromPoint] forKey:@"changeViewController"];
    
    self.currentIndex = 0;
}

- (CAAnimationGroup *)transitionAnimation:(CGFloat)fromPoint{
    
    return ({
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
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.animations = @[ opacityAnimation, positionAnimation ];
        group.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.4 :0 :0.2 :1];
        group.duration = 0.37f;
        group.delegate = self;
        group.removedOnCompletion = YES;
        
        group;
    });
    
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
        button.titleLabel.font = [CRSettings appFontOfSize:17 weight:UIFontWeightRegular];
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
