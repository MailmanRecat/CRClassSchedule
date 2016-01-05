//
//  CATextLabel.m
//  CRClassSchedule
//
//  Created by caine on 1/5/16.
//  Copyright © 2016 com.caine. All rights reserved.
//

#import "CATextLabel.h"

@implementation CATextLabel

+ (CATextLayer *)labelFromRect:(CGRect)rect string:(NSString *)string font:(UIFont *)font{
    CGSize (^dirtySize)(NSString *, UIFont *) = ^(NSString *string, UIFont *font){
        return [string boundingRectWithSize:rect.size
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:@{
                                              NSFontAttributeName: font
                                              }
                                    context:nil].size;
    };
    
    CGSize dirty = dirtySize(string, font);
    
    CATextLayer *tl = [CATextLayer layer];
    tl.frame = CGRectMake(rect.origin.x, rect.origin.y, (NSUInteger)dirty.width + 1, (NSUInteger)dirty.height + 1);
    tl.alignmentMode = kCAAlignmentLeft;
    tl.wrapped = YES;
    tl.font = CGFontCreateWithFontName((__bridge CFStringRef)font.fontName);
    tl.fontSize = font.pointSize;
    tl.contentsScale = [UIScreen mainScreen].scale;
    
    tl.string = string;
    
    return tl;
}

@end
