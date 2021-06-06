//
//  RouteStructFactory.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-9-24.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "RouteStructFactory.h"
#import "TTSPlayer.h"
#import "UIToast.h"

#define DISTANCE_MAX_WALK           2000    //人步行的最长距离，大于它就开车行驶/游览车

@implementation RouteStructFactory
- (id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

- (RouteStruct*)outputRouteStruct:(LoactionPoint*)location withNavType:(NAV_TYPE)navType withPois:(NSArray*)pois
{
    if (location == nil || location.latitude == 0.0 || location.longitude == 0.0)
    {
        NSLog(@"RouteStructFactory Error,Location cannot be null or value cannot be 0.0");
        return nil;
    }
    if (navType < 0 || navType > 2)
    {
        NSLog(@"RouteStructFactory Error,navType is an illegal param");
        return nil;
    }
    if (!ISARRYCLASS(pois) || pois.count == 0)
    {
        NSLog(@"RouteStructFactory Error,pois is empty");
        return nil;
    }
    //以上  return nil 阻止调用函数 参数 错误
    
    
    AGSPoint *loctaionPoint = [AGSPoint pointWithX:location.longitude y:location.latitude spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326 WKT:nil]];
    SCENIC_TYPE loctaionScenic = [[MapManager sharedInstanced] currentScenic:loctaionPoint];
  
    switch (navType)
    {
        case NAV_TYPE_CAR:// 自驾
        {
            return [self carRouteSections:loctaionScenic location:loctaionPoint withPois:pois];
        }
        case NAV_TYPE_TOUR_CAR://游览车
        {
            return [self tourCarRouteSections:loctaionScenic location:loctaionPoint withPois:pois];
        }
        case NAV_TYPE_WALK://步行
        default://默认 步行
        {
            return [self walkRouteSections:loctaionScenic location:loctaionPoint withPois:pois];
        }
    }
    
    return nil;
}

/**
 *
 * 自驾模式
 */
