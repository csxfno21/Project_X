//
//  NavProcessingCenter.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-9-12.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "NavProcessingCenter.h"
#import "RouteNavManager.h"
#import "TTSPlayer.h"

#define NAV_YAW_DISTANCE            50      //偏航容差
#define NAV_SIMULATION_TIME_STEP    2       //模拟导航时间间隔
//#define NAV_DISTOTURN               20      //距离路口播报距离
#define NAV_DIDTOTURN_WALK          20      //步行距离路口播报距离
#define NAV_DIDTOTURN_CAR           40      //开车、游览车距离路口播报距离
//#define NAV_DISTOTURNPRE            70      //距离路口预播报距离
#define NAV_DISTOTURNPRE_WALK       70      //步行距离路口预播报距离
#define NAV_DISTOTURNPRE_CAR        140     //开车、游览车路口预播报距离
//#define NAV_DISTOPOI                50      //距离POI距离
#define NAV_DISTOPOI_WALK           35      //步行到达POI距离
#define NAV_DISTOPOI_CAR            50      //驾车到达POI距离

@interface NavProcessingCenter(Private)
- (void)drawNavLine:(MapRouteSectionResponse*)routeSectionData withNavEndPois:(NSArray*)pois;//画线
@end
@implementation NavProcessingCenter
@synthesize delegate,simulationPtsIndex;
- (id)init
{
    if (self = [super init])
    {
        routeStructFactory = [[RouteStructFactory alloc] init];
        _navData = [[NSMutableArray alloc] init];
        simulationPtsIndex = 0;
        lastPt = nil;
        lastNavType = NAV_TYPE_UNKNOW;
        bIsNavStop = NO;
        testArray = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)requestCarRoute:(NSArray *)points
{
    [[RouteNavManager sharedInstance] requestCarRoute:self withPOIRect:points];
}

- (void)requestTourCarRoute:(NSArray *)points
{
    [[RouteNavManager sharedInstance] requestTourCarRoute:self withPOIRect:points];
}

- (void)requestWalkRoute:(NSArray *)points
{
    [[RouteNavManager sharedInstance] requestWalkRoute:self withPOIRect:points];
}
- (BOOL)requestNavTo:(PoiPoint*)poi
{
    if (_navData.count > 0)
    {
        //当前有导航
        //查看 是否有poi 后加入的
        NavProcessingData *runningData = [_navData objectAtIndex:0];
        if(runningData.isInsertedPOI)
        {
            // 当前有 加入poi了，不允许加入 请结束导航
            [[TTSPlayer shareInstance] stopVideo];
            [[TTSPlayer shareInstance] play:[Language stringWithName:SOORY_IN_APPEND_NAV] playMode:TTS_PLAY_JUMP_QUEUE];
            return NO;
        }
        else
        {
            runningData.isInsertedPOI = YES;
            [runningData.navPoints insertObject:poi atIndex:0];
            return YES;
        }
    }
    else
    {
        NSLog(@"error 当前 没有 导航队列");
        return NO;
    }
}
- (void)requestNavTo:(NSArray*)pois withType:(int)navType withSimulation:(BOOL)simulation withBarriers:(NSString*)Barriers
{
    if (_navData.count > 0)
    {
        if((Barriers == nil || Barriers.length == 0) && pois && pois.count == 1)
        {
            if(![self requestNavTo:[pois lastObject]])
            {
                return;
            }
            [[MapManager sharedInstanced] unRegisterMapManagerNotification:self];
            //结束TTS
            [[TTSPlayer shareInstance] stopVideo];
            //终止请求
            [[RouteNavManager sharedInstance] cancelRequest:self];
            //清除线
            if (delegate && [delegate respondsToSelector:@selector(clearCenterNavLine)])
            {
                [delegate clearCenterNavLine];
            }
        }
        else
        {
           [self stopNav]; 
        }
        
        if (delegate && [delegate respondsToSelector:@selector(reViewMapView)])
        {
            [delegate reViewMapView];
        }
    }
    else
    {
        NavProcessingData *data = [[[NavProcessingData alloc] init] autorelease];
        [data.navPoints addObjectsFromArray:pois];
        data.simulation = simulation;
        [_navData addObject:data];
    }
//    [[TTSPlayer shareInstance] stopVideo];
    NavProcessingData *navData = [_navData lastObject];
    [self startRequest:navData.navPoints withSimulation:simulation withNavType:navType withBarriers:Barriers];
}
- (void)startRequest:(NSArray*)pois withSimulation:(BOOL)simulation withNavType:(int)navType withBarriers:(NSString*)Barriers
{

    LoactionPoint *location = [[[LoactionPoint alloc] init] autorelease];
    if (simulation)//模拟导航
    {
        if ([MapManager sharedInstanced].currentScenic == SCENIC_OUT || [MapManager sharedInstanced].currentScenic == SCENIC_UNKNOW)
        {
            if (ISARRYCLASS(pois) && pois.count > 0)
            {
                location.longitude = [MapManager sharedInstanced].oldLocation2D.longitude;
                location.latitude = [MapManager sharedInstanced].oldLocation2D.latitude;
                NSArray *poi = [[DataAccessManager sharedDataModel] getPOi:0 withPoiType:POI_EXPORT_L];
                if (poi.count == 0)
                {
                    NSLog(@"getPOi error ,POI_EXPORT_L array is nil");
                    return;
                }
                double distance = 0.0;
                int index = 0;
                for (int i = 0;i< poi.count; i++)
                {
                    ZS_CommonNav_entity *entity = [poi objectAtIndex:i];
                    double dis = [PublicUtils GetDistanceS:[entity.NavLng doubleValue] withlat1:[entity.NavLat doubleValue] withlng2:location.longitude withlat2:location.latitude];
                    if(distance == 0.0)distance = dis;
                    if(distance > dis)
                    {
                        distance = dis;
                        index = i;
                    }
                }
                
                ZS_CommonNav_entity *entity = [poi objectAtIndex:index];
                location.longitude = [entity.NavLng doubleValue];
                location.latitude = [entity.NavLat doubleValue];
            }
        }
        else
        {
            location.longitude = [MapManager sharedInstanced].oldLocation2D.longitude;
            location.latitude = [MapManager sharedInstanced].oldLocation2D.latitude;
        }
    }
    else
    {
        //判断当前位置
        if ([MapManager sharedInstanced].oldLocation2D.longitude == 0.0)//没有gps 位置
        {
            [[TTSPlayer shareInstance] play:[Language stringWithName:SPEAK_FIVE] playMode:TTS_PLAY_JUMP_QUEUE];
        }
        else
        {
            //TODO 如果当前点和目标点距离过近，比如：10米
            location.longitude = [MapManager sharedInstanced].oldLocation2D.longitude;
            location.latitude = [MapManager sharedInstanced].oldLocation2D.latitude;
        }
    }
    
    //构建导航结构
    RouteStruct *rs = [routeStructFactory outputRouteStruct:location withNavType:navType withPois:pois];
    
    if (rs.errorCode != ROUTE_STRUCT_ERROR_SUCCESS)
    {
        [[TTSPlayer shareInstance] stopVideo];
        [_navData removeAllObjects];
        //TODO 按照 返回的错误码 TTS
        switch (rs.errorCode)
        {
            case ROUTE_STRUCT_ERROR_LOCATIONOUT:
                [[TTSPlayer shareInstance] play:[Language stringWithName:ROUTE_ERROR_LOCATIONOUT] playMode:TTS_PLAY_JUMP_QUEUE];
                break;
            case ROUTE_STRUCT_ERROR_CANNOTNAVINSCENIC:
                [[TTSPlayer shareInstance] play:[Language stringWithName:ROUTE_ERROR_CANNOTNAVINSCENIC] playMode:TTS_PLAY_JUMP_QUEUE];
                break;
            case ROUTE_STRUCT_ERROR_CANNOTNAVINSCENIC_TOURCAR:
                [[TTSPlayer shareInstance] play:[Language stringWithName:ROUTE_ERROR_CANNOTNAVINSCENIC_TOURCAR] playMode:TTS_PLAY_JUMP_QUEUE];
                break;
            case ROUTE_STRUCT_ERROR_NOBINDTOUCAR:
                [[TTSPlayer shareInstance] play:[Language stringWithName:ROUTE_ERROR_NOBINDTOUCAR] playMode:TTS_PLAY_JUMP_QUEUE];
                break;
            case ROUTE_STRUCT_ERROR_NOENTRANCE:
                [[TTSPlayer shareInstance] play:[Language stringWithName:ROUTE_ERROR_NOENTRANCE] playMode:TTS_PLAY_JUMP_QUEUE];
                break;
            case ROUTE_STRUCT_ERROR_NOPARKBINDTOENTRANCE:
                [[TTSPlayer shareInstance] play:[Language stringWithName:ROUTE_ERROR_NOPARKBINDTOENTRANCE] playMode:TTS_PLAY_JUMP_QUEUE];
                break;
            case ROUTE_STRUCT_ERROR_NOPARKFIND:
                [[TTSPlayer shareInstance] play:[Language stringWithName:ROUTE_ERROR_NOPARKFIND] playMode:TTS_PLAY_JUMP_QUEUE];
                break;
            case ROUTE_STRUCT_ERROR_SYS_NOCAR:
                [[TTSPlayer shareInstance] play:[Language stringWithName:ROUTE_ERROR_SYS_NOCAR] playMode:TTS_PLAY_JUMP_QUEUE];
                break;
            case ROUTE_STRUCT_ERROR_SYS_NOPARK:
                [[TTSPlayer shareInstance] play:[Language stringWithName:ROUTE_ERROR_SYS_NOPARK] playMode:TTS_PLAY_JUMP_QUEUE];
                break;
            case ROUTE_STRUCT_ERROR_SYS_TOPOINTOUT:
                [[TTSPlayer shareInstance] play:[Language stringWithName:ROUTE_ERROR_SYS_TOPOINTOUT] playMode:TTS_PLAY_JUMP_QUEUE];
                break;
            case ROUTE_STRUCT_ERROR_NOPARKFOUNINHISTORY:
                [[TTSPlayer shareInstance] play:[Language stringWithName:ROUTE_ERROR_NOPARKFOUNINHISTORY] playMode:TTS_PLAY_JUMP_QUEUE];
                break;
            default:
                break;
        }
    }
    else
    {
        if (!ISARRYCLASS(rs.routeSections) || rs.routeSections.count == 0)
        {
            [[TTSPlayer shareInstance] stopVideo];
            [[TTSPlayer shareInstance] play:[Language stringWithName:SPEAK_SEVEN] playMode:TTS_PLAY_JUMP_QUEUE];
        }
        else
        {
            [[RouteNavManager sharedInstance] requestRoute:self withSections:rs.routeSections withNavType:navType withBarriers:Barriers];
        }
    }

}
- (void)stopNav
{
    //结束TTS
    [[TTSPlayer shareInstance] stopVideo];
    //终止请求
    [[RouteNavManager sharedInstance] cancelRequest:self];
    
    //清除 导航数据
    [[MapManager sharedInstanced] unRegisterMapManagerNotification:self];
    [_navData removeAllObjects];
    //清除线
    if (delegate && [delegate respondsToSelector:@selector(clearCenterNavLine)])
    {
        [delegate clearCenterNavLine];
    }
}


/**
 * 按照导航生成路径数据画线
 *
 */
- (void)drawNavLine:(MapRouteSectionResponse*)routeSectionData withNavEndPois:(NSArray*)pois
{
    NSMutableArray *graphicArray = [[NSMutableArray alloc]init];
    NSMutableArray *graphicAnnotationArray = [[NSMutableArray alloc]init];
    //构建line
    if (!routeSectionData)
    {
        SAFERELEASE(graphicArray)
        SAFERELEASE(graphicAnnotationArray)
        return;
    }
    for (Section *section in routeSectionData.routeFeatures)
    {
        AGSGraphic *graphic = [[AGSGraphic alloc]init];
        AGSMutablePolyline *polyline = [[AGSMutablePolyline alloc]init];
        [polyline addPathToPolyline];
        AGSSimpleLineSymbol *lineSymbol = [AGSSimpleLineSymbol simpleLineSymbol];
        for (SectionAttribute *sa in section.sectionAttributes)
        {
            for (PoiPoint *poiPoint in sa.pointArray)
            {
                AGSPoint *point = [AGSPoint pointWithX:poiPoint.longitude y:poiPoint.latitude spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326]];
                [polyline addPoint:point toPath:0];
            }
        }
        graphic.geometry = polyline;
        if (section.routeSection.navType == NAV_TYPE_CAR)
        {
            lineSymbol.color = [UIColor colorWithRed:0 green:0 blue:1 alpha:.7];
            lineSymbol.width = 2.0;
            lineSymbol.style = AGSSimpleLineSymbolStyleInsideFrame;
        }
        else if (section.routeSection.navType == NAV_TYPE_TOUR_CAR)
        {
            lineSymbol.color = [UIColor colorWithRed:174.0/255.0 green:252.0/255.0 blue:0 alpha:.7];
            lineSymbol.width = 5.0;
            lineSymbol.style = AGSSimpleLineSymbolStyleInsideFrame;
        }
        else if (section.routeSection.navType == NAV_TYPE_WALK)
        {
            lineSymbol.color = [UIColor colorWithRed:1.0 green:245.0/255.0 blue:0 alpha:.7];
            lineSymbol.width = 3.0;
            lineSymbol.style = AGSSimpleLineSymbolStyleInsideFrame;
        }
        [graphic setAttribute:INTTOOBJ(1) forKey:@"GraphicType"];
        
        graphic.symbol = lineSymbol;
        [graphicArray addObject:graphic];
        SAFERELEASE(polyline)
        SAFERELEASE(graphic)
    }
    if (!ISARRYCLASS(pois))
    {
        SAFERELEASE(graphicArray)
        SAFERELEASE(graphicAnnotationArray)
        return;
    }
    else
    {
        AGSGraphic *annotationGraphic = [[AGSGraphic alloc]init];
        AGSPictureMarkerSymbol *pictureMarkerSymbol;
        Section *section = [routeSectionData.routeFeatures objectAtIndex:0];
        PoiPoint *poiPoint = section.routeSection.startPoi;
        pictureMarkerSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"map_start.png"];
        AGSPoint *point = [AGSPoint pointWithX:poiPoint.longitude y:poiPoint.latitude spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326]];
        annotationGraphic.geometry = point;
        annotationGraphic.symbol = pictureMarkerSymbol;
        [annotationGraphic setAttribute:INTTOOBJ(2) forKey:@"GraphicType"];
        [graphicArray addObject:annotationGraphic];
        SAFERELEASE(annotationGraphic)
        if ([pois count] == 1)
        {
            PoiPoint *poiPoint = [pois objectAtIndex:0];
            AGSGraphic *annotationGraphic = [[AGSGraphic alloc]init];
            AGSPictureMarkerSymbol *pictureMarkerSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"map_end.png"];
            AGSPoint *point = [AGSPoint pointWithX:poiPoint.longitude y:poiPoint.latitude spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326]];
            annotationGraphic.geometry = point;
            annotationGraphic.symbol = pictureMarkerSymbol;
            [annotationGraphic setAttribute:INTTOOBJ(2) forKey:@"GraphicType"];
            [graphicArray addObject:annotationGraphic];
            SAFERELEASE(annotationGraphic)
        }
        else
        {
            for (int i = 0;i < [pois count];i++)
            {
                PoiPoint *poiPoint = [pois objectAtIndex:i];
                AGSGraphic *annotationGraphic = [[AGSGraphic alloc]init];
                AGSPictureMarkerSymbol *pictureMarkerSymbol;
                //终点、途经点
                if (i == [pois count] - 1)
                {
                    pictureMarkerSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"map_end.png"];
                }
                else if(i <= 10)
                {
                    pictureMarkerSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:[NSString stringWithFormat:@"map_poi_%d.png",i+1]];
                }
                else
                {
                    pictureMarkerSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"map_poi.png"];
                }
                AGSPoint *point = [AGSPoint pointWithX:poiPoint.longitude y:poiPoint.latitude spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326]];
                annotationGraphic.geometry = point;
                [annotationGraphic setAttribute:INTTOOBJ(2) forKey:@"GraphicType"];
                annotationGraphic.symbol = pictureMarkerSymbol;
                [graphicArray addObject:annotationGraphic];
                SAFERELEASE(annotationGraphic)
            }
        }
    }    
    
    //通过delegate 抛给 map
    if (delegate && [delegate respondsToSelector:@selector(centerNavLine:)])
    {
        [delegate centerNavLine:graphicArray];
    }
    SAFERELEASE(graphicArray)
    SAFERELEASE(graphicAnnotationArray)
}
- (void)startTest
{
    [[MapManager sharedInstanced] stopLocation];
    [testArray removeAllObjects];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Test_Line" ofType:@"txt"];
    NSString *points = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *jsonArray = [points componentsSeparatedByString:@","];
    for (int i = 0 ;i < jsonArray.count ;i+=2)
    {
        LoactionPoint *po = [[LoactionPoint alloc] init];
        po.longitude = [[jsonArray objectAtIndex:i] floatValue];
        po.latitude = [[jsonArray objectAtIndex:i+1] floatValue];
        [testArray addObject:po];
        SAFERELEASE(po)
    }
    [NSTimer scheduledTimerWithTimeInterval:NAV_SIMULATION_TIME_STEP target:self selector:@selector(runTestLocation) userInfo:nil repeats:YES];
}
- (void)runTestLocation
{
    if(testArray.count > 0)
    {
        LoactionPoint *p = [testArray objectAtIndex:0];
        [self didUpdateToLocation:p fromLocation:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TEST_LINE" object:p];
        [testArray removeObjectAtIndex:0];
    }
}

/**
 * 按照导航生成路径数据开始导航    
 *
 */
- (void)didUpdateToLocation:(LoactionPoint*)newLocation fromLocation:(LoactionPoint*)oldLocation
{
    
    if(bIsNavStop)      //正在景区内游玩/停车场逗留，需进行点面判断，是否离开当前景区/停车场范围
    {
        NavProcessingData *data = [_navData lastObject];
        MapRouteSectionResponse *routeResponse = (MapRouteSectionResponse*) data.runningRouteSection;
        Section* currentSection;
        if (ISARRYCLASS(routeResponse.routeFeatures) && routeResponse.routeFeatures.count > 0)
        {
            currentSection = [routeResponse.routeFeatures objectAtIndex:0];
            if(currentSection.routeSection.endPoi.poiID != -1)      //不是停靠点
            {
                NSString *buffer = nil;
                //只会在当前目标点为大景区，景点和停车场的时候走挂起逻辑
                switch (poiType)
                {
                    case POI_SCENIC:
                        buffer = [[DataAccessManager sharedDataModel] getBufferByType:nLastPOIID].BufferIn;
                        break;
                    case POI_SPOT:
                        buffer = [[DataAccessManager sharedDataModel] getSpotBufferByID:nLastPOIID];
                        break;
                    case POI_PARK:
                        buffer = [[DataAccessManager sharedDataModel] getParkBufferByID:nLastPOIID];
                        break;
                    default:
                        buffer = @"";
                        break;
                }
                AGSPolygon *bufferPolygon = [self createPolygon:buffer];
                if(bufferPolygon  == nil)
                {
                    bIsNavStop = NO;
                }
                AGSPoint * locationPt = [AGSPoint pointWithX:newLocation.longitude y:newLocation.latitude spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326 WKT:nil]];
                if(![bufferPolygon containsPoint:locationPt])       //已经不在当前景区/停车场范围内，开始导航
                {
                    bIsNavStop = NO;
                }
            }
        }
    }
    else        //正常导航
    {
        [self navWithLocation:newLocation.longitude withLa:newLocation.latitude];        
    }
    

}

