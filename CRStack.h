//
//  CRStack.h
//  CRClassSchedule
//
//  Created by caine on 12/14/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRStack : NSObject

+ (instancetype)FromArray:(NSArray *)array;

- (NSUInteger)count;
- (void)addObject:(id)object;
- (id)popObject;


@end
