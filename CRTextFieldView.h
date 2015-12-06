//
//  CRTextFieldView.h
//  CRClassSchedule
//
//  Created by caine on 12/2/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRTextFieldView : UITextField

@property( nonatomic, strong ) UILabel *icon;

- (void)makeBorder:(BOOL)que;

@end
