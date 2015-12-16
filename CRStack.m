//
//  CRStack.m
//  CRClassSchedule
//
//  Created by caine on 12/14/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRStack.h"

@interface CRStack()

@property( nonatomic, strong ) NSMutableArray *stack;

@end

@implementation CRStack

- (instancetype)initWithArray:(NSArray *)array{
    self = [super init];
    if( self ){
        self.stack = [[NSMutableArray alloc] initWithArray:array];
    }
    return self;
}

+ (instancetype)FromArray:(NSArray *)array{
    return [[CRStack alloc] initWithArray:array];
}

- (NSUInteger)count{
    return [self.stack count];
}

- (void)addObject:(id)object{
    [self.stack addObject:object];
}

- (id)popObject{
    return [self.stack count] == 0 ? nil : ({
        id obj = self.stack.lastObject;
        [self.stack removeLastObject];
        obj;
    });
}

@end