- (RouteStruct*)carRouteSections:(SCENIC_TYPE)loctaionScenic location:(AGSPoint*)point withPois:(NSArray*)pois
{
    RouteStruct *rs = [[[RouteStruct alloc] init] autorelease];
    NSMutableArray *array = [NSMutableArray array];
    
    if (loctaionScenic == SCENIC_OUT || loctaionScenic == SCENIC_UNKNOW)
    {
//        [[TTSPlayer shareInstance] play:[Language stringWithName:SPEAK_SIX] playMode:TTS_PLAY_JUMP_QUEUE];
        rs.errorCode = ROUTE_STRUCT_ERROR_LOCATIONOUT;
        return rs;
    }
    
    for (id obj in pois)
    {
        if ([obj isKindOfClass:[PoiPoint class]])
        {
            PoiPoint *poiPoint = obj;
            //设置当前点为 上个节点的末点
            if (array.count > 0)
            {
                RouteSection *lastRouteSection = [array lastObject];
                
                point = [AGSPoint pointWithX:lastRouteSection.endPoi.longitude y:lastRouteSection.endPoi.latitude spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326 WKT:nil]];
            }
            
            ZS_CommonNav_entity *entity = [[DataAccessManager sharedDataModel] getPOI:poiPoint.poiID];
             AGSPoint *nextPoint = [AGSPoint pointWithX:poiPoint.longitude y:poiPoint.latitude spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326 WKT:nil]];
            //目标点所在区域
            SCENIC_TYPE nextPointType = [[MapManager sharedInstanced] currentScenic:nextPoint];
            switch (loctaionScenic)//当前所在位置
            {
                case SCENIC_IN://当前位置在景区间
                {
                    if (nextPointType == SCENIC_IN)
                    {
                        //判断 当前目标是否为停车场
                        if (entity && [ReplaceNULL2Empty(entity.NavType) intValue] == POI_PARK)
                        {
                            //停车场 出入口
                            NSArray *parkArray = [self parkIN_OUT:poiPoint withparkID:[ReplaceNULL2Empty(entity.NavIID) intValue]];
                            PoiPoint *parkIN = [parkArray objectAtIndex:0];
                            //修改 目标点为 入口点
                            poiPoint.poiID = parkIN.poiID;
                            poiPoint.longitude = parkIN.longitude;
                            poiPoint.latitude = parkIN.latitude;
                            if (array.count == 0)
                            {
                                RouteSection *section = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:[Language stringWithName:START_POINT] withLongitude:point.x withLatitude:point.y] withEndPoi:parkIN withNavType:NAV_TYPE_CAR];
                                [array addObject:section];
                            }
                            else
                            {
                                RouteSection *lastSection = [array lastObject];
                                if(lastSection.endPoi.poiID != poiPoint.poiID)//上一个节点 的结束点不能和当前的结束点相同
                                {
                                    RouteSection *section = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:lastSection.endPoi.name withLongitude:lastSection.endPoi.longitude withLatitude:lastSection.endPoi.latitude withPoiID:lastSection.endPoi.poiID] withEndPoi:parkIN withNavType:NAV_TYPE_CAR];
                                    [array addObject:section];
                                }
                            }
                        } 
                        else
                        {
                            //判断起点到目标点的距离 与  起点到停车场的距离
                            double distanceL2E = [PublicUtils GetDistanceS:point.x withlat1:point.y withlng2:nextPoint.x withlat2:nextPoint.y];
                            double distanceL2P = 0.0;
                            //找到停车场,如果没有绑定停车场则查找附近的停车场
                            ZS_CommonNav_entity *parkEntity = [self parkWithEntity:entity];
                            if (parkEntity && parkEntity.NavIID)
                            {
                                //停车场 出入口
                                NSArray *parkArray = [self parkIN_OUT:poiPoint withparkID:[ReplaceNULL2Empty(parkEntity.NavIID) intValue]];
                                PoiPoint *parkIN = [parkArray objectAtIndex:0];
//                                PoiPoint *parkOUT = [parkArray objectAtIndex:1];
                                //当前点到停车场的距离
                                distanceL2P = [PublicUtils GetDistanceS:point.x withlat1:point.y withlng2:[parkEntity.NavLng doubleValue] withlat2:[parkEntity.NavLat doubleValue]];
                               
                                if (distanceL2P/2 < distanceL2E || distanceL2E > DISTANCE_MAX_WALK)//如果当前到停车场的距离 小于 直接到大目的地的距离 && 到目的地的距离 > 2km（不能走太长时间）出行方式选自驾
                                {
                                    if (array.count == 0)
                                    {
                                        RouteSection *section = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:[Language stringWithName:START_POINT] withLongitude:point.x withLatitude:point.y] withEndPoi:parkIN withNavType:NAV_TYPE_CAR];
                                        [array addObject:section];
                                        //到达停车场后 步行到目标点
                                        RouteSection *lastSection = [array lastObject];
                                        RouteSection *walkSection = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:lastSection.endPoi.name withLongitude:lastSection.endPoi.longitude withLatitude:lastSection.endPoi.latitude withPoiID:lastSection.endPoi.poiID] withEndPoi:[PoiPoint pointWithName:poiPoint.name withLongitude:poiPoint.longitude withLatitude:poiPoint.latitude withPoiID:poiPoint.poiID] withNavType:NAV_TYPE_WALK];
                                        [array addObject:walkSection];
                                    }
                                    else
                                    { 
                                        RouteSection *lastSection = [array lastObject];
                                        BOOL samePark = NO;
                                        PoiPoint *parkPoint = nil;
                                        for (RouteSection *routeSction in array)
                                        {
                                            samePark = routeSction.startPoi.poiID == parkIN.poiID;
                                            if (routeSction.navType == NAV_TYPE_CAR)
                                            {
                                                parkPoint = routeSction.endPoi;
                                            }
                                        }
                                        if(lastSection.endPoi.poiID != poiPoint.poiID)//上一个节点 的结束点不能和当前的结束点相同
                                        {
                                            //判断 起点 和 目标点停车场 是否为同一个停车场 则直接步行到目标点
                                            if(samePark)
                                            {
                                                RouteSection *walkSection = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:lastSection.endPoi.name withLongitude:lastSection.endPoi.longitude withLatitude:lastSection.endPoi.latitude withPoiID:lastSection.endPoi.poiID] withEndPoi:[PoiPoint pointWithName:poiPoint.name withLongitude:poiPoint.longitude withLatitude:poiPoint.latitude withPoiID:poiPoint.poiID] withNavType:NAV_TYPE_WALK];
                                                [array addObject:walkSection];
                                            }
                                            else
                                            {
                                                //判断之前的节点是否有 停车场
                                                if (parkPoint)
                                                {
                                                    //步行回停车场取车 开到 下个目标的依附停车场
                                                    RouteSection *walkSection = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:lastSection.endPoi.name withLongitude:lastSection.endPoi.longitude withLatitude:lastSection.endPoi.latitude withPoiID:lastSection.endPoi.poiID] withEndPoi:[PoiPoint pointWithName:parkPoint.name withLongitude:parkPoint.longitude withLatitude:parkPoint.latitude withPoiID:parkPoint.poiID] withNavType:NAV_TYPE_WALK];
                                                    [array addObject:walkSection];
                                                    
                                                    //获取 当前 停车场的 出口 － 下个依附停车场的入口
                                                    
                                                   ZS_PoiRelation_entity *inParkEntity = [[DataAccessManager sharedDataModel] getPOIRelationPoiID:parkPoint.poiID];
                                                    
                                                    NSArray *inANDoutParkEntity = [self parkIN_OUT:poiPoint withparkID:[ReplaceNULL2Empty(inParkEntity.ParentID) intValue]];
                                                    PoiPoint *outParkP = [inANDoutParkEntity objectAtIndex:1];
                                                    
                                                    PoiPoint *outParkPoint = nil;
                                                    if (outParkP && outParkP.poiID > 0)
                                                    {
                                                        outParkPoint = [PoiPoint pointWithName:outParkP.name withLongitude:outParkP.longitude withLatitude:outParkP.latitude withPoiID:outParkP.poiID];
                                                    }
                                                    else
                                                    {
                                                        outParkPoint = parkPoint;
                                                    }
                                                    //开车到下个依附停车场
                                                    RouteSection *carsection = [RouteSection sectionWithStartPoi:outParkPoint withEndPoi:parkIN withNavType:NAV_TYPE_CAR];
                                                    [array addObject:carsection];
                                                    
                                                    //再步行到目标点
                                                    RouteSection *walkSectionT = [RouteSection sectionWithStartPoi:parkIN withEndPoi:[PoiPoint pointWithName:poiPoint.name withLongitude:poiPoint.longitude withLatitude:poiPoint.latitude withPoiID:poiPoint.poiID] withNavType:NAV_TYPE_WALK];
                                                    [array addObject:walkSectionT];
                                                    
                                                }
                                                else
                                                {
                                                    //之前没有停车场 ,直接开到依附停车场 & 步行到目标点
                                                    //开车到下个依附停车场
                                                    RouteSection *carsection = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:lastSection.endPoi.name withLongitude:lastSection.endPoi.longitude withLatitude:lastSection.endPoi.latitude withPoiID:lastSection.endPoi.poiID] withEndPoi:parkIN withNavType:NAV_TYPE_CAR];
                                                    [array addObject:carsection];
                                                    
                                                    //再步行到目标点
                                                    RouteSection *walkSectionT = [RouteSection sectionWithStartPoi:parkIN withEndPoi:[PoiPoint pointWithName:poiPoint.name withLongitude:poiPoint.longitude withLatitude:poiPoint.latitude withPoiID:poiPoint.poiID] withNavType:NAV_TYPE_WALK];
                                                    [array addObject:walkSectionT];
                                                }
                                            }
                                        }
                                    }
                                }
                                else //步行到目的地
                                {
                                    if (array.count == 0)
                                    {
                                        RouteSection *walkSection = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:[Language stringWithName:START_POINT] withLongitude:point.x withLatitude:point.y] withEndPoi:[PoiPoint pointWithName:poiPoint.name withLongitude:poiPoint.longitude withLatitude:poiPoint.latitude withPoiID:poiPoint.poiID] withNavType:NAV_TYPE_WALK];
                                        [array addObject:walkSection];

                                    }
                                    else
                                    {
                                        RouteSection *lastSection = [array lastObject];
                                        RouteSection *walkSection = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:lastSection.endPoi.name withLongitude:lastSection.endPoi.longitude withLatitude:lastSection.endPoi.latitude withPoiID:lastSection.endPoi.poiID] withEndPoi:[PoiPoint pointWithName:poiPoint.name withLongitude:poiPoint.longitude withLatitude:poiPoint.latitude withPoiID:poiPoint.poiID] withNavType:NAV_TYPE_WALK];
                                        [array addObject:walkSection];
                                    }
                                }
                            }
                            else  //没有找到停车场 直接开过去
                            {
                                if (array.count == 0)
                                {
                                    RouteSection *section = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:[Language stringWithName:START_POINT] withLongitude:point.x withLatitude:point.y] withEndPoi:[PoiPoint pointWithName:poiPoint.name withLongitude:poiPoint.longitude withLatitude:poiPoint.latitude withPoiID:poiPoint.poiID] withNavType:NAV_TYPE_CAR];
                                    [array addObject:section];
                                }
                                else
                                {
                                    RouteSection *lastSection = [array lastObject];
                                    if(lastSection.endPoi.poiID != poiPoint.poiID)
                                    {
                                        //判断当前是否在车上
                                        RouteSection *lastSection = [array lastObject];
                                        if (lastSection.navType == NAV_TYPE_CAR)
                                        {
                                            RouteSection *section = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:lastSection.endPoi.name withLongitude:lastSection.endPoi.longitude withLatitude:lastSection.endPoi.latitude withPoiID:lastSection.endPoi.poiID] withEndPoi:[PoiPoint pointWithName:poiPoint.name withLongitude:poiPoint.longitude withLatitude:poiPoint.latitude withPoiID:poiPoint.poiID] withNavType:NAV_TYPE_CAR];
                                            [array addObject:section];
                                        }
                                        else
                                        {
                                            // 找到之前的车
                                            PoiPoint *oldParkIn = nil;
                                            for (RouteSection *sec in array)
                                            {
                                                if(sec.navType == NAV_TYPE_CAR)
                                                {
                                                    oldParkIn = sec.endPoi;
                                                }
                                            }
                                            
                                            if(oldParkIn)//如果找到
                                            {
                                                //步行取车，从出口开车到目的地
                                                RouteSection *section = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:lastSection.endPoi.name withLongitude:lastSection.endPoi.longitude withLatitude:lastSection.endPoi.latitude withPoiID:lastSection.endPoi.poiID] withEndPoi:[PoiPoint pointWithName:oldParkIn.name withLongitude:oldParkIn.longitude withLatitude:oldParkIn.latitude withPoiID:oldParkIn.poiID] withNavType:NAV_TYPE_WALK];
                                                [array addObject:section];
                                                
                                                ZS_PoiRelation_entity *inPR = [[DataAccessManager sharedDataModel] getPOIRelationPoiID:oldParkIn.poiID];
                                                if (inPR)
                                                {
                                                    NSArray *parkInAndOutPoints = [self parkIN_OUT:poiPoint withparkID:inPR.ParentID.intValue];
                                                    PoiPoint *outP = [parkInAndOutPoints objectAtIndex:0];
                                                    
                                                    RouteSection *carSection = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:outP.name withLongitude:outP.longitude withLatitude:outP.latitude withPoiID:outP.poiID] withEndPoi:[PoiPoint pointWithName:poiPoint.name withLongitude:poiPoint.longitude withLatitude:poiPoint.latitude withPoiID:poiPoint.poiID] withNavType:NAV_TYPE_CAR];
                                                    [array addObject:carSection];
                                                }
                                                else
                                                {
                                                    rs.errorCode = ROUTE_STRUCT_ERROR_SYS_NOCAR;
                                                    return rs;
                                                }
                                            }
                                            else
                                            {
                                                //没有车 就 错了
                                                rs.errorCode = ROUTE_STRUCT_ERROR_SYS_NOCAR;
                                                return rs;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (nextPointType == SCENIC_ZSL || nextPointType == SCENIC_MXL
                             || nextPointType == SCENIC_LGS)//目标点在景区内
                    {
                        //1.找到所在景区的 最优入口
                        ZS_CommonNav_entity *bestEntrance = [self exportWithPoint:poiPoint withSecinc:nextPointType];
                        if (!bestEntrance)// 没有找到入口
                        {
                            rs.errorCode = ROUTE_STRUCT_ERROR_NOENTRANCE;
                            return rs;
                        }
                        //2.找到出口所对应的停车场
                        ZS_CommonNav_entity *bestPark = [self parkWithEntity:bestEntrance];
                        if (bestPark.NavIID && bestPark.NavIID.length > 0)//找到停车场
                        {
                            //找到停车场的入口
                            NSArray *parkInAndOut = [self parkIN_OUT:poiPoint withparkID:[ReplaceNULL2Empty(bestPark.NavIID) intValue]];
                            PoiPoint *INPARK = [PoiPoint pointWithName:bestPark.NavTitle withLongitude:[bestPark.NavLng doubleValue] withLatitude:[bestPark.NavLat doubleValue] withPoiID:[bestPark.NavIID intValue]];
                            if (ISARRYCLASS(parkInAndOut) && parkInAndOut.count > 1)
                            {
                                PoiPoint *inPoint = [parkInAndOut objectAtIndex:0];
                                INPARK = [PoiPoint pointWithName:inPoint.name withLongitude:inPoint.longitude withLatitude:inPoint.latitude withPoiID:inPoint.poiID];
                            }
                            //判断是否有节点
                            if (array.count == 0)// 之前没有节点,直接开车到停车场 & 步行到 入口 & 步行到 目标点
                            {
                                RouteSection *section = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:[Language stringWithName:START_POINT] withLongitude:point.x withLatitude:point.y] withEndPoi:INPARK withNavType:NAV_TYPE_CAR];
                                [array addObject:section];
                                
                                RouteSection *wSectionF = [RouteSection sectionWithStartPoi:INPARK withEndPoi:[PoiPoint pointWithName:bestEntrance.NavTitle withLongitude:[bestEntrance.NavLng doubleValue] withLatitude:[bestEntrance.NavLat doubleValue] withPoiID:[bestEntrance.NavIID intValue]] withNavType:NAV_TYPE_WALK];
                                [array addObject:wSectionF];
                                
                                RouteSection *wSectionS = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:bestEntrance.NavTitle withLongitude:[bestEntrance.NavLng doubleValue] withLatitude:[bestEntrance.NavLat doubleValue] withPoiID:[bestEntrance.NavIID intValue]] withEndPoi:[PoiPoint pointWithName:poiPoint.name withLongitude:poiPoint.longitude withLatitude:poiPoint.latitude withPoiID:poiPoint.poiID] withNavType:NAV_TYPE_WALK];
                                [array addObject:wSectionS];
                            }
                            else //之前存在节点
                            {
                             //判断之前是否有车库
                                RouteSection *lastSection = [array lastObject];
                                BOOL samePark = NO;
                                PoiPoint *parkPoint = nil;
                                
                                for (RouteSection *routeSction in array)
                                {
                                    samePark = routeSction.startPoi.poiID == INPARK.poiID;
                                    if (routeSction.navType == NAV_TYPE_CAR)
                                    {
                                        parkPoint = routeSction.endPoi;
                                    }
                                }
                                if(lastSection.endPoi.poiID != poiPoint.poiID)
                                {
                                    //判断 起点 和 目标点停车场 是否为同一个停车场 则直接步行到目标点
                                    if(samePark)
                                    {
                                        RouteSection *walkSection = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:lastSection.endPoi.name withLongitude:lastSection.endPoi.longitude withLatitude:lastSection.endPoi.latitude withPoiID:lastSection.endPoi.poiID] withEndPoi:[PoiPoint pointWithName:poiPoint.name withLongitude:poiPoint.longitude withLatitude:poiPoint.latitude withPoiID:poiPoint.poiID] withNavType:NAV_TYPE_WALK];
                                        [array addObject:walkSection];
                                    }
                                    else
                                    {
                                        //判断之前的节点是否有 停车场
                                        if (parkPoint)
                                        {
                                            //步行去之前的停车场 取回车，开到下个目标的停车场，步行到 景区入口，步行到目标点
                                            //步行回停车场取车 开到 下个目标的依附停车场
                                            RouteSection *walkSection = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:lastSection.endPoi.name withLongitude:lastSection.endPoi.longitude withLatitude:lastSection.endPoi.latitude withPoiID:lastSection.endPoi.poiID] withEndPoi:[PoiPoint pointWithName:parkPoint.name withLongitude:parkPoint.longitude withLatitude:parkPoint.latitude withPoiID:parkPoint.poiID] withNavType:NAV_TYPE_WALK];
                                            [array addObject:walkSection];
                                            
                                            //获取 当前 停车场的 出口 － 下个依附停车场的入口
                                            
                                            ZS_PoiRelation_entity *inParkEntity = [[DataAccessManager sharedDataModel] getPOIRelationPoiID:parkPoint.poiID];
                                            NSArray *inANDoutParkEntity = [self parkIN_OUT:poiPoint withparkID:[ReplaceNULL2Empty(inParkEntity.ParentID) intValue]];
                                            PoiPoint *outParkPointE = [inANDoutParkEntity objectAtIndex:1];
                                            
                                            PoiPoint *outParkPoint = nil;
                                            if (outParkPointE)
                                            {
                                                outParkPoint = outParkPointE;
                                            }
                                            else
                                            {
                                                outParkPoint = parkPoint;
                                            }
                                            //开车到下个依附停车场
                                            RouteSection *carsection = [RouteSection sectionWithStartPoi:outParkPoint withEndPoi:INPARK withNavType:NAV_TYPE_CAR];
                                            [array addObject:carsection];
                                            
                                            //再步行到入口
                                            RouteSection *walkSectionS = [RouteSection sectionWithStartPoi:INPARK withEndPoi:[PoiPoint pointWithName:bestEntrance.NavTitle withLongitude:[bestEntrance.NavLng doubleValue] withLatitude:[bestEntrance.NavLat doubleValue] withPoiID:[bestEntrance.NavIID intValue]] withNavType:NAV_TYPE_WALK];
                                            [array addObject:walkSectionS];
                                            
                                            //再步行到目标点
                                            RouteSection *walkSectionT = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:bestEntrance.NavTitle withLongitude:[bestEntrance.NavLng doubleValue] withLatitude:[bestEntrance.NavLat doubleValue] withPoiID:[bestEntrance.NavIID intValue]] withEndPoi:[PoiPoint pointWithName:poiPoint.name withLongitude:poiPoint.longitude withLatitude:poiPoint.latitude withPoiID:poiPoint.poiID] withNavType:NAV_TYPE_WALK];
                                            [array addObject:walkSectionT];
                                        }
                                        else
                                        {
                                            //之前没有停车场 ,直接开到依附停车场 & 步行到目标点
                                            //开车到下个依附停车场
                                            RouteSection *carsection = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:lastSection.endPoi.name withLongitude:lastSection.endPoi.longitude withLatitude:lastSection.endPoi.latitude withPoiID:lastSection.endPoi.poiID] withEndPoi:INPARK withNavType:NAV_TYPE_CAR];
                                            [array addObject:carsection];
                                            
                                            //再步行到入口
                                            RouteSection *walkSectionS = [RouteSection sectionWithStartPoi:INPARK withEndPoi:[PoiPoint pointWithName:bestEntrance.NavTitle withLongitude:[bestEntrance.NavLng doubleValue] withLatitude:[bestEntrance.NavLat doubleValue] withPoiID:[bestEntrance.NavIID intValue]] withNavType:NAV_TYPE_WALK];
                                            [array addObject:walkSectionS];
                                            
                                            //再步行到目标点
                                            RouteSection *walkSectionT = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:bestEntrance.NavTitle withLongitude:[bestEntrance.NavLng doubleValue] withLatitude:[bestEntrance.NavLat doubleValue] withPoiID:[bestEntrance.NavIID intValue]] withEndPoi:[PoiPoint pointWithName:poiPoint.name withLongitude:poiPoint.longitude withLatitude:poiPoint.latitude withPoiID:poiPoint.poiID] withNavType:NAV_TYPE_WALK];
                                            [array addObject:walkSectionT];
                                        }
                                    }

                                }

                            }
                        }
                        else // 此时没有停车场，直接结束分析
                        {
                            rs.errorCode = ROUTE_STRUCT_ERROR_NOPARKBINDTOENTRANCE;
                            return rs;
                        }
                    }
                    else
                    {
                        rs.errorCode = ROUTE_STRUCT_ERROR_SYS_TOPOINTOUT;
                        return rs;
                    }
                    break;
                }
                    //当前位置在景区内
                case SCENIC_ZSL:
                case SCENIC_MXL:
                case SCENIC_LGS:
                {
                   if (nextPointType == SCENIC_IN)
                   {
  
                       if (array.count == 0)
                       {
                           //之前没车 没法自驾模式
                           rs.errorCode = ROUTE_STRUCT_ERROR_NOPARKFOUNINHISTORY;
                           return rs;
                       }
                       else
                       {
                           BOOL hasCar = NO;
                           PoiPoint *parkInold = nil;
                           //查看是否在之前有停车场，如果有，则步行取车，如果没有 则直接返回
                           for (RouteSection *routeSction in array)
                           {
                               if (routeSction.navType == NAV_TYPE_CAR)//之前有开车
                               {
                                   hasCar = YES;
                                   parkInold = routeSction.endPoi;
                               }
                           }
                           
                           if (!hasCar)
                           {
                               rs.errorCode = ROUTE_STRUCT_ERROR_SYS_NOCAR;
                               return rs;
                           }
                           RouteSection *lastSection = [array lastObject];
                           //判断 当前目标是否为停车场
                           if (entity && [ReplaceNULL2Empty(entity.NavType) intValue] == POI_PARK)
                           {
                               //如果 目标停车场 和 之前的停车场一样，则 直接步行过去
                               NSArray *parkArray = [self parkIN_OUT:poiPoint withparkID:[ReplaceNULL2Empty(entity.NavIID) intValue]];
                               if (ISARRYCLASS(parkArray) && parkArray.count > 1)
                               {
                                   PoiPoint *inParkRelationPoint = [parkArray objectAtIndex:0];
                                   if (inParkRelationPoint.poiID == parkInold.poiID)
                                   {
                                       RouteSection *walkSection = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:lastSection.endPoi.name withLongitude:lastSection.endPoi.longitude withLatitude:lastSection.endPoi.latitude withPoiID:lastSection.endPoi.poiID] withEndPoi:parkInold withNavType:NAV_TYPE_WALK];
                                       [array addObject:walkSection];
                                   }
                                   else //步行到之前的停车场 取回车 － 开车到目的地
                                   {    
                                       RouteSection *walkSection = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:lastSection.endPoi.name withLongitude:lastSection.endPoi.longitude withLatitude:lastSection.endPoi.latitude withPoiID:lastSection.endPoi.poiID] withEndPoi:parkInold withNavType:NAV_TYPE_WALK];
                                       [array addObject:walkSection];
                                       
                                       // 从 停车场出口 － 停车场入口
                                       ZS_PoiRelation_entity *oldParkIn = [[DataAccessManager sharedDataModel] getPOIRelationPoiID:parkInold.poiID];
                                       if (oldParkIn && oldParkIn.ParentID)
                                       {
                                           NSArray *oldParkArray = [self parkIN_OUT:poiPoint withparkID:[ReplaceNULL2Empty(oldParkIn.ParentID) intValue]];
                                           if (ISARRYCLASS(oldParkArray) && oldParkArray.count > 1)
                                           {
                                               PoiPoint *oldOutParkRelationPoint = [parkArray objectAtIndex:1];
                                               RouteSection *carSection = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:oldOutParkRelationPoint.name withLongitude:oldOutParkRelationPoint.longitude withLatitude:oldOutParkRelationPoint.latitude withPoiID:oldOutParkRelationPoint.poiID] withEndPoi:[PoiPoint pointWithName:inParkRelationPoint.name withLongitude:inParkRelationPoint.longitude withLatitude:inParkRelationPoint.latitude withPoiID:inParkRelationPoint.poiID] withNavType:NAV_TYPE_CAR];
                                               [array addObject:carSection];
                                           }
                                           else
                                           {    // 数据错误
                                               rs.errorCode = ROUTE_STRUCT_ERROR_NOPARKFIND;
                                               return rs;
                                           }
                                       }
                                       else
                                       {
                                           //数据错误，没有查找到入口结构
                                           rs.errorCode = ROUTE_STRUCT_ERROR_NOENTRANCE;
                                           return rs;
                                       }
                                   }
                               }
                               else //数据错误，没有查找到 停车场入口和出口
                               {
                                   rs.errorCode = ROUTE_STRUCT_ERROR_NOPARKFIND;
                                   return rs;
                               }
                           }
                           else
                           {
                               //找到停车场,如果没有绑定停车场则查找附近的停车场
                               ZS_CommonNav_entity *parkEntity = [self parkWithEntity:entity];
                               if (parkEntity && parkEntity.NavIID)//如果找到停车场
                               {
                                   NSArray *parkInAndOutArray = [self parkIN_OUT:poiPoint withparkID:[ReplaceNULL2Empty(parkEntity.NavIID) intValue]];
                                   if (ISARRYCLASS(parkInAndOutArray) && parkInAndOutArray.count > 1)
                                   {
                                       PoiPoint *parkInPoint = [parkInAndOutArray objectAtIndex:0];
                                       
                                       //步行取到车，开到停车场入口，再步行到目标点
                                       RouteSection *walkSection = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:lastSection.endPoi.name withLongitude:lastSection.endPoi.longitude withLatitude:lastSection.endPoi.latitude withPoiID:lastSection.endPoi.poiID] withEndPoi:parkInold withNavType:NAV_TYPE_WALK];
                                       [array addObject:walkSection];
                                       
                                       ZS_PoiRelation_entity *oldParkIn = [[DataAccessManager sharedDataModel] getPOIRelationPoiID:parkInold.poiID];
                                       if (oldParkIn && oldParkIn.ParentID)
                                       {
                                           NSArray *oldParkArray = [self parkIN_OUT:poiPoint withparkID:[ReplaceNULL2Empty(oldParkIn.ParentID) intValue]];
                                           if (ISARRYCLASS(oldParkArray) && oldParkArray.count > 1)
                                           {
                                               PoiPoint *parkOutP = [oldParkArray objectAtIndex:1];
                                               //从之前的停车场出口开到目标依附停车场
                                               RouteSection *carSection = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:parkOutP.name withLongitude:parkOutP.longitude withLatitude:parkOutP.latitude withPoiID:parkOutP.poiID] withEndPoi:[PoiPoint pointWithName:parkInPoint.name withLongitude:parkInPoint.longitude withLatitude:parkInPoint.latitude withPoiID:parkInPoint.poiID] withNavType:NAV_TYPE_CAR];
                                               [array addObject:carSection];
                                               
                                               //从 目标依附停车场 步行到目标点
                                               RouteSection *walkSectionS = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:parkInPoint.name withLongitude:parkInPoint.longitude withLatitude:parkInPoint.latitude withPoiID:parkInPoint.poiID] withEndPoi:[PoiPoint pointWithName:poiPoint.name withLongitude:poiPoint.longitude withLatitude:poiPoint.latitude withPoiID:poiPoint.poiID] withNavType:NAV_TYPE_WALK];
                                               [array addObject:walkSectionS];
                                           }
                                           else
                                           {
                                               rs.errorCode = ROUTE_STRUCT_ERROR_NOPARKFIND;
                                               return rs;
                                           }
                                       }
                                       else
                                       {
                                           rs.errorCode = ROUTE_STRUCT_ERROR_NOPARKFIND;
                                           return rs;
                                       }
                                   }
                                   else
                                   {
                                       rs.errorCode = ROUTE_STRUCT_ERROR_NOPARKFIND;
                                       return rs;
                                   }
                               }
                               else//目标点没有停车场
                               {
                                   // 步行取到车 直接开过去
                                   
                                   RouteSection *walkSection = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:lastSection.endPoi.name withLongitude:lastSection.endPoi.longitude withLatitude:lastSection.endPoi.latitude withPoiID:lastSection.endPoi.poiID] withEndPoi:parkInold withNavType:NAV_TYPE_WALK];
                                   [array addObject:walkSection];
                                   //找到停车场出口
                                  ZS_PoiRelation_entity *oldParkIn = [[DataAccessManager sharedDataModel] getPOIRelationPoiID:parkInold.poiID];
                                   if (oldParkIn && oldParkIn.ParentID)
                                   {
                                       NSArray *oldParkArray = [self parkIN_OUT:poiPoint withparkID:[ReplaceNULL2Empty(oldParkIn.ParentID) intValue]];
                                       if (ISARRYCLASS(oldParkArray) && oldParkArray.count > 1)
                                       {
                                           PoiPoint *parkOutPoint = [oldParkArray objectAtIndex:1];
                                           
                                           RouteSection *carSection = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:parkOutPoint.name withLongitude:parkOutPoint.longitude withLatitude:parkOutPoint.latitude withPoiID:parkOutPoint.poiID] withEndPoi:[PoiPoint pointWithName:poiPoint.name withLongitude:poiPoint.longitude withLatitude:poiPoint.latitude withPoiID:poiPoint.poiID] withNavType:NAV_TYPE_CAR];
                                           [array addObject:carSection];
                                       }
                                       else
                                       {
                                       
                                           rs.errorCode = ROUTE_STRUCT_ERROR_NOPARKFIND;
                                           return rs;
                                       }
                                   }
                                   else
                                   {
                                   
                                       rs.errorCode = ROUTE_STRUCT_ERROR_NOPARKFIND;
                                       return rs;
                                   }
                               }
                           }
                       }
                   }
                   else
                   {
                       //判断当前点和目标点是否在同一个景区,同景区内 不能开车
                    if (nextPointType == loctaionScenic)
                    {
                        rs.errorCode = ROUTE_STRUCT_ERROR_CANNOTNAVINSCENIC;
                        return rs;
                    }
                       //当前点在景区，目标点也在别的景区
                    if (array.count == 0)
                    {
                        rs.errorCode = ROUTE_STRUCT_ERROR_NOPARKFOUNINHISTORY;
                        return rs;//之前没车 没法自驾模式
                    }
                    else
                    {
                        BOOL hasCar = NO;
                        PoiPoint *parkInold = nil;
                        //查看是否在之前有停车场，如果有，则步行取车，如果没有 则直接返回
                        for (RouteSection *routeSction in array)
                        {
                            if (routeSction.navType == NAV_TYPE_CAR)//之前有开车
                            {
                                hasCar = YES;
                                parkInold = routeSction.endPoi;
                            }
                        }
                        
                        if (!hasCar)
                        {
                            rs.errorCode = ROUTE_STRUCT_ERROR_SYS_NOPARK;
                            return rs;
                        }
                        
                        RouteSection *lastSection = [array lastObject];
                        NSArray *parkArray = [self parkIN_OUT:poiPoint withparkID:[ReplaceNULL2Empty(entity.NavIID) intValue]];
                        //判断之前的停车场和目标点的依附停车场是否一样
                        PoiPoint *nextParkIn = [parkArray objectAtIndex:0];
                        if (parkInold.poiID == nextParkIn.poiID)
                        {
                            // 直接步行 目的地
                            RouteSection *walkSection = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:lastSection.endPoi.name withLongitude:lastSection.endPoi.longitude withLatitude:lastSection.endPoi.latitude withPoiID:lastSection.endPoi.poiID] withEndPoi:[PoiPoint pointWithName:poiPoint.name withLongitude:poiPoint.longitude withLatitude:poiPoint.latitude withPoiID:poiPoint.poiID] withNavType:NAV_TYPE_WALK];
                            [array addObject:walkSection];
                        }
                        else //先找到之前的停车场，再开到目标点的依附停车场 再步行到目标点 的 入口，再步行到 目标点
                        {
                            RouteSection *walkSection = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:lastSection.endPoi.name withLongitude:lastSection.endPoi.longitude withLatitude:lastSection.endPoi.latitude withPoiID:lastSection.endPoi.poiID] withEndPoi:[PoiPoint pointWithName:parkInold.name withLongitude:parkInold.longitude withLatitude:parkInold.latitude withPoiID:parkInold.poiID] withNavType:NAV_TYPE_WALK];
                            [array addObject:walkSection];
                            
                            //找到目标所的景区的出入口
                            //1.找到所在景区的 最优入口
                            ZS_CommonNav_entity *bestEntrance = [self exportWithPoint:poiPoint withSecinc:nextPointType];
                            if (!bestEntrance)// 没有找到入口
                            {
                                rs.errorCode = ROUTE_STRUCT_ERROR_NOENTRANCE;
                                return rs;
                            }
                            //2.找到出口所对应的停车场
                            ZS_CommonNav_entity *bestPark = [self parkWithEntity:bestEntrance];
                            if (bestPark.NavIID && bestPark.NavIID.length > 0)//找到停车场
                            {
                                //找到停车场的入口
                                NSArray *parkInAndOut = [self parkIN_OUT:poiPoint withparkID:[ReplaceNULL2Empty(bestPark.NavIID) intValue]];
                                PoiPoint *INPARK = [PoiPoint pointWithName:bestPark.NavTitle withLongitude:[bestPark.NavLng doubleValue] withLatitude:[bestPark.NavLat doubleValue] withPoiID:[bestPark.NavIID intValue]];
                                if (ISARRYCLASS(parkInAndOut) && parkInAndOut.count > 1)
                                {
                                    PoiPoint *inPoint = [parkInAndOut objectAtIndex:0];
                                    INPARK = [PoiPoint pointWithName:inPoint.name withLongitude:inPoint.longitude withLatitude:inPoint.latitude withPoiID:inPoint.poiID];
                                }
                                
                                //开到 依附停车场
                                RouteSection *carSection = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:parkInold.name withLongitude:parkInold.longitude withLatitude:parkInold.latitude withPoiID:parkInold.poiID] withEndPoi:INPARK withNavType:NAV_TYPE_CAR];
                                [array addObject:carSection];
                                
                                // 步行到入口－ 目的地
                                RouteSection *walkSectionS = [RouteSection sectionWithStartPoi:INPARK withEndPoi:[PoiPoint pointWithName:bestEntrance.NavTitle withLongitude:bestEntrance.NavLng.doubleValue withLatitude:bestEntrance.NavLat.doubleValue withPoiID:bestEntrance.NavIID.intValue] withNavType:NAV_TYPE_WALK];
                                [array addObject:walkSectionS];
                                
                                RouteSection *walkSectionT = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:bestEntrance.NavTitle withLongitude:bestEntrance.NavLng.doubleValue withLatitude:bestEntrance.NavLat.doubleValue withPoiID:bestEntrance.NavIID.intValue] withEndPoi:[PoiPoint pointWithName:poiPoint.name withLongitude:poiPoint.longitude withLatitude:poiPoint.latitude withPoiID:poiPoint.poiID] withNavType:NAV_TYPE_WALK];
                                [array addObject:walkSectionT];
                            }
                            else
                            {
                                //没有找到停车场，结束分析
                                rs.errorCode = ROUTE_STRUCT_ERROR_NOPARKFIND;
                                return rs;
                            }

                        }
                    }
                    
                   }
                    
                    break;
                }
                default:
                    break;
            }
            
        }
    }
    rs.routeSections = array;
    rs.errorCode = ROUTE_STRUCT_ERROR_SUCCESS;
    return rs;
}

