//
//  CRClassTableViewCell.h
//  CRClassSchedule
//
//  Created by caine on 12/1/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CRClassTableViewCellDelegate <NSObject>

- (void)CRClassTableViewCellSelectedHandler:(NSIndexPath *)indexPath;

@end

@interface CRClassTableViewCell : UITableViewCell

@property( nonatomic, weak ) id<CRClassTableViewCellDelegate> handler;
@property( nonatomic, strong ) NSIndexPath *indexPath;
@property( nonatomic, strong ) UILabel *startTime;
@property( nonatomic, strong ) UILabel *className;

@end
