//
//  CRApparentDiffView.h
//  CRClassSchedule
//
//  Created by caine on 1/5/16.
//  Copyright © 2016 com.caine. All rights reserved.
//

#define kCRApparentDiffViewHeight 142
#define kCRApparentDiffViewBorderHeight 8

#import <UIKit/UIKit.h>

@interface CRApparentDiffView : UIView

@property( nonatomic, strong ) NSLayoutConstraint *photowallLayoutGuide;

- (instancetype)initWithString:(NSString *)string font:(UIFont *)font photo:(UIImage *)photo;

+ (NSArray *)fetchHeaderViews;

@end