/**
 *
 * 模拟导航模式
 */
- (RouteStruct*)tourCarRouteSections:(SCENIC_TYPE)loctaionScenic location:(AGSPoint*)point withPois:(NSArray*)pois
{
    NSMutableArray *array = [NSMutableArray array];
    RouteStruct *rs = [[[RouteStruct alloc] init] autorelease];
    //TODO
    if (loctaionScenic == SCENIC_OUT || loctaionScenic == SCENIC_UNKNOW)
    {
//        [[TTSPlayer shareInstance] play:[Language stringWithName:SPEAK_SIX] playMode:TTS_PLAY_JUMP_QUEUE];
        rs.errorCode = ROUTE_STRUCT_ERROR_LOCATIONOUT;
        return rs;
    }
    
    for (id obj in pois)
    {
        if ([obj isKindOfClass:[PoiPoint class]])
        {
            PoiPoint *poiPoint = obj;
            //设置当前点为 上个节点的末点
            if (array.count > 0)
            {
                RouteSection *lastRouteSection = [array lastObject];
                
                point = [AGSPoint pointWithX:lastRouteSection.endPoi.longitude y:lastRouteSection.endPoi.latitude spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326 WKT:nil]];
            }
            ZS_CommonNav_entity *tourCarEntity = nil;
            ZS_CommonNav_entity *entity = [[DataAccessManager sharedDataModel] getPOI:poiPoint.poiID];
            AGSPoint *nextPoint = [AGSPoint pointWithX:poiPoint.longitude y:poiPoint.latitude spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326 WKT:nil]];
            //目标点所在区域
            SCENIC_TYPE nextPointType = [[MapManager sharedInstanced] currentScenic:nextPoint];
            switch (loctaionScenic)
            {
                case SCENIC_IN:
                case SCENIC_LGS:
                case SCENIC_ZSL:
                case SCENIC_MXL:
                {
                    if (nextPointType == SCENIC_IN)
                    {
                        //找到目的点的游览车
                        NSString *tourCarsStr = entity.POITourCar;
                        if (!tourCarsStr || tourCarsStr.length == 0)
                        {
                            rs.errorCode = ROUTE_STRUCT_ERROR_NOBINDTOUCAR;
                            return rs;
                        }
                        NSArray *tourCars = [tourCarsStr componentsSeparatedByString:@";"];
                        if (!ISARRYCLASS(tourCars) || tourCars.count == 0)
                        {
                            rs.errorCode = ROUTE_STRUCT_ERROR_NOBINDTOUCAR;
                            return rs;
                        }
                        tourCarEntity = [self tourCarWithPoint:point withcars:tourCars];
                        
                        //到目的地大门距离
                        double dis2Entity = [PublicUtils GetDistanceS:point.x withlat1:point.y withlng2:poiPoint.longitude withlat2:poiPoint.latitude];
                        //到游览车起点距离
                        double dis2TourCar = [PublicUtils GetDistanceS:point.x withlat1:point.y withlng2:tourCarEntity.NavLng.doubleValue withlat2:tourCarEntity.NavLat.doubleValue];
                        if (dis2TourCar - dis2Entity > 100 && dis2Entity < DISTANCE_MAX_WALK)     //直接去景点较为方便
                        {
                            UIToast *tost = [[UIToast alloc] init];
                            [tost show:[Language stringWithName:REQUESTTOWALKROUTE]];
                            SAFERELEASE(tost)
                            RouteSection *walkSection = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:[Language stringWithName:START_POINT] withLongitude:point.x withLatitude:point.y] withEndPoi:[PoiPoint pointWithName:poiPoint.name withLongitude:poiPoint.longitude withLatitude:poiPoint.latitude withPoiID:poiPoint.poiID] withNavType:NAV_TYPE_WALK];
                            [array addObject:walkSection];
                            continue;
                            
                        }
                    }
                    else if(nextPointType == SCENIC_LGS || nextPointType == SCENIC_ZSL || nextPointType == SCENIC_MXL)
                    {
                        //如果 当前位置和 目标位置在同一个景区 不能坐游览车
                        if (nextPointType ==  loctaionScenic)
                        {
                            rs.errorCode = ROUTE_STRUCT_ERROR_CANNOTNAVINSCENIC_TOURCAR;
                            return rs;
                        }
                        
                        //找到 目标出入口 绑定的游览车
                        
                        ZS_CommonNav_entity *bestEntrance = [self exportWithPoint:poiPoint withSecinc:nextPointType];
                        if (bestEntrance)
                        {
                            //找到目的点的游览车
                            NSString *tourCarsStr = bestEntrance.POITourCar;
                            if (!tourCarsStr || tourCarsStr.length == 0)
                            {
                                rs.errorCode = ROUTE_STRUCT_ERROR_NOBINDTOUCAR;
                                return rs;
                            }
                            NSArray *tourCars = [tourCarsStr componentsSeparatedByString:@";"];
                            if (!ISARRYCLASS(tourCars) || tourCars.count == 0)
                            {
                                rs.errorCode = ROUTE_STRUCT_ERROR_NOBINDTOUCAR;
                                return rs;
                            }
                            tourCarEntity = [self tourCarWithPoint:point withcars:tourCars];
                            
                            //到目的地大门距离
                            double dis2Entity = [PublicUtils GetDistanceS:point.x withlat1:point.y withlng2:bestEntrance.NavLng.doubleValue withlat2:bestEntrance.NavLat.doubleValue];
                            //到游览车起点距离
                            double dis2TourCar = [PublicUtils GetDistanceS:point.x withlat1:point.y withlng2:tourCarEntity.NavLng.doubleValue withlat2:tourCarEntity.NavLat.doubleValue];
                            if (dis2TourCar - dis2Entity > 100 && dis2Entity < DISTANCE_MAX_WALK)     //直接去景点较为方便
                            {
                                UIToast *tost = [[UIToast alloc] init];
                                [tost show:[Language stringWithName:REQUESTTOWALKROUTE]];
                                SAFERELEASE(tost)
                                //到大门
                                RouteSection *walk2EntranceSection = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:[Language stringWithName:START_POINT] withLongitude:point.x withLatitude:point.y] withEndPoi:[PoiPoint pointWithName:bestEntrance.NavTitle withLongitude:[bestEntrance.NavLng doubleValue] withLatitude:[bestEntrance.NavLat doubleValue] withPoiID:bestEntrance.NavIID.intValue] withNavType:NAV_TYPE_WALK];
                                [array addObject:walk2EntranceSection];
                                //到景点
                                RouteSection *walk2POISection = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:[Language stringWithName:START_POINT] withLongitude:[bestEntrance.NavLng doubleValue] withLatitude:[bestEntrance.NavLat doubleValue]] withEndPoi:[PoiPoint pointWithName:poiPoint.name withLongitude:poiPoint.longitude withLatitude:poiPoint.latitude withPoiID:poiPoint.poiID] withNavType:NAV_TYPE_WALK];
                                [array addObject:walk2POISection];
                                continue;
                                
                            }
                        }
                        else
                        {
                            rs.errorCode = ROUTE_STRUCT_ERROR_NOBINDTOUCAR;
                            return rs;
                        }
                    }
                    break;
                }
                default:
                    break;
            }
            
            if (!tourCarEntity)
            {
                rs.errorCode = ROUTE_STRUCT_ERROR_NOBINDTOUCAR;
                return rs;
            }
            //由于 游览车 中途不上,只能步行到起点
            if (array.count == 0)
            {
                RouteSection *walkSection = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:[Language stringWithName:START_POINT] withLongitude:point.x withLatitude:point.y] withEndPoi:[PoiPoint pointWithName:tourCarEntity.NavTitle withLongitude:[tourCarEntity.NavLng doubleValue] withLatitude:[tourCarEntity.NavLat doubleValue] withPoiID:tourCarEntity.NavIID.intValue] withNavType:NAV_TYPE_WALK];
                [array addObject:walkSection];
            }
            else
            {
                RouteSection *lastSetion = [array lastObject];
                RouteSection *walkSection = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:lastSetion.endPoi.name withLongitude:lastSetion.endPoi.longitude withLatitude:lastSetion.endPoi.latitude withPoiID:lastSetion.endPoi.poiID] withEndPoi:[PoiPoint pointWithName:tourCarEntity.NavTitle withLongitude:[tourCarEntity.NavLng doubleValue] withLatitude:[tourCarEntity.NavLat doubleValue] withPoiID:tourCarEntity.NavIID.intValue] withNavType:NAV_TYPE_WALK];
                [array addObject:walkSection];
                
            }
            RouteSection *tourCarSection = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:tourCarEntity.NavTitle withLongitude:[tourCarEntity.NavLng doubleValue] withLatitude:[tourCarEntity.NavLat doubleValue] withPoiID:tourCarEntity.NavIID.intValue] withEndPoi:[PoiPoint pointWithName:poiPoint.name withLongitude:poiPoint.longitude withLatitude:poiPoint.latitude withPoiID:poiPoint.poiID] withNavType:NAV_TYPE_TOUR_CAR];
            [array addObject:tourCarSection];
        }
    }
    
    
    rs.routeSections = array;
    rs.errorCode = ROUTE_STRUCT_ERROR_SUCCESS;
    return rs;
}

