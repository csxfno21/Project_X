//
//  LocationPoint.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-28.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "LocationPoint.h"

@implementation LocationPoint
@synthesize delegate;

- (id)initWithMapView:(AGSMapView*)mapView
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testLine:) name:@"TEST_LINE" object:nil];
        contentMap = mapView;
        layer = [AGSGraphicsLayer graphicsLayer];
        [contentMap addMapLayer:layer withName:@"GraphicsLayer"];
        locationGr = [[AGSGraphic alloc]init];
        sumbol = [[AGSPictureMarkerSymbol alloc] initWithImageNamed:@"map-loctaion.png"];
        locationGr.symbol = sumbol;
        
        fillBuffGr = [[AGSGraphic alloc] init];
        fillsymbol = [[AGSSimpleFillSymbol alloc] initWithColor:[UIColor colorWithRed:198.0f/255.0f green:226.0f/255.0f blue:1.0 alpha:.6f] outlineColor:[UIColor whiteColor]];
        fillsymbol.style = AGSSimpleFillSymbolStyleSolid;
        fillBuffGr.symbol = fillsymbol;
        
        simulationGr = [[AGSGraphic alloc] init];
        
        AGSPictureMarkerSymbol *simulationSymbol = [[AGSPictureMarkerSymbol alloc] initWithImageNamed:@"LocationDisplay.png"];
        simulationGr.symbol = simulationSymbol;
        SAFERELEASE(simulationSymbol);
    }
    return self;
}

/**
 *  模拟导航点
 *  lon  lat
 */
- (void)setSimulationPoint:(double)lon withLat:(double)lat
{
    if (!simulationGr.layer)
    {
        [layer addGraphic:simulationGr];
    }
    AGSPoint *point = [[[AGSPoint alloc] initWithX:lon y:lat spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326]] autorelease];
    simulationGr.geometry = point;
    
    [contentMap centerAtPoint:point animated:YES];
}

- (void)unVisableSimulationPoint
{
    [layer removeGraphic:simulationGr];
}
- (void)startLocation
{
    [[MapManager sharedInstanced] registerMapManagerNotification:self];
//    [[MapManager sharedInstanced] startUpdateHeading];
    
//    [layer addGraphic:fillBuffGr];
    [layer addGraphic:locationGr];
    
    AGSPoint *point = [[[AGSPoint alloc] initWithX:[MapManager sharedInstanced].oldLocation2D.longitude y:[MapManager sharedInstanced].oldLocation2D.latitude spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326]] autorelease];
    //点在景区外时，连线到最近的大门口
    if ([MapManager sharedInstanced].currentScenic == SCENIC_OUT || [MapManager sharedInstanced].currentScenic == SCENIC_UNKNOW)
    {
        [self drawLine:point];
    }
    else
    {
        if(point && !point.isEmpty)
        {
            [layer removeGraphic:lineGr];
            SAFERELEASE(lineGr)
            if (contentMap.mapScale > MAP_DIDLOAD_SCALE)
            {
                [contentMap zoomToScale:MAP_DIDLOAD_SCALE withCenterPoint:point animated:YES];
                if (delegate && [delegate respondsToSelector:@selector(loctationPointScale)])
                {
                    [delegate loctationPointScale];
                }
            }
            else
            [contentMap centerAtPoint:point animated:YES];
            locationGr.geometry = point;
            AGSGeometryEngine *agengine = [[AGSGeometryEngine alloc] init];
            
            fillBuffGr.geometry = [agengine bufferGeometry:point byDistance:[MapManager sharedInstanced].oldHorizontalAccuracy];
            SAFERELEASE(agengine)
//            fillBuffGr.geometry = [self createPolygon:CTDGEODETICMake([MapManager sharedInstanced].oldLocation2D.longitude, [MapManager sharedInstanced].oldLocation2D.latitude, [MapManager sharedInstanced].altitude) withRadius:[MapManager sharedInstanced].oldHorizontalAccuracy withAngle:1];
            
        }
    }
}

- (AGSPolygon*)createPolygon:(CTDGEODETIC)geo withRadius:(double)radius withAngle:(double)angle
{
    
    AGSMutablePolygon *polygon = [[[AGSMutablePolygon alloc] initWithSpatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326 WKT:nil]] autorelease];
    [polygon addRingToPolygon];
    CTDGEODETIC centerPoint = CTDGEODETICMake(geo.longitude, geo.latitude, geo.altitude);
    
    for (int i = 0; i < 360 / angle ; i ++ )
    {
        CTDGEODETIC point = [PublicUtils GetCartesianCoordinate:centerPoint withRadius:radius withAngle:angle * (i+1)];
        [polygon addPointToRing:[AGSPoint pointWithX:point.longitude y:point.latitude spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326 WKT:nil]]];
    }
    
    return polygon;
}
- (void)setRotateType:(LOCATION_TYPE)rotateType
{
    _rotateType = rotateType;
    switch (rotateType)
    {
        case LOCATION_POINT_ROTATE:
        case LOCATION_DEFAULT:
        {
            [contentMap setRotationAngle:0.0 animated:YES];
            if (delegate && [delegate respondsToSelector:@selector(loctationPointHeading:)])
            {
                [delegate loctationPointHeading:0.0];
            }
            sumbol.image = [UIImage imageNamed:@"map-loctaion.png"];
            break;
        }
        case LOCATION_MAP_ROTATE:
        {
            [contentMap setRotationAngle:sumbol.angle animated:YES];
            if (delegate && [delegate respondsToSelector:@selector(loctationPointHeading:)])
            {
                [delegate loctationPointHeading:sumbol.angle];
            }
            sumbol.image = [UIImage imageNamed:@"map-loctaion-s.png"];
            break;
        }
        case LOCATION_NO:
        {
            [contentMap setRotationAngle:0.0 animated:YES];
            if (delegate && [delegate respondsToSelector:@selector(loctationPointHeading:)])
            {
                [delegate loctationPointHeading:0.0];
            }
//            [self stopLoctation];
            break;
        }
        default:
            break;
    }
}
- (void)stopLoctation
{
    [[MapManager sharedInstanced] unRegisterMapManagerNotification:self];
//    [[MapManager sharedInstanced] stopUpdateHeading];
    [layer removeAllGraphics];
    [layer refresh];
    SAFERELEASE(lineGr)
}

