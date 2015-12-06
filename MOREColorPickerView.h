//
//  MOREColorPickerView.h
//  MOREAmazing
//
//  Created by caine on 11/12/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CRColorPickerHandler <NSObject>

- (void)CRColorPickerDidDismissHandler:(UIColor *)color name:(NSString *)name;

@end

@interface MOREColorPickerView : UIViewController

@property( nonatomic, weak ) id<CRColorPickerHandler> handler;
@property( nonatomic, strong ) NSString *curString;

+ (instancetype)shareColorPicker;
+ (NSDictionary *)CRColorTypes;

@end
