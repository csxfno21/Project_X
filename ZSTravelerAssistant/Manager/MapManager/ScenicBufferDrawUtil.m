//
//  ;
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-29.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "ScenicBufferDrawUtil.h"

@implementation ScenicBufferDrawUtil

- (id)initWithMapView:(AGSMapView*)mapView
{
    self = [super init];
    if (self)
    {
//        ZS_Scenic_Buffer_entity *zsfjq = [[DataAccessManager sharedDataModel] getBufferByType:SCENIC_IN];
//        ZS_Scenic_Buffer_entity *mxl = [[DataAccessManager sharedDataModel] getBufferByType:SCENIC_MXL];
//        ZS_Scenic_Buffer_entity *lgs = [[DataAccessManager sharedDataModel] getBufferByType:SCENIC_LGS];
//        ZS_Scenic_Buffer_entity *zsl = [[DataAccessManager sharedDataModel] getBufferByType:SCENIC_ZSL];
        NSString *str = [[DataAccessManager sharedDataModel] getSpotBufferByID:1112];
        AGSGraphicsLayer *bufferLayer = [[[AGSGraphicsLayer alloc] init] autorelease];
//        [self drawGraphic:zsfjq.BufferIn withLayer:bufferLayer withColor:[UIColor redColor]];
//        [self drawGraphic:zsfjq.BufferOut withLayer:bufferLayer withColor:[UIColor blackColor]];
//        [self drawGraphic:mxl.BufferIn withLayer:bufferLayer withColor:[UIColor redColor]];
//        [self drawGraphic:mxl.BufferOut withLayer:bufferLayer withColor:[UIColor blackColor]];
//        [self drawGraphic:lgs.BufferIn withLayer:bufferLayer withColor:[UIColor redColor]];
//        [self drawGraphic:lgs.BufferOut withLayer:bufferLayer withColor:[UIColor blackColor]];
        [self drawGraphic:str withLayer:bufferLayer withColor:[UIColor redColor]];
//        [self drawGraphic:zsl.BufferOut withLayer:bufferLayer withColor:[UIColor blackColor]];
        
//        NSArray *allSpeakContent = [[DataAccessManager sharedDataModel] getAllSpotSpeak];
//        for (ZS_SpotSpeak_Entity *entity in allSpeakContent)
//        {
//            ZS_CommonNav_entity * spotEntity = [[DataAccessManager sharedDataModel] getPOI:entity.SpotID.intValue];
//            if (spotEntity)
//            {
//                AGSGraphic *graphic = [[[AGSGraphic alloc] init] autorelease];
//                 AGSPoint *pt = [AGSPoint pointWithX:[spotEntity.NavLng doubleValue] y:[spotEntity.NavLat doubleValue] spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326 WKT:nil]];
//                graphic.geometry = pt;
//                
//                AGSSimpleMarkerSymbol *symbol = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:[UIColor redColor]];
//                symbol.style = AGSSimpleFillSymbolStyleSolid;
//                graphic.symbol = symbol;
//                [bufferLayer addGraphic:graphic];
//                
//            }
//             [self drawGraphic:entity.SpotBuffer withLayer:bufferLayer withColor:[UIColor yellowColor]];
//            
//        }
        
        [mapView addMapLayer:bufferLayer withName:@"ScenicBufferDrawUtilLayer"];
    }
    return self;
}
- (void)drawGraphic:(NSString*)buffer withLayer:(AGSGraphicsLayer*)layer withColor:(UIColor*)color
{
    AGSGraphic *graphic = [[[AGSGraphic alloc] init] autorelease];
    AGSMutableMultipoint *mutablePt = [[[AGSMutableMultipoint alloc] initWithSpatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326 WKT:nil]] autorelease];
    
    AGSMutablePolygon *ZSJQpolygon = [[[AGSMutablePolygon alloc] initWithSpatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326 WKT:nil]] autorelease];
    [ZSJQpolygon addRingToPolygon];
    NSArray * zsfjqbufferIn = [buffer componentsSeparatedByString:@","];
    for (int i = 0;i<zsfjqbufferIn.count;i++)
    {
        if(i%2 == 0)
        {
            AGSPoint *pt = [AGSPoint pointWithX:[[zsfjqbufferIn objectAtIndex:i] doubleValue] y:[[zsfjqbufferIn objectAtIndex:i+1] doubleValue] spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326 WKT:nil]];
            [mutablePt addPoint:pt];
            
            [ZSJQpolygon addPointToRing:[AGSPoint pointWithX:[[zsfjqbufferIn objectAtIndex:i] doubleValue] y:[[zsfjqbufferIn objectAtIndex:i+1] doubleValue] spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326 WKT:nil]]];
        }
    }
    AGSSimpleFillSymbol *symbol = [AGSSimpleFillSymbol simpleFillSymbolWithColor:[UIColor colorWithRed:.2 green:.2 blue:.2 alpha:.3] outlineColor:color];
    symbol.style = AGSSimpleFillSymbolStyleSolid;
    
    graphic.symbol = symbol;
    graphic.geometry = ZSJQpolygon;
    [layer addGraphic:graphic];
    
}
@end
