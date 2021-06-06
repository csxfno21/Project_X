//
//  NavCenterLineDrawer.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-10-10.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "NavCenterLineDrawer.h"

@implementation NavCenterLineDrawer

- (id)initWithMapView:(AGSMapView*)mapView
{
    if (self = [super init])
    {
        
        layer = [AGSGraphicsLayer graphicsLayer];
        [mapView addMapLayer:layer withName:@"NavCenterLineDrawerLayer"];
        contentView = mapView;
    }
    return self;
}

- (void)drawLineWith:(NSArray *)graphics
{
    for (id obj in graphics)
    {
        if ([obj isKindOfClass:[AGSGraphic class]])
        {
            [layer addGraphic:obj];
        }
    }
}

- (void)registerMapManagerNotification
{
    [[MapManager sharedInstanced] registerMapManagerNotification:self];
}
- (void)unRegisterMapManagerNotification
{
    [[MapManager sharedInstanced] unRegisterMapManagerNotification:self];
}
- (void)didUpdateHeading:(CLHeading *)newHeading
{
    [self headingPoingGraphic:+newHeading.magneticHeading];
}
- (void)headingPoingGraphic:(double)angel
{
    NSArray *pointGraphics = layer.graphics;
    for (AGSGraphic *g in pointGraphics)
    {
       NSNumber *num = [g attributeForKey:@"GraphicType"];
        if (!ISNIL(num) && !ISNULLCLASS(num) && [num intValue] == 2)//点
        {
            if ([g.symbol isKindOfClass:[AGSPictureMarkerSymbol class]])
            {
                AGSPictureMarkerSymbol *poiSymbol = (AGSPictureMarkerSymbol*)g.symbol;
                poiSymbol.angle = angel;
            }
        }
    }
}
- (void)clearGraphic
{
    [layer removeAllGraphics];
}

-(void)dealloc
{
    [[MapManager sharedInstanced] unRegisterMapManagerNotification:self];
    [self clearGraphic];
    [super dealloc];
}
@end
