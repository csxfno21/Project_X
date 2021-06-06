//
//  LanguageManager.h
//  Tourism
//
//  Created by csxfno21 on 13-4-2.
//  Copyright (c) 2013年 szmap. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum 
{
    CHINESE = 0,
    ENGLISH,
    UNKNOW,
}Language_Type;
@protocol LanguageManagerDelegate <NSObject>

- (void)notifiChangelanguage;

@end
@interface LanguageManager : NSObject
{
    Language_Type language;
    NSMutableArray  *languageNotifications;
}
+(LanguageManager*)sharedInstanced;
+(void)freeInstance;
- (void)setCurrentLanguage:(Language_Type)languageType;
- (Language_Type)currentLanguage;
- (void)registerLanugageNotification:(id<LanguageManagerDelegate>)delegate;
- (void)unRegisterLanugageNotification:(id<LanguageManagerDelegate>)delegate;
@end