#pragma mark - 构建polygon
- (AGSPolygon*) createPolygon:(NSString *) textBuffer
{
    AGSMutablePolygon *polygon = [[[AGSMutablePolygon alloc] initWithSpatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326 WKT:nil]] autorelease];
    [polygon addRingToPolygon];
    if (!textBuffer || [textBuffer isEqualToString:@""])
    {
        return nil;
    }
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



/**
 *
 *  模拟出不停的刷新定位点
 *
 */
- (void)startSimulationNav
{
    NavProcessingData *data = [_navData lastObject];
    //防止 实地导航 数据获取到时 delay 正好 回来，发现有数据 导致 又执行 模拟导航的问题
    if (!data.simulation)
    {
        return;
    }
    
    MapRouteSectionResponse * sr = data.runningRouteSection;
    NSArray *sections =  sr.routeFeatures;
    if (ISARRYCLASS(sections))
    if (sections.count == 0)
    {
        // 模拟导航结束
        //1.恢复地图页面
        if (delegate && [delegate respondsToSelector:@selector(reViewMapView)])
        {
            [delegate reViewMapView];
        }
        [self stopNav];
        return;
    }
    Section *fs = nil;
    SectionAttribute *sa = nil;
    if (sections.count > 0 && ((Section*)[sections objectAtIndex:0]).sectionAttributes.count > 0)
    {
        fs = [sections objectAtIndex:0];
        sa = [fs.sectionAttributes objectAtIndex:0];
    }
    else
    {
        return;     //数据错误
    }
    PoiPoint *lastPoint = nil;
    if (sa && ISARRYCLASS(sa.pointArray) && sa.pointArray.count > 0)
    {

        //当前feature已被舍弃，重新计算sa
        if (simulationPtsIndex == -1 || simulationPtsIndex >= sa.pointArray.count)
        {
            simulationPtsIndex = 0;
            [self performSelector:@selector(startSimulationNav) withObject:nil afterDelay:NAV_SIMULATION_TIME_STEP];
        }
        else
        {
            lastPoint = (PoiPoint*)[sa.pointArray objectAtIndex:simulationPtsIndex];
            if (lastPoint != nil)
            {
                if (delegate && [delegate respondsToSelector:@selector(simulation:withLat:)])
                {
                    [delegate simulation:lastPoint.longitude withLat:lastPoint.latitude];
                }
                [self navWithLocation:lastPoint.longitude withLa:lastPoint.latitude];
                simulationPtsIndex++;
                [self performSelector:@selector(startSimulationNav) withObject:nil afterDelay:NAV_SIMULATION_TIME_STEP];
            }
        }
        
    }
//    [self navWithLocation:118.838078 + 0.0002 withLa:32.047131];
//    [self performSelector:@selector(startSimulationNav) withObject:nil afterDelay:NAV_SIMULATION_TIME_STEP];
}