/**
 *
 * 步行导航模式
 */
- (RouteStruct*)walkRouteSections:(SCENIC_TYPE)loctaionScenic location:(AGSPoint*)point withPois:(NSArray*)pois
{
    NSMutableArray *array = [NSMutableArray array];
    RouteStruct *rs = [[[RouteStruct alloc] init] autorelease];
    if (loctaionScenic == SCENIC_OUT || loctaionScenic == SCENIC_UNKNOW)
    {
//        [[TTSPlayer shareInstance] play:[Language stringWithName:SPEAK_SIX] playMode:TTS_PLAY_JUMP_QUEUE];
        rs.errorCode = ROUTE_STRUCT_ERROR_LOCATIONOUT;
        return rs;
    }
    for (id obj in pois)
    {
        if ([obj isKindOfClass:[PoiPoint class]])
        {
            PoiPoint *poiPoint = obj;
            
            if (array.count == 0)
            {
                RouteSection *section = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:[Language stringWithName:START_POINT] withLongitude:point.x withLatitude:point.y] withEndPoi:[PoiPoint pointWithName:poiPoint.name withLongitude:poiPoint.longitude withLatitude:poiPoint.latitude withPoiID:poiPoint.poiID] withNavType:NAV_TYPE_WALK];
                [array addObject:section];
            }
            else
            {
                RouteSection *last = [array lastObject];
                RouteSection *section = [RouteSection sectionWithStartPoi:[PoiPoint pointWithName:last.endPoi.name withLongitude:last.endPoi.longitude withLatitude:last.endPoi.latitude withPoiID:last.endPoi.poiID] withEndPoi:[PoiPoint pointWithName:poiPoint.name withLongitude:poiPoint.longitude withLatitude:poiPoint.latitude withPoiID:poiPoint.poiID] withNavType:NAV_TYPE_WALK];
                [array addObject:section];
            }
            
        }
    }
    
    rs.routeSections = array;
    rs.errorCode = ROUTE_STRUCT_ERROR_SUCCESS;
    return rs;
}

