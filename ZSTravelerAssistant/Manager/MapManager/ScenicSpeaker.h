//
//  ScenicSpeaker.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-9-27.
//  Copyright (c) 2013年 company. All rights reserved.
//
#define SCENIC_SPEAK_MAX_COUNT   HUGE_VALF          //无限大
#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>
#import "PoiPoint.h"

/**
 *  手机朝向与景点PoiPoint的方向
 *  关系
 */
typedef enum
{
    ORIENTATION_UNKNOW = 0,
    LEFT ,       //左方
    LEFT_FRONT,     //左前方
    STRAIGHT_FRONT, //正前方
    RIGHT_FRONT,    //右前方
    RIGHT,          //右方
    RIGHT_BEHIND,   //右后方
    STRAIGHT_BEHIND,//正后方
    LEFT_BEHIND,    //左后方
}ORIENTATION_TYPE;

/**
 *   播报雷
 *   (播报的景区id,包含播报区域<可能是数组>,播报的次数,最多可播报次数<留做哪些景点特殊处理>)
 */
@interface SpeakerEntity : NSObject
{
    int speakSpotID;
    int speakCount;
    int maxSpeakCount;
    NSString * speakName;
    AGSPolygon *scenic;
}
@property(nonatomic,assign)int speakSpotID;
@property(nonatomic,assign)int speakCount;
@property(nonatomic,assign)int maxSpeakCount;
@property(nonatomic,assign)NSString * speakName;
@property(nonatomic,strong)AGSPolygon *scenic;
+(id)entityWithSpotID:(int)spotID withMaxSpeakCount:(int)maxSpeakCount withScenics:(AGSPolygon*)scenic withName:(NSString*)speakName;

@end
/**
 *
 *  播报点，虚拟播报点处理
 */


@interface ScenicSpeaker : NSObject<MapManagerDelegate>
{
    NSMutableArray *speakerEntitys;//系统中所有的播报区域
    SpeakerEntity *lastSpeakEntity;//当前播报的结构
    double currentHeading;
}
@end

