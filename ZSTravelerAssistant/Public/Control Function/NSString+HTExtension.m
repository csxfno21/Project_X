//
//  NSString+HTExtension.m
//  HTEmotionView
//
//  Created by csxfno21 on 11/7/13.
//  Copyright (c) 2013 ly. All rights reserved.
//

#import "NSString+HTExtension.h"

@implementation NSString (HTExtension)

- (NSString *)replaceCharactersAtIndexes:(NSArray *)indexes withString:(NSString *)aString
{
    NSAssert(indexes != nil, @"%s: indexes 不可以为nil", __PRETTY_FUNCTION__);
    NSAssert(aString != nil, @"%s: aString 不可以为nil", __PRETTY_FUNCTION__);
    if(aString == nil || indexes == nil)return @"";
    NSUInteger offset = 0;
    NSMutableString *raw = [self mutableCopy];
    
    NSInteger prevLength = 0;
    for(NSInteger i = 0; i < [indexes count]; i++)
    {
        @autoreleasepool
        {
            NSRange range = [[indexes objectAtIndex:i] rangeValue];
            prevLength = range.length;
            
            range.location -= offset;
            if(range.location >= raw.length || range.length + range.location > raw.length)continue;
            [raw replaceCharactersInRange:range withString:aString];
            offset = offset + prevLength - [aString length];
        }
    }
    
    return raw;
}

@end