/**
 * 查找最优游览车
 *  poi 当前位置  
 */
- (ZS_CommonNav_entity*)tourCarWithPoint:(AGSPoint*)poi withcars:(NSArray*)cars
{
    ZS_CommonNav_entity *entity = nil;
    
    double minDis = -1;
    for (NSString *tourCarID in cars)
    {
        ZS_CommonNav_entity *tmpEntity = [[DataAccessManager sharedDataModel] getPOI:ReplaceNULL2Empty(tourCarID).intValue];
        if (!tmpEntity)
        {
            continue;
        }
        double dis = [PublicUtils GetDistanceS:poi.x withlat1:poi.y withlng2:[tmpEntity.NavLng doubleValue] withlat2:[tmpEntity.NavLat doubleValue]];
        if (minDis == -1 || minDis >= dis)
        {
            minDis = dis;
            entity = tmpEntity;
        }
    }
    
    return entity;
}

/**
 *
 * 查找 poi 所在景区 最优入口
 * 权重衡量
 */
- (ZS_CommonNav_entity*)exportWithPoint:(PoiPoint*)poi withSecinc:(int)scenic
{
    NSArray *entrances = [[DataAccessManager sharedDataModel] getPOi:scenic withPoiType:POI_ENTRANCE,nil];
    int index = -1;
    double minDistance = -1;
    for (int i = 0; i < entrances.count ; i++)
    {
        ZS_CommonNav_entity *enitity = [entrances objectAtIndex:i];
        double dis = [PublicUtils GetDistanceS:poi.longitude withlat1:poi.latitude withlng2:[enitity.NavLng doubleValue] withlat2:[enitity.NavLat doubleValue]];
        if (minDistance == -1 || minDistance > dis)
        {
            index = i;
            minDistance = dis;
        }
    }
    if (index != -1)
    {
        return [entrances objectAtIndex:index];
    }
    return nil;
}