/**
 *
 *  负责计算导航，提供给实地导航与模拟导航
 *  
 */
- (void)navWithLocation:(double)lo withLa:(double)la
{
    double dis_navTurn;     //路口播报距离
    double dis_navTurnPre;      //路口预播报距离
    double dis_navDisToPoi;     //到达目标点距离
    NavProcessingData *data = [_navData lastObject];
    MapRouteSectionResponse *routeResponse = (MapRouteSectionResponse*) data.runningRouteSection;
    Section* currentSection;
    RouteSection* currentDirection = nil;     //当前大路段
    SectionAttribute* currentFeature = nil;       //当前小路段
    SectionAttribute* nextFeature = nil;      //下一小路段
    if (ISARRYCLASS(routeResponse.routeFeatures) && routeResponse.routeFeatures.count > 0)
    {
        currentSection = [routeResponse.routeFeatures objectAtIndex:0];
        currentDirection = currentSection.routeSection;
        if (currentSection.sectionAttributes != nil && currentSection.sectionAttributes.count > 0)
        {
            currentFeature = [currentSection.sectionAttributes objectAtIndex:0];
            lastNavType = currentDirection.navType;       //记录当前折向信息
        }
        else
        {
            return;//数据错误
        }
        if (currentSection.sectionAttributes.count > 1)
        {
            nextFeature = [currentSection.sectionAttributes objectAtIndex:1];
        }
        //根据当前出现方式，调整播报、预播报距离
        if (lastNavType == NAV_TYPE_WALK)
        {
            dis_navTurn = NAV_DIDTOTURN_WALK;
            dis_navTurnPre = NAV_DISTOTURNPRE_WALK;
            dis_navDisToPoi = NAV_DISTOPOI_WALK;
        }
        else
        {
            dis_navTurn = NAV_DIDTOTURN_CAR;
            dis_navTurnPre = NAV_DISTOTURNPRE_CAR;
            dis_navDisToPoi = NAV_DISTOPOI_CAR;
        }
    }
    else
    {
        //导航结束,恢复地图页
        simulationPtsIndex = -1;
        if (delegate && [delegate respondsToSelector:@selector(reViewMapView)])
        {
            [delegate reViewMapView];

        }

        //终止请求
        [[RouteNavManager sharedInstance] cancelRequest:self];
        
        //TODO 清除 导航数据
        [[MapManager sharedInstanced] unRegisterMapManagerNotification:self];
        [_navData removeLastObject];
        //清除线
        if (delegate && [delegate respondsToSelector:@selector(clearCenterNavLine)])
        {
            [delegate clearCenterNavLine];
        }
        return;
    }
    
    //当前feature的折线
    AGSGeometry *currentFeaturePolyline = [self createPolyline:currentFeature.pointArray];
    AGSGeometry *nextFeaturePolyline = nil;
    if (nextFeature)
    {
        nextFeaturePolyline = [self createPolyline:nextFeature.pointArray];
    }
    
    //当前点
    AGSPoint * locationPt = [AGSPoint pointWithX:lo y:la spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326 WKT:nil]];
    //当前点与当前feature折线的距离
    double dis1 = [self getDistanceFrom:locationPt To:currentFeaturePolyline];
    //当前点与下一个feature折线的距离
    double dis2 = -1;
    if (nextFeaturePolyline != nil)
    {
        dis2 = [self getDistanceFrom:locationPt To:nextFeaturePolyline];
    }
    //当前feature上的最后一个点
    AGSPoint * lastFeaturePt = [AGSPoint pointWithX:((PoiPoint*)[currentFeature.pointArray lastObject]).longitude y:((PoiPoint*)[currentFeature.pointArray lastObject]).latitude spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326 WKT:nil]];
    //当前点与当前feature的末点距离
    double dis3 = [PublicUtils GetDistanceS:locationPt.x withlat1:locationPt.y withlng2:lastFeaturePt.x withlat2:lastFeaturePt.y];
    //当前点与目标点距离(与当前feature的距离+剩余feature的长度)
    double dis4 = dis3;
    for (int i = 1; i < currentSection.sectionAttributes.count; i++)
    {
        SectionAttribute* tmpSection = currentSection.sectionAttributes[i];
        dis4 += tmpSection.length.doubleValue;
    }
    //更改UI
    [self NavActChangeUIDis:dis3 dis4:dis4];
    //点与折线距离小于容差，行驶在导航线路上，没有偏航
    if (dis1 < NAV_YAW_DISTANCE)
    {
        //当前feature的第一个点,更改UI，更改目的地名称
        if (simulationPtsIndex == 0)
        {
            lastPt = [currentFeature.pointArray objectAtIndex:0];       //记录上一路口
            [self NavActChangeUIName:currentDirection.endPoi.name];
        }
        //(路口预播报)即将到达下一路口，播报路口折向信息
        if (dis3 < dis_navTurnPre && nextFeature.isPreSpeak == NO)
        {
            [self NavActChangeUITurnImg:nextFeature.action];
            //路口折向信息
            NSString* strDir = [self getActionText:nextFeature.action];
            NSLog(@"_____________%@",strDir);
            [[TTSPlayer shareInstance] play:strDir playMode:TTS_PLAY_JUMP_QUEUE];
            nextFeature.isPreSpeak = YES;
        }
        //过了路口之后，折向图标变为直行
        if (dis3 > dis_navTurnPre && nextFeature.isPreSpeak == NO)
        {
            [self NavActChangeUITurnImg:esriDMTStraight];
        }
        //（路口播报）
        if (dis3 < dis_navTurn && nextFeature.isSpeak == NO)
        {
            //插播下一段路线信息
            [[TTSPlayer shareInstance] play:nextFeature.text playMode:TTS_PLAY_JUMP_QUEUE];
            nextFeature.isSpeak = YES;
        }
        //当前feature已走完，准备跳转到下一feature
        if (dis2 != -1 && dis2 <= dis1)
        {
            //移除当前feature
            if (routeResponse.routeFeatures.count > 0 && ((Section*)[routeResponse.routeFeatures objectAtIndex:0]).sectionAttributes.count > 0)
            {
                [((Section*)[routeResponse.routeFeatures objectAtIndex:0]).sectionAttributes removeObjectAtIndex:0];
                simulationPtsIndex = -1;
            }
            else
            {
                NSLog(@"模拟导航移除feature时出错");
                return;
            }
        }
        //到达目的地(当前大路段已经是最后的一小段，且距离POI小于容差，移除当前大路段并播报到达点信息)
        if (dis4 < dis_navDisToPoi)
        {
            poiType = [self NavActIsScenicOrPark:currentDirection.endPoi.poiID];
            //目标点是停车场或大景区,且导航模式为真实导航
            if (!data.simulation &&( poiType == POI_PARK || poiType == POI_SCENIC))
            {
                NSString *buffer = nil;
                if (poiType ==  POI_SCENIC)      //是大景区
                {
                    buffer = [[DataAccessManager sharedDataModel] getBufferByType:currentDirection.endPoi.poiID].BufferIn;
                }
                else    //是停车场
                {
                    buffer = [[DataAccessManager sharedDataModel] getParkBufferByID:currentDirection.endPoi.poiID];
                }
                //buffer 为空，无需挂起，直接继续导航
                if (!buffer || [buffer isEqualToString:@""])
                {
                    [self NavActReachToTarget:currentDirection withData:data withRouteResponse:routeResponse];
                    return;
                }
                AGSPolygon *bufferPolygon = [self createPolygon:buffer];
                if(bufferPolygon  == nil)
                {
                    return;
                }
                if([bufferPolygon containsPoint:locationPt])       //已经在当前景区/停车场范围内，开始挂起
                {
                    bIsNavStop = YES;
                    [self NavActReachToTarget:currentDirection withData:data withRouteResponse:routeResponse];      //到达目的地操作
                }
                else        //还未进入停车场/大景区的范围，不算到达
                {
                    return;
                }
                    
            }
            //目标点为其他无buffer的POI，直接挂起
            else
            {
                [self NavActReachToTarget:currentDirection withData:data withRouteResponse:routeResponse];
            }
            
        }
    }
    else//偏航处理
    {
        //01 首先判断是否在路线上
        while (routeResponse.routeFeatures.count > 0)//direction循环
        {
            Section *fSection = [routeResponse.routeFeatures objectAtIndex:0];
            while (fSection.sectionAttributes.count > 0)//feature循环
            {
                AGSGeometry *tmpFeaturePolyline = [self createPolyline:((SectionAttribute*)[fSection.sectionAttributes objectAtIndex:0]).pointArray];
                if(NAV_YAW_DISTANCE > [self getDistanceFrom:locationPt To:tmpFeaturePolyline])//获取所有feature中离点最近的feature
                {
                    //在路线上，找到当前所在feature
                    return;
                }
                else//否则移除当前feature
                {
                    //移除当前feature
                    [fSection.sectionAttributes removeObjectAtIndex:0];
                }
            }
            //移除当前大路段
            [routeResponse.routeFeatures removeObjectAtIndex:0];
        }
        NAV_TYPE navType = data.navType;
        //02 不在线路上，重新生成路线
//        NSLog(@"您已偏航，正在重新请求");
        [[TTSPlayer shareInstance] stopVideo];
        [[TTSPlayer shareInstance] play:@"您已偏航,正在重新生成路径" playMode:TTS_DEFAULT];
        [[MapManager sharedInstanced] unRegisterMapManagerNotification:self];
        NSMutableArray* navpts = [NSMutableArray array];
        for (PoiPoint *poi in data.navPoints)
        {
            PoiPoint *copyPoi=[PoiPoint pointWithName:poi.name withLongitude:poi.longitude withLatitude:poi.latitude withPoiID:poi.poiID];
            [navpts addObject:copyPoi];
        }
        
         [_navData removeAllObjects];
        if (lastNavType == NAV_TYPE_CAR)//出行方式为自驾时，需要添加路障信息
        {
            NSString *Barriers = nil;
            //一开始就偏航
            if (lastPt || lastPt.longitude || lastPt.latitude || (lastPt.longitude == 0 && lastPt.latitude == 0))
            {
                Barriers = @"";
            }
            else
            {
                Barriers = [NSString stringWithFormat:@"%f,%f",lastPt.longitude,lastPt.latitude];
            }
            [[MapManager sharedInstanced] startNav:navpts withType:navType withBarriers:Barriers];
        }
        else        //不需要添加路障信息
        {
            [[MapManager sharedInstanced] startNav:navpts withType:navType withBarriers:@""];
        }
        if (delegate && [delegate respondsToSelector:@selector(reViewMapView)])
        {
            [delegate reViewMapView];
        }
    }
    
}

