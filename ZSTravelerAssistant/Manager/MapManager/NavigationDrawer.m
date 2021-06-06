//
//  NavigationDrawer.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-9-12.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "NavigationDrawer.h"


#define COLOR_WITH_TYPE(type) (type == NAV_TYPE_WALK) ? [UIColor colorWithRed:1.0 green:0 blue:0 alpha:.7] :((type == NAV_TYPE_CAR) ? [UIColor colorWithRed:.5 green:0 blue:0.5 alpha:.7] :[UIColor colorWithRed:.6 green:.4 blue:.6 alpha:.7])
@implementation NavigationDrawer

- (id)initWithMapView:(AGSMapView*)mapView
{
    if (self = [super init])
    {
        layer = [AGSGraphicsLayer graphicsLayer];
        [mapView addMapLayer:layer withName:@"NavigationLineLayer"];
        contentView = mapView;
    }
    return self;
}

- (void)drawLineWith:(AGSPolyline*)line withPoints:(NSArray*)point withType:(NAV_TYPE)type
{
    AGSGraphic *lineGraphic = [[AGSGraphic alloc] init];
    AGSSimpleLineSymbol *lineSymbol = [AGSSimpleLineSymbol simpleLineSymbolWithColor:COLOR_WITH_TYPE(type) width:4.0f];
    lineSymbol.style = AGSSimpleLineSymbolStyleSolid;
    lineGraphic.symbol = lineSymbol;
    lineGraphic.geometry = line;
    [layer addGraphic:lineGraphic];
    SAFERELEASE(lineGraphic)
    
    for (PoiPoint *poi in point)
    {
        AGSPoint *agsPoint = [AGSPoint pointWithX:poi.longitude y:poi.latitude spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326 WKT:nil]];
        AGSGraphic *pointGraphic = [[[AGSGraphic alloc] init] autorelease];
        AGSPictureMarkerSymbol *markSymbol = [[[AGSPictureMarkerSymbol alloc] initWithImageNamed:@"map-poi.png"] autorelease];
        markSymbol.offset = CGPointMake(7, 14);
        
        pointGraphic.symbol = markSymbol;
        pointGraphic.geometry = agsPoint;
        NSString *title = @"";
        if (type == NAV_TYPE_WALK)
        {
            title = [Language stringWithName:ROUTE_WORK];
        }
        else if(type == NAV_TYPE_CAR)
        {
            title = [Language stringWithName:ROUTE_CAR];
        }
        else if(type == NAV_TYPE_TOUR_CAR)
        {
            title = [Language stringWithName:ROUTE_TOUR_CAR];
        }
        else
        {
            title = [Language stringWithName:ROUTE_UNKNOW];
        }
        [pointGraphic setAttribute:[NSNumber numberWithBool:YES] forKey:@"ROUTE_LINE_POI"];
        [pointGraphic setAttribute:title forKey:@"NAME"];
        [pointGraphic setAttribute:poi.name forKey:@"DETAIL"];
        pointGraphic.infoTemplateDelegate = [[NavPoiTemplateDelegate alloc] init];
        [layer addGraphic:pointGraphic];
        
    }
}

- (void)clearGraphic
{
    [layer removeAllGraphics];
}

- (void)dealloc
{
    
    [super dealloc];
}
@end

@implementation NavPoiTemplateDelegate

- (UIView *)customViewForGraphic:(AGSGraphic *)graphic screenPoint:(CGPoint)screen mapPoint:(AGSPoint *)mapPoint
{
    UIView *view = [[[UIView alloc] init] autorelease];
    NSString *name = [graphic attributeAsStringForKey:@"NAME"];
    NSString *detail = [graphic attributeAsStringForKey:@"DETAIL"];
    UIFont *titleFont = [UIFont boldSystemFontOfSize:14];
    CGSize titleSize = [name sizeWithFont:titleFont constrainedToSize:CGSizeMake(200, 15) lineBreakMode:NSLineBreakByWordWrapping];
    
    UIFont *detailFont = [UIFont systemFontOfSize:11];
    CGSize detailSize = [detail sizeWithFont:detailFont constrainedToSize:CGSizeMake(200, 15) lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleSize.width, titleSize.height)] autorelease];
    UILabel *detailLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, titleSize.height + 3, detailSize.width, detailSize.height)] autorelease];
    titleLabel.font = titleFont;
    detailLabel.font = detailFont;
    
    titleLabel.backgroundColor = [UIColor clearColor];
    detailLabel.backgroundColor = [UIColor clearColor];
    
    titleLabel.textColor = [UIColor whiteColor];
    detailLabel.textColor = [UIColor whiteColor];
    titleLabel.text = name;
    detailLabel.text = detail;
    
    [view addSubview:titleLabel];
    [view addSubview:detailLabel];
    view.frame = CGRectMake(0, 0, titleSize.width > detailSize.width ? titleSize.width : detailSize.width, titleSize.height + detailSize.height + 3);
    return view;
}
@end
