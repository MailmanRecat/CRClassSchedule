//
//  CRClassTableViewCell.h
//  CRClassSchedule
//
//  Created by caine on 12/1/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const CRClassCellNoClassID = @"CRClassCellNoClassID";
static NSString *const CRClassCellMomentID = @"CRClassCellMonmentID";
static NSString *const CRClassCellDefaultID = @"CRClassCellDefaultID";
static NSString *const CRClassCellWhiteID = @"CRClassCellWhiteID";

@interface CRClassTableViewCell : UITableViewCell

@property( nonatomic, strong ) NSString *CRClassCellFrefixID;
@property( nonatomic, strong ) UIView *wrapper;
@property( nonatomic, strong ) UILabel *startTime;
@property( nonatomic, strong ) UILabel *className;
@property( nonatomic, strong ) UILabel *location;

- (instancetype)initFromNoClass;
- (instancetype)initFromMomentWithColor:(UIColor *)color;
- (instancetype)initFromDefault;
- (instancetype)initFromWhite;

- (instancetype)initFromColorTypeString:(NSString *)string;

- (void)setMomentColor:(UIColor *)color;

@end