- (void)NavActChangeUIName:(NSString *)targetName
{
    if (delegate && [delegate respondsToSelector:@selector(changeTarget:)])
    {
        [delegate changeTarget:targetName];
    }
}

- (POI_TYPE) NavActIsScenicOrPark:(int)ID
{
    if ([[DataAccessManager sharedDataModel] isScenic:ID])
    {
        return POI_SCENIC;
    }
    if ([[DataAccessManager sharedDataModel] isPark:ID])
    {
        return POI_PARK;
    }
    return [[DataAccessManager sharedDataModel] getPOITypeByID:ID].intValue;
    
}

- (void)NavActChangeUIDis:(double)dis3 dis4:(double)dis4
{
    //更改UI,更改目标距离
    if (delegate && [delegate respondsToSelector:@selector(changeDis:TurnDis:)])
    {
        [delegate changeDis:dis4 TurnDis:dis3];
    }
}

- (void) NavActChangeUITurnImg:(MAP_DIRECTION)action
{
    if (delegate && [delegate respondsToSelector:@selector(changeDirections:)])
    {
        [delegate changeDirections:action];
    }
}

//到达目的地操作
//01 TTS播报到达
//02 data.navPoints 移除一条信息
//03 判断是否是景点，是否挂起
//04 移除当前section
- (void) NavActReachToTarget:(RouteSection*)currentDirection withData:(NavProcessingData*)data withRouteResponse:(MapRouteSectionResponse*)routeResponse
{
    //到达目标点，不是中间点
    if (currentDirection.endPoi.poiID != -1)
    {
        //                NSLog(@"%@",[NSString stringWithFormat:@"您已到达%@",currentDirection.endPoi.name]);
        NSString* ttsText = [NSString stringWithFormat:@"您已到达%@",currentDirection.endPoi.name];
        //插播
        [[TTSPlayer shareInstance] play:ttsText playMode:TTS_PLAY_JUMP_QUEUE];
        //Todo 界面显示到达目标点
        //最近一个待玩景点节点
        if (data.navPoints.count == 0)
        {
            return;
        }
        PoiPoint* poipt = (PoiPoint*)[data.navPoints objectAtIndex:0];
        //到达的目的地是否是景点
        if (poipt.poiID == currentDirection.endPoi.poiID)
        {
            if (data.navPoints.count > 0)
            {
                [data.navPoints removeObjectAtIndex:0];//移除已到达景点
                data.isInsertedPOI = NO;
            }
            else
            {
                NSLog(@"in NavProcessingCenter Class in function navWithLocation:withLa in [data.navPoints removeObjectAtIndex:0] error");
                return;
            }
        }
        if (!data.simulation)       //真实导航
        {
            if(poiType == POI_SPOT)     //是景点
            {
                bIsNavStop = YES;//停止导航，等待用户走出当前buffer
            }
            nLastPOIID = currentDirection.endPoi.poiID;
            
        }
        //导航结束
        if (data.navPoints.count == 0)
        {
            bIsNavStop = NO;
        }
    }
    //移除当前大路段
    [routeResponse.routeFeatures removeObjectAtIndex:0];
    simulationPtsIndex = 0;
}

