//
//  CRQueue.m
//  CRClassSchedule
//
//  Created by caine on 12/14/15.
//  Copyright © 2015 com.caine. All rights reserved.
//

#import "CRQueue.h"

@interface CRQueue()

@property( nonatomic, strong ) NSMutableArray *queue;

@end

@implementation CRQueue

- (instancetype)initWithArray:(NSArray *)array{
    self = [super init];
    if( self ){
        self.queue = [[NSMutableArray alloc] initWithArray:array];
    }
    return self;
}

+ (instancetype)FromArray:(NSArray *)array{
    return [[CRQueue alloc] initWithArray:array];
}

- (NSUInteger)count{
    return [self.queue count];
}

- (void)addObject:(id)object{
    [self.queue addObject:object];
}

- (id)popObject{
    return [self.queue count] == 0 ? nil : ({
        id obj = self.queue.firstObject;
        [self.queue removeObjectAtIndex:0];
        obj;
    });
}

@end
