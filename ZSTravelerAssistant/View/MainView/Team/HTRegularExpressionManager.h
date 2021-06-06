//
//  HTRegularExpressionManager.h
//  HTEmotionView
//
//  Created by csxfno21 on 11/7/13.
//  Copyright (c) 2013 ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTRegularExpressionManager : NSObject

+ (NSMutableArray *)itemIndexesWithPattern:(NSString *)pattern inString:(NSString *)findingString;

@end