- (double) getDistanceFrom:(AGSGeometry*)geo1 To:(AGSGeometry*)geo2
{
    AGSGeometryEngine * geoEngine = [[AGSGeometryEngine alloc] init];
    double dis = [geoEngine distanceFromGeometry:geo1 toGeometry:geo2] * 3600 * 30.87;
    SAFERELEASE(geoEngine);
    return dis;
}

#pragma mark - 根据行驶方向，获取文本
- (NSString*) getActionText:(MAP_DIRECTION)action
{
    switch (action) {
        case esriDMTStop:
            return @"即将到达停靠点";
            break;
        case esriDMTBearLeft:
            return @"请靠左行驶";
            break;
        case esriDMTBearRight:
            return @"靠右行驶";
            break;
        case esriDMTDepart:
            return @"离开停靠点";
            break;
        case esriDMTEndOfFerry:
            return @"即将离开渡轮";
            break;
        case esriDMTFerry:
            return @"即将到达渡轮";
            break;
        case esriDMTForkCenter:
            return @"保持直行";
            break;
        case esriDMTForkLeft:
            return @"请靠左行驶";
            break;
        case esriDMTForkRight:
            return @"请靠右行驶";
            break;
        case esriDMTHighwayChange:
            return @"即将到达另一高速公路";
            break;
        case esriDMTHighwayExiT:
            return @"即将离开高速公路";
            break;
        case esriDMTHighwayMerge:
            return @"路口即将变窄";
            break;
        case esriDMTRoundabout:
            return @"即将进入环状道路";
            break;
        case esriDMTSharpLeft:
            return @"下一路口左后转弯";
            break;
        case esriDMTSharpRight:
            return @"下一路口右后转弯";
            break;
        case esriDMTStraight:
            return @"保持直行";
            break;
        case esriDMTTripItem:
            return @"行程规划项目";
            break;
        case esriDMTTurnLeft:
            return @"下一路口左转";
            break;
        case esriDMTTurnRight:
            return @"下一路口右转";
            break;
        case esriDMTUnknown:
            return @"";
            break;
        case esriDMTUTurn:
            return @"下一路口优型转弯";
            break;
        default:
            return @"";
            break;
    }
}

