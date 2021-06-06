//
//  Language.h
//  Tourism
//
//  Created by csxfno21 on 13-4-2.
//  Copyright (c) 2013年 logic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Language : NSObject
+(NSString*)stringWithName:(NSString*)name;
+(void)resetLanguageCache;
@end
