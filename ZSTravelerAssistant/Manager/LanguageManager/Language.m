//
//  Language.m
//  Tourism
//
//  Created by csxfno21 on 13-4-2.
//  Copyright (c) 2013年 logic. All rights reserved.
//

#import "Language.h"
#import "LanguageManager.h"
static NSDictionary *languageDic = nil;
@implementation Language

+(void)resetLanguageCache
{
    if(languageDic)
    {
        SAFERELEASE(languageDic)
    }
}
+(NSString*)stringWithName:(NSString*)name
{
    if (languageDic)
    {
        return [languageDic objectForKey:name];
    }
    Language_Type languageID = [[LanguageManager sharedInstanced] currentLanguage];
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = nil;
    
    switch (languageID)
    {
        case CHINESE:
        {
            path = [bundle pathForResource:[NSString stringWithFormat:@"language_cn"]
                                    ofType:@"plist"];
            break;
        }
        case ENGLISH:
        {
            path = [bundle pathForResource:[NSString stringWithFormat:@"language_en"]
                                    ofType:@"plist"];
            break;
        }
        case UNKNOW:
        {
            path = [bundle pathForResource:[NSString stringWithFormat:@"language_en"]
                                    ofType:@"plist"];
            break;
        }
            
        default:
            break;
    }
    
    languageDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    return [languageDic objectForKey:name];
}

- (void)dealloc
{
    SAFERELEASE(languageDic)
    [super dealloc];
}
@end
