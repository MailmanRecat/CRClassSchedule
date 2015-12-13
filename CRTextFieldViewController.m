//
//  CRTextFieldViewController.m
//  CRClassSchedule
//
//  Created by caine on 12/2/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height

#import "CRTextFieldViewController.h"
#import "UIView+MOREShadow.h"
#import "UIView+MOREStackLayoutView.h"
#import "UIFont+MaterialDesignIcons.h"
#import "UIColor+Theme.h"
#import "CRSettings.h"
#import "HuskyButton.h"
#import "UIColor+CRColor.h"

@interface CRTextFieldViewController ()<UITextFieldDelegate>

@property( nonatomic, strong ) UIView *park;
@property( nonatomic, strong ) UIButton *parkLeftButton;
@property( nonatomic, strong ) UITextField *parkTextField;

@property( nonatomic, strong ) UIView *keyboardView;

@end

@implementation CRTextFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self doPark];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willKeyboardShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    self.parkTextField.placeholder = self.placeholderString;
    self.parkTextField.tintColor = self.tintColor;
    self.parkTextField.returnKeyType = self.returnKeyType;
}

- (void)viewDidAppear:(BOOL)animated{
    [self.parkTextField becomeFirstResponder];
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
                                                       }];
}

- (void)doPark{
    
    CGFloat parkHeight = 48;
    
    self.park = ({
        UIView *park = [UIView new];
        park.translatesAutoresizingMaskIntoConstraints = NO;
        park.backgroundColor = [UIColor whiteColor];
        park.layer.cornerRadius = 3.0f;
        [park makeShadowWithSize:CGSizeMake(0, 1) opacity:0.17 radius:1.7];
        park;
    });
    [self.view addSubview:self.park];
    
    self.parkLeftButton = ({
        UIButton *dismiss = [UIButton new];
        dismiss.translatesAutoresizingMaskIntoConstraints = NO;
        dismiss.layer.cornerRadius = parkHeight / 2.0f;
        dismiss.titleLabel.font = [UIFont MaterialDesignIconsWithSize:21];
        [dismiss setTitle:[UIFont mdiArrowLeft] forState:UIControlStateNormal];
        [dismiss setTitleColor:[UIColor colorWithWhite:137 / 255.0 alpha:1] forState:UIControlStateNormal];
        [dismiss addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
        dismiss;
    });
    [self.park addSubview:self.parkLeftButton];
    
    self.parkTextField = ({
        UITextField *textField = [UITextField new];
        textField.translatesAutoresizingMaskIntoConstraints = NO;
        textField.delegate = self;
        textField;
    });
    [self.park addSubview:self.parkTextField];
    
    [CRLayout view:@[ self.park, self.view ] type:CREdgeTopLeftRight constants:UIEdgeInsetsMake(STATUS_BAR_HEIGHT + 8, 8, 0, -8)];
    [CRLayout view:@[ self.park ] type:CRFixedHeight constants:UIEdgeInsetsMake(0, parkHeight, 0, 0)];
    [CRLayout view:@[ self.parkLeftButton, self.park ] type:CREdgeTopLeftBottom constants:UIEdgeInsetsMake(0, 0, 0, 0)];
    [CRLayout view:@[ self.parkLeftButton ] type:CRFixedWidth constants:UIEdgeInsetsMake(parkHeight, 0, 0, 0)];
    [CRLayout view:@[ self.parkTextField, self.park ] type:CREdgeAround constants:UIEdgeInsetsMake(0, parkHeight, 0, 0)];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
//    if( self.handler && [self.handler respondsToSelector:@selector(CRTextFieldVCShouldReturn:)] ){
//        BOOL step = [self.handler CRTextFieldVCShouldReturn:self];
//        if( step ){
//            [self dismissSelf];
//            return YES;
//        }
//    }else{
//        [self dismissSelf];
//        return YES;
//    }
    
    [textField resignFirstResponder];
    [self dismissSelf];
    
    return YES;
}

- (void)willKeyboardShow{
    
    if( self.keyboardView == nil ){
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dismissSelf{
    [self dismissViewControllerAnimated:YES completion:^{
        if( self.handler && [self.handler respondsToSelector:@selector(CRTextFieldVCDidDismiss:)] )
            [self.handler CRTextFieldVCDidDismiss:self.parkTextField.text];
    }];
}

@end
