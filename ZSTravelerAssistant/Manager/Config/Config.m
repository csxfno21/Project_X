//
//  Config.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-19.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "Config.h"
#import "MusicPlayManager.h"
#define MAP_ROTATION                @"MAP_ROTATION"
#define PLAY_BG_MUSIC               @"PLAY_BG_MUSIC"
#define PLAY_BG_MUSIC_VALUE         @"PLAY_BG_MUSIC_VALUE"
#define SCREEN_LIGHT_VALUE          @"SCREEN_LIGHT_VALUE"
#define TEAM_SELFNAME               @"TEAM_SELFNAME"
#define TEAM_SELFWHERE              @"TEAM_SELFWHERE"
#define TEAM_SELFSEX                @"TEAM_SELFSEX"

@implementation Config

+(void)setRotation:(BOOL)rotation
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithBool:rotation] forKey:MAP_ROTATION];
    [defaults synchronize];
}

+(BOOL)isRotation
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *number = [defaults objectForKey:MAP_ROTATION];
    return number.boolValue;
}
+(void)openBgMusic:(BOOL)oepn
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithBool:oepn] forKey:PLAY_BG_MUSIC];
    [defaults synchronize];
    
    if(!oepn)
    {
        [[MusicPlayManager sharedInstanced] stopPlay];
    }
    else
    {
        [[MusicPlayManager sharedInstanced] playMusicWithType:[MusicPlayManager sharedInstanced].currentType];
    }
}

+(BOOL)isPlayBgmusic
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *number = [defaults objectForKey:PLAY_BG_MUSIC];
    if (number == nil)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:[NSNumber numberWithBool:YES] forKey:PLAY_BG_MUSIC];
        [defaults synchronize];
        return YES;
    }
    return number.boolValue;
}

+(float)getMediaValue
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *number = [defaults objectForKey:PLAY_BG_MUSIC_VALUE];
    if(number == nil)return -1;
    return number.floatValue;
}

+(void)setMediaValue:(float)value
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithFloat:value] forKey:PLAY_BG_MUSIC_VALUE];
    [defaults synchronize];
}


+(void)setScreenLightValue:(float)value
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithFloat:value] forKey:SCREEN_LIGHT_VALUE];
    [defaults synchronize];
}

+(float)getScreenLightValue
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *number = [defaults objectForKey:SCREEN_LIGHT_VALUE];
    if([PublicUtils systemVersion].floatValue > 5.0)
    {
        if (number == nil)
        {
            float value = [UIScreen mainScreen].brightness;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:[NSNumber numberWithFloat:value] forKey:SCREEN_LIGHT_VALUE];
            [defaults synchronize];
            return value;
        }
    }
   
    return number.floatValue;
}

+(void)setTeamSelfName:(NSString*)name
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:name forKey:TEAM_SELFNAME];
    [defaults synchronize];
}
+(NSString*)getTeamSelfName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* name = [defaults objectForKey:TEAM_SELFNAME];
    return ReplaceNULL2Empty(name).length == 0 ? @"未设置昵称":ReplaceNULL2Empty(name);
    
}
+(void)setTeamSelfWhere:(NSString*)where
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:where forKey:TEAM_SELFWHERE];
    [defaults synchronize];
}
+(NSString*)getTeamSelfWhere
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* where = [defaults objectForKey:TEAM_SELFWHERE];
    return ReplaceNULL2Empty(where);
}
+(void)setTeamSelfSex:(NSString*)sex
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:sex forKey:TEAM_SELFSEX];
    [defaults synchronize];
}
+(NSString*)getTeamSelfSex
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* sex = [defaults objectForKey:TEAM_SELFSEX];
    return ReplaceNULL2Empty(sex);
}

@end
