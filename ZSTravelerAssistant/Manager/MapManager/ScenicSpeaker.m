//
//  ScenicSpeaker.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-9-27.
//  Copyright (c) 2013年 company. All rights reserved.
//
#import "ScenicSpeaker.h"
#import "TTSPlayer.h"

@implementation ScenicSpeaker

- (id)init
{
    if (self = [super init])
    {
        //注册 观察着
        [[MapManager sharedInstanced] registerMapManagerNotification:self];
        //加载 当前所属景区的 播报雷
        SCENIC_TYPE  currentScenic = [MapManager sharedInstanced].currentScenic;
        speakerEntitys = [[NSMutableArray alloc] init];
        [self setSpeakerBuffersByType:currentScenic];
    }
    return self;
}


#pragma mark - 定位点 
- (void)didUpdateToLocation:(LoactionPoint *)newLocation fromLocation:(LoactionPoint *)oldLocation
{
    //定位点变化，计算 点面关系
    
    //是否在当前游玩景点内
    if ([self isInCurrentBuffer:newLocation])
    {
        return;
    }
    
    [self isInSpeakBuffer:newLocation];
}

#pragma mark - 当前位置发生变化
- (void)didUpdateCurrentSenic:(SCENIC_TYPE)scenic
{
    [self setSpeakerBuffersByType:scenic];
}


/**
 *  计算 景点和当前所在点的 方位
 *
 */
- (ORIENTATION_TYPE)getOrientation:(double )userHeading withSpotLng:(double)lng withlat:(double)lat
{
    double headToBeiji = 360 - userHeading;//360 - userHeading
    
//    userHeading = userHeading > 180 ? (userHeading - 180) * 2 :userHeading * 2;
    userHeading = userHeading > 180 ? userHeading : (userHeading - 180) * 2;
    ORIENTATION_TYPE orientationType = ORIENTATION_UNKNOW;
    
    //定位，判断poipoint到定位点与定位点到正北方向的夹角
    CLLocationCoordinate2D locationPoint = [MapManager sharedInstanced].oldLocation2D;
    CLLocationCoordinate2D tmpLocation = CLLocationCoordinate2DMake(lat,lng);
    
    
    //point1-->获取合成点的平面坐标 point2-->获取定位点的平面坐标 point3-->获取PoiPoint的平面坐标
    CGPoint point1 = [PublicUtils GetCartesianCoordinate:tmpLocation];
    CGPoint point2 = [PublicUtils GetCartesianCoordinate:locationPoint];
    CGPoint point3 = [PublicUtils GetCartesianCoordinate:CLLocationCoordinate2DMake(tmpLocation.latitude,locationPoint.longitude)];

    
    //计算 d1--p1p2 d2--p2p3 d3--p3p1
    //计算夹角 p1p3p2
    double d1 = [PublicUtils GetDistances:point1 withPoint:point2];
    double d2 = [PublicUtils GetDistances:point2 withPoint:point3];
//    double d3 = [PublicUtils GetDistances:point3 withPoint:point1];
    
    double tmpAngle = 0.0;
    double angle;
    
    double a = 0.0;
    if (acos(d2/d1) > headToBeiji)
    {
        a = acos(d2/d1) - headToBeiji;
    }
    else
    {
        a = 360 - (headToBeiji - acos(d2/d1));
    }
    
    if (a >= 0.0 && a < 90.0)
    {
        tmpAngle = acos(d2/d1) * 180/M_PI;;//角度
    }
    else if (a >= 90.0 && a < 180)
    {
        tmpAngle = 180 - acos(d2/d1) * 180/M_PI;;//角度
    }
    else if (a >= 180.0 && a < 270.0)
    {
        tmpAngle = 180 + acos(d2/d1) * 180/M_PI;;//角度
    }
    else if (a >= 270.0 && a <359.9)
    {
        tmpAngle = 360 - acos(d2/d1) * 180/M_PI;;//角度
    }

    if (userHeading > tmpAngle)
    {
        angle = userHeading - tmpAngle;
        
        if (angle <= 10)
        {
            orientationType = STRAIGHT_FRONT;
        }
        else if (angle > 10 && angle <= 80)
        {
            orientationType = LEFT_FRONT;
        }
        else if (angle > 80 && angle <angle <=100)
        {
            orientationType = LEFT;
        }
        else if (angle > 100 && angle <= 170)
        {
            orientationType = LEFT_BEHIND;
        }
        else if (angle > 170 && angle <= 190)
        {
            orientationType = STRAIGHT_BEHIND;
        }
        else if (angle > 190 && angle <= 260)
        {
            orientationType = RIGHT_BEHIND;
        }
        else if (angle > 260 && angle <= 280)
        {
            orientationType = RIGHT;
        }
        else if (angle > 280 && angle <= 350)
        {
            orientationType = RIGHT_FRONT;
        }

    }
    else
    {
        angle = tmpAngle - userHeading;
        angle = fmod(angle, 360);
        if (angle <= 10)
        {
            orientationType = STRAIGHT_FRONT;
        }
        else if (angle > 10 && angle <= 80)
        {
            orientationType = RIGHT_FRONT;
        }
        else if (angle > 80 && angle <= 100)
        {
            orientationType = RIGHT;
        }
        else if (angle > 100 && angle <= 170)
        {
            orientationType = RIGHT_BEHIND;
        }
        else if (angle > 170 && angle <= 190)
        {
            orientationType = STRAIGHT_BEHIND;
        }
        else if (angle > 190 && angle <= 260)
        {
            orientationType = LEFT_BEHIND;
        }
        else if (angle > 260 && angle <= 280)
        {
            orientationType = LEFT;
        }
        else if (angle > 280 && angle <= 350)
        {
            orientationType = LEFT_FRONT;
        }
    }
    return orientationType;
}