/**
 * 查找该poi的停车场
 *
 */
- (ZS_CommonNav_entity*)parkWithEntity:(ZS_CommonNav_entity*)entity
{
    //如果目标点 是 风景区 与外部的 出口,则直接开出去
    if (entity.NavType.intValue == POI_EXPORT_L)
    {
        return nil;
    }
    
    if (entity.POIPark && entity.POIPark.intValue > 0)
    {
        return [[DataAccessManager sharedDataModel] getPOI:[entity.POIPark intValue]];
    }
    else
    {
        //没有绑定停车场，查看是否为大景区的小景区
        //如果为大景区的中的poi，先找到大景区中的
        
        
        
        
        //则修改最近的停车场
        
        NSArray *parks = [[DataAccessManager sharedDataModel] getPOi:-1 withPoiType:POI_PARK,nil];
        int index = -1;
        double minDistance = -1;
        for (int i = 0; i < parks.count ; i++)
        {
            ZS_CommonNav_entity *parkEntity  = [parks objectAtIndex:i];
            double distance = [PublicUtils GetDistanceS:[entity.NavLng doubleValue] withlat1:[entity.NavLat doubleValue] withlng2:[parkEntity.NavLng doubleValue] withlat2:[parkEntity.NavLat doubleValue]];

            if (minDistance == -1 || distance < minDistance)
            {
                minDistance = distance;
                index = i;
            }
        }
        
        if (index != -1)
        {
            ZS_CommonNav_entity *parkEntity  = [parks objectAtIndex:index];
            return parkEntity;
        }
    }
    return nil;
}