#pragma mark - 比较两个Geometry是否相同
- (BOOL) isEqualFrom:(AGSGeometry*)geo1 to:(AGSGeometry*)geo2
{
    if( [geo1 isKindOfClass:[AGSPoint class]] && [geo2 isKindOfClass:[AGSPoint class]])
    {
        return [((AGSPoint*)geo1) isEqualToPoint:(AGSPoint*)geo2];
    }
    if ([geo1 isKindOfClass:[AGSMutablePolyline class]] && [geo2 isKindOfClass:[AGSMutablePolyline class]])
    {
        return [((AGSMutablePolyline*)geo1) isEqualToPolyline:(AGSMutablePolyline*)geo2];
    }
    return NO;
}

#pragma mark - 构建polygon
- (AGSGeometry*) createPolyline:(NSMutableArray *) array
{
    AGSMutablePolyline *polygon = [[[AGSMutablePolyline alloc] initWithSpatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326 WKT:nil]] autorelease];
    [polygon addPathToPolyline];
    for (int i = 0;i<array.count;i++)
    {
        [polygon addPointToPath:[AGSPoint pointWithX:((PoiPoint*)[array objectAtIndex:i]).longitude y:((PoiPoint*)[array objectAtIndex:i]).latitude spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326 WKT:nil]]];
    }
    //两点相同时，为点对象
    if (polygon.numPoints == 2 && [[polygon pointOnPath:0 atIndex:0] isEqualToPoint:[polygon pointOnPath:0 atIndex:1]]) {
        return [polygon pointOnPath:0 atIndex:0];
    }
    return polygon;
}