#pragma mark - 构建polygon
- (AGSPolygon*) createPolygon:(NSString *) textBuffer
{
    AGSMutablePolygon *polygon = [[[AGSMutablePolygon alloc] initWithSpatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326 WKT:nil]] autorelease];
    [polygon addRingToPolygon];
    NSArray * textArray = [textBuffer componentsSeparatedByString:@","];
    for (int i = 0;i<textArray.count;i++)
    {
        if(i%2 == 0)
        {
            [polygon addPointToRing:[AGSPoint pointWithX:[[textArray objectAtIndex:i] doubleValue] y:[[textArray objectAtIndex:i+1] doubleValue] spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326 WKT:nil]]];
        }
    }
    return polygon;
}

#pragma mark - 数据库获取所在景区的所有buffer
- (void) setSpeakerBuffersByType:(SCENIC_TYPE)type
{
    if (type != SCENIC_OUT && type != SCENIC_UNKNOW)
    {
        [speakerEntitys removeAllObjects];
        NSArray *speakContentEntitys = [[DataAccessManager sharedDataModel] getSpotSpeakByType:type];
        for (ZS_SpotSpeak_Entity * spotSpeakEntity in speakContentEntitys)
        {
            AGSPolygon *polygon = [self createPolygon:spotSpeakEntity.SpotBuffer];
            SpeakerEntity * speakEntity = [SpeakerEntity entityWithSpotID:[spotSpeakEntity.SpotID intValue] withMaxSpeakCount:2 withScenics:polygon withName:spotSpeakEntity.SpotName];
            [speakerEntitys addObject:speakEntity];
        }
    }
}
#pragma mark - 是否在Buffer内
- (BOOL) isInBuffer:(LoactionPoint *)newLocation withPolygon:(AGSPolygon*) polygon
{
    AGSPoint * tmpPt = [[[AGSPoint alloc] initWithX:newLocation.longitude y:newLocation.latitude spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326 WKT:nil]] autorelease];
    return [polygon containsPoint:tmpPt];
}

#pragma mark - 是否在当前Buffer内
- (BOOL) isInCurrentBuffer:(LoactionPoint *)newLocation
{
    return [self isInBuffer:newLocation withPolygon:lastSpeakEntity.scenic];
}

