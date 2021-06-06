//
//  Config.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-19.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject
+(void)setRotation:(BOOL)rotation;
+(BOOL)isRotation;
+(void)openBgMusic:(BOOL)oepn;
+(BOOL)isPlayBgmusic;
+(float)getMediaValue;
+(void)setMediaValue:(float)value;
+(void)setScreenLightValue:(float)value;
+(float)getScreenLightValue;
+(void)setTeamSelfName:(NSString*)name;
+(NSString*)getTeamSelfName;
+(void)setTeamSelfWhere:(NSString*)name;
+(NSString*)getTeamSelfWhere;
+(void)setTeamSelfSex:(NSString*)sex;
+(NSString*)getTeamSelfSex;
@end