/**
 *
 * 查找 停车场入口 出口
 */
- (NSArray*)parkIN_OUT:(PoiPoint*)poiPoint withparkID:(int)parkID
{
    NSMutableArray *parkArray = [[[NSMutableArray alloc] init] autorelease];
    //查找 停车场的入口
    NSArray *poiRelationEntityS = [[DataAccessManager sharedDataModel] getPOIRelationInfo:parkID];
    PoiPoint *parkIN = [PoiPoint pointWithName:poiPoint.name withLongitude:poiPoint.longitude withLatitude:poiPoint.latitude withPoiID:poiPoint.poiID];
    PoiPoint *parkOUT = [PoiPoint pointWithName:poiPoint.name withLongitude:poiPoint.longitude withLatitude:poiPoint.latitude withPoiID:poiPoint.poiID];
    if (ISARRYCLASS(poiRelationEntityS))
    {
        if (poiRelationEntityS.count > 1)
        {
            ZS_PoiRelation_entity *poiRelEntityF = [poiRelationEntityS objectAtIndex:0];
            ZS_PoiRelation_entity *poiRelEntityS = [poiRelationEntityS objectAtIndex:1];
            
            if (poiRelEntityF.POIType.intValue == POI_PARK_IN && poiRelEntityS.POIType.intValue == POI_PARK_OUT)//入口
            {
                parkIN = [PoiPoint pointWithName:poiRelEntityF.POITitle withLongitude:[poiRelEntityF.POILng doubleValue] withLatitude:[poiRelEntityF.POILat doubleValue] withPoiID:[poiRelEntityF.PoiID intValue]];
                parkOUT = [PoiPoint pointWithName:poiRelEntityS.POITitle withLongitude:[poiRelEntityS.POILng doubleValue] withLatitude:[poiRelEntityS.POILat doubleValue] withPoiID:[poiRelEntityS.PoiID intValue]];
            }
            else if(poiRelEntityF.POIType.intValue == POI_PARK_OUT && poiRelEntityS.POIType.intValue == POI_PARK_IN)
            {
                parkOUT = [PoiPoint pointWithName:poiRelEntityF.POITitle withLongitude:[poiRelEntityF.POILng doubleValue] withLatitude:[poiRelEntityF.POILat doubleValue] withPoiID:[poiRelEntityF.PoiID intValue]];
                parkIN = [PoiPoint pointWithName:poiRelEntityS.POITitle withLongitude:[poiRelEntityS.POILng doubleValue] withLatitude:[poiRelEntityS.POILat doubleValue] withPoiID:[poiRelEntityS.PoiID intValue]];
            }
        }
    }
    [parkArray addObject:parkIN];
    [parkArray addObject:parkOUT];
    return parkArray;
}
- (void)dealloc
{

    [super dealloc];
}
@end

@implementation RouteStruct
@synthesize routeSections,errorCode;

- (void)dealloc
{
    SAFERELEASE(routeSections)
    [super dealloc];
}
@end