- (void)testLine:(NSNotification*)ni
{
    LoactionPoint *lo =ni.object;
    AGSPoint *point = [[[AGSPoint alloc] initWithX:lo.longitude y:lo.latitude spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326]] autorelease];
    SAFERELEASE(lineGr)
    [contentMap centerAtPoint:point animated:YES];
    
    locationGr.geometry = point;
    AGSGeometryEngine *agengine = [[AGSGeometryEngine alloc] init];
    fillBuffGr.geometry = [agengine bufferGeometry:point byDistance:[MapManager sharedInstanced].oldHorizontalAccuracy];
    SAFERELEASE(agengine)

    [layer refresh];
}
#pragma mark - Location delegate
//定位点变化
- (void)didUpdateToLocation:(LoactionPoint *)newLocation fromLocation:(LoactionPoint *)oldLocation
{
    AGSPoint *point = [[[AGSPoint alloc] initWithX:newLocation.longitude y:newLocation.latitude spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326]] autorelease];

    if ([MapManager sharedInstanced].currentScenic == SCENIC_OUT || [MapManager sharedInstanced].currentScenic == SCENIC_UNKNOW)
    {
        [self drawLine:point];
    }
    else
    {
        if (lineGr)
        {
            [layer removeGraphic:lineGr];
            SAFERELEASE(lineGr)
        }

        [contentMap centerAtPoint:point animated:YES];
           
        locationGr.geometry = point;
        AGSGeometryEngine *agengine = [[AGSGeometryEngine alloc] init];
        fillBuffGr.geometry = [agengine bufferGeometry:point byDistance:[MapManager sharedInstanced].oldHorizontalAccuracy];
        SAFERELEASE(agengine)
    }
    
    
    [layer refresh];
}

//绘制线
- (void)drawLine:(AGSPoint*)locationPoint
{
    //如果定位成功 并且定位在景区外 或者未知时候 设中心点为最近的景区入口，并且连接为线
    if(lineGr == nil)
    {
        lineGr = [[AGSGraphic alloc] init];

        AGSSimpleLineSymbol *lineSymbol = [AGSSimpleLineSymbol simpleLineSymbolWithColor:[UIColor redColor] width:1.0f];
        lineSymbol.style = AGSSimpleLineSymbolStyleSolid;
        
        lineGr.symbol = lineSymbol;
        
        [layer addGraphic:lineGr];
    }
    
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
        double dis = [PublicUtils GetDistanceS:locationPoint.x withlat1:locationPoint.y withlng2:[entity.NavLng doubleValue] withlat2:[entity.NavLat doubleValue]];
        if(distance == 0.0)distance = dis;
        if(distance > dis)
        {
            distance = dis;
            index = i;
        }
        
    }
    
    ZS_CommonNav_entity *entity = [poi objectAtIndex:index];
    AGSPoint *pt2 = [[[AGSPoint alloc]initWithX:[entity.NavLng doubleValue] y:[entity.NavLat doubleValue] spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326 WKT:nil]] autorelease];
    if(pt2 && !pt2.isEmpty)
    {
        [contentMap centerAtPoint:pt2 animated:YES];
        AGSMutablePolyline *line = [[[AGSMutablePolyline alloc] init] autorelease];
        [line addPathToPolyline];
        [line addPoint:locationPoint toPath:0];
        [line addPoint:pt2 toPath:0];
        lineGr.geometry = line;
    }
}

//角度变化
- (void)didUpdateHeading:(CLHeading *)newHeading
{
    switch (self.rotateType)
    {
        case LOCATION_DEFAULT://都不动
        {
            if (sumbol.angle != 0.0)
            {
               sumbol.angle = 0.0;
                if (delegate && [delegate respondsToSelector:@selector(loctationPointHeading:)])
                {
                    [delegate loctationPointHeading:sumbol.angle];
                }
            }
            break;
        }
        case LOCATION_POINT_ROTATE://点动，地图不动
        {
            if (sumbol.angle != newHeading.magneticHeading)
            {
                sumbol.angle = newHeading.magneticHeading;
            }
            
            break;
        }
        case LOCATION_MAP_ROTATE:  //地图动 点不动
        {
            [contentMap setRotationAngle:newHeading.magneticHeading animated:YES];
            sumbol.angle = + contentMap.rotationAngle;
            if (delegate && [delegate respondsToSelector:@selector(loctationPointHeading:)])
            {
                [delegate loctationPointHeading:sumbol.angle];
            }
            break;
        }
        default:
            break;
    }
    
//    [layer refresh];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TEST_LINE" object:nil];
    SAFERELEASE(simulationGr)
    [[MapManager sharedInstanced] unRegisterMapManagerNotification:self];
    delegate = nil;
    SAFERELEASE(locationGr)
    SAFERELEASE(sumbol)
    SAFERELEASE(fillBuffGr)
    SAFERELEASE(fillsymbol)
    [layer removeAllGraphics];
    layer = nil;
    [super dealloc];
}
@end