#pragma mark - 是否在当前所属景区的播报区域内
- (BOOL) isInSpeakBuffer:(LoactionPoint *)newLocation
{
    if ([MapManager sharedInstanced].magneticHeading == -1)
    {
        return NO;
    }
    for (SpeakerEntity *entity in speakerEntitys)
    {
        if ([self isInBuffer:newLocation withPolygon:entity.scenic])
        {
            if (++entity.speakCount > entity.maxSpeakCount)
            {
                entity.speakCount --;
                return NO;
            }
            //添加 已经播报过的点 id 比较
            if([[MapManager sharedInstanced].hasSpeaked containsObject:INTTOOBJ(entity.speakSpotID)])
            {
                return NO;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGE_SPEAK_SYMBOL_ICON" object:INTTOOBJ(entity.speakSpotID)];
            [[MapManager sharedInstanced].hasSpeaked  addObject:INTTOOBJ(entity.speakSpotID)];
            [self TTSSpeak:entity];
            lastSpeakEntity = entity;
            return YES;
        }
    }
    return NO;
}

#pragma mark - TTS播报
- (void) TTSSpeak:(SpeakerEntity *)entity
{
    ZS_CommonNav_entity * spotEntity = [[DataAccessManager sharedDataModel] getPOI:entity.speakSpotID];
    ORIENTATION_TYPE orientation_Type = [self getOrientation:[MapManager sharedInstanced].magneticHeading withSpotLng:spotEntity.NavLng.doubleValue withlat:spotEntity.NavLat.doubleValue];
    NSString *textOri ;
    switch (orientation_Type)
    {
        case LEFT:
            textOri = @"您的左边是";
            break;
        case LEFT_FRONT:
            textOri = @"您的左前方是";
            break;
        case LEFT_BEHIND:
            textOri = @"您的左后方是";
            break;
        case STRAIGHT_BEHIND:
            textOri = @"您的后方是";
            break;
        case STRAIGHT_FRONT:
            textOri = @"您的前方是";
            break;
        case RIGHT:
            textOri = @"您的右方是";
            break;
        case RIGHT_BEHIND:
            textOri = @"您的右后方是";
            break;
        case RIGHT_FRONT:
            textOri = @"您的右前方是";
            break;   
        default:
            textOri = @"" ;
            break;
    }
    textOri = [NSString stringWithFormat:@"%@%@",textOri,spotEntity.NavTitle];
//    NSLog(@"%@",textOri);
    NSString * strSpeakContent = [[DataAccessManager sharedDataModel] getSpeakSpotContent:entity.speakSpotID];
    NSString * strAllContent = [NSString stringWithFormat:@"%@,%@",textOri,strSpeakContent];
    [[TTSPlayer shareInstance] play:strAllContent playMode:TTS_PLAY_JUMP_QUEUE];
}

- (void)dealloc
{
    //注销 观察着
    [[MapManager sharedInstanced] unRegisterMapManagerNotification:self];
    [speakerEntitys removeAllObjects];
    SAFERELEASE(speakerEntitys)
    [super dealloc];
}
@end


@implementation SpeakerEntity
@synthesize speakSpotID,scenic,speakCount,maxSpeakCount,speakName;
- (id)init
{
    if (self = [super init])
    {

    }
    return self;
}



+(id)entityWithSpotID:(int)spotID withMaxSpeakCount:(int)maxSpeakCount withScenics:(AGSPolygon *)scenic withName:(NSString *)speakName
{
    SpeakerEntity *entity = [[SpeakerEntity alloc] init];
    entity.maxSpeakCount = SCENIC_SPEAK_MAX_COUNT;
    entity.speakSpotID = spotID;
    entity.scenic = scenic;
    entity.speakName = speakName;
    return [entity autorelease];
}

- (void)dealloc
{
    speakCount = 0;
    maxSpeakCount = 0;
    SAFERELEASE(scenic)
    [super dealloc];
}
@end