#pragma mark - callBack
- (void)callBackToUI:(HttpBaseResponse *)response
{
    if (response.cc_cmd_code == CC_GET_ROUTE_SECTION_CAR || response.cc_cmd_code == CC_GET_ROUTE_SECTION_TOUR_CAR || response.cc_cmd_code == CC_GET_ROUTE_SECTION_WALK)
    {
        MapRouteSectionResponse *routeSection = (MapRouteSectionResponse*)response;
        if (response.error_code == E_HTTPSUCCEES)
        {
         
            [[TTSPlayer shareInstance] stopVideo];
            //切换地图为导航页面
            
            if (delegate && [delegate respondsToSelector:@selector(viewNavMapView)])
            {
                [delegate viewNavMapView];
            }
            
            //返回路径 提供分析
            NavProcessingData *data = [_navData lastObject];
            data.runningRouteSection = routeSection;
            if (response.cc_cmd_code == CC_GET_ROUTE_SECTION_CAR)
            {
                data.navType = NAV_TYPE_CAR;
            }
            else if (response.cc_cmd_code == CC_GET_ROUTE_SECTION_TOUR_CAR)
            {
                data.navType = NAV_TYPE_TOUR_CAR;
            }
            else if (response.cc_cmd_code == CC_GET_ROUTE_SECTION_WALK)
            {
                data.navType = NAV_TYPE_WALK;
            }
            
            if (data)
            {
                //画线
                [self drawNavLine:data.runningRouteSection withNavEndPois:data.navPoints];
                
                if (data.simulation)        //模拟导游
                {
                    [[MapManager sharedInstanced] unRegisterMapManagerNotification:self];
                    //模拟导航，模拟定位点
                    [self startSimulationNav];
                }
                else        //实地导游
                {
                    LoactionPoint *location = [[[LoactionPoint alloc] init] autorelease];
                    location.longitude = [MapManager sharedInstanced].oldLocation2D.longitude;
                    location.latitude = [MapManager sharedInstanced].oldLocation2D.latitude;
                    [self didUpdateToLocation:location fromLocation:nil];
                    //1.判断当前是否开启定位
                    //2.定位模式是否为地图动 点不动
                    if (delegate && [delegate respondsToSelector:@selector(realNavigation)])
                    {
                        [delegate realNavigation];
                    }
                    
                    //开始打开测试路径
                    [self startTest];
                    //注册 获取定位点
                    [[MapManager sharedInstanced] registerMapManagerNotification:self];
                }
            }
        }
        else
        {
            //失败,具体看错误码
            NSString *errorMessage = @"导航失败,请重试.";
            errorMessage = response.error_code == E_HTTPERR_TIMEOUT ? @"请求超时,请检查网络配置.":errorMessage;
            [[TTSPlayer shareInstance] play:errorMessage playMode:TTS_DEFAULT];
        }
    }
    else
    {
        MapRouteNavResponse *mapResponse = (MapRouteNavResponse*)response;
        NAV_TYPE type = NAV_TYPE_UNKNOW;
        
        switch (response.cc_cmd_code)
        {
            case CC_GET_WORK_ROUTE:
            {
                type = NAV_TYPE_WALK;
                break;
            }
            case CC_GET_TOURCAR_ROUTE:
            {
                type = NAV_TYPE_TOUR_CAR;
                break;
            }
            case CC_GET_CAR_ROUTE:
            {
                type = NAV_TYPE_CAR;
                break;
            }
            default:
                break;
        }
        if (response.error_code == E_HTTPSUCCEES)
        {
            // 构建 line
            AGSMutablePolyline *line = [[[AGSMutablePolyline alloc] init] autorelease];
            [line addPathToPolyline];
            for (Feature *feature in mapResponse.features)
            {
                NSArray *routePoints =  feature.routePoints;
                for (PoiPoint *poi in routePoints)
                {
                    AGSPoint *routePoint = [AGSPoint pointWithX:poi.longitude y:poi.latitude spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326 WKT:nil]];
                    [line addPoint:routePoint toPath:0];
                }
            }
            
            AGSEnvelope *envelop = [AGSEnvelope envelopeWithXmin:mapResponse.xmin ymin:mapResponse.ymin xmax:mapResponse.xmax ymax:mapResponse.ymax spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326 WKT:nil]];
            if (delegate && [delegate respondsToSelector:@selector(centeravLine:withEnvelope:withPoints:withType:)])
            {
                [delegate centeravLine:line withEnvelope:envelop withPoints:mapResponse.points withType:type];
            }
        }
        else
        {
            if (delegate && [delegate respondsToSelector:@selector(centerFailed:)])
            {
                [delegate centerFailed:type];
            }
        }
    }
}

- (void)cancelRrequest:(id)requester
{
    [[RouteNavManager sharedInstance] cancelRequest:requester];
}
- (void)dealloc
{
    SAFERELEASE(testArray)
    SAFERELEASE(_navData)
    [[MapManager sharedInstanced] unRegisterMapManagerNotification:self];
    SAFERELEASE(routeStructFactory)
    delegate = nil;
    [[RouteNavManager sharedInstance] cancelRequest:self];
    [super dealloc];
}
@end



@implementation NavProcessingData
@synthesize runningRouteSection,navPoints,simulation,navType,isInsertedPOI;
- (id)init
{
    self = [super init];
    if (self)
    {
        NSMutableArray *tmpmb = [[NSMutableArray alloc] init];
        self.navPoints = tmpmb;
        SAFERELEASE(tmpmb)
    }
    return self;
}
- (void)dealloc
{
    SAFERELEASE(runningRouteSection)
    SAFERELEASE(navPoints)
    [super dealloc];
}
@end
