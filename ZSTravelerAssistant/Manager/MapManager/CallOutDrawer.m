//
//  CallOutDrawer.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-9-6.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "CallOutDrawer.h"

#define CALL_OUT_ICON_PIX       20
#define CALL_OUT_ICON_PADDINHG  5

@interface PoiInfoTemplate : NSObject<AGSInfoTemplateDelegate>
{
    NSString *infoTitle;
}
- (id)initWithTitle:(NSString*)title;
@end




@interface CallOutDrawer (Private)
@end

@implementation CallOutDrawer

- (id)initWithMapView:(AGSMapView*)mapView
{
    if(self = [super init])
    {
        layer = [AGSGraphicsLayer graphicsLayer];
        [mapView addMapLayer:layer withName:@"CallOutGraphicLayer"];
        allCallOutGaphicCache = [[NSMutableArray alloc] init];
//        mapView.calloutDelegate = self;
        lastLevel = -1;
        contentView = mapView;
    }
    return self;
}
- (PoiInfoTemplate*)infoTemplate:(NSString*)title
{
    if (ISNIL(title))
    {
        return nil;
    }
    PoiInfoTemplate *infoTemplate = [[PoiInfoTemplate alloc] initWithTitle:title];
    
    return infoTemplate;
}
- (UIView*)infoView:(NSString*)title
{
    MapCallOutView *view = [[[MapCallOutView alloc] initWithFrame:CGRectMake(0, 0, 200, CALL_OUT_ICON_PIX)] autorelease];
    
    [view setTitle:title];
    return view;
}
- (UIView*)poiView:(NSString*)title
{
    MapCallOutView *view = [[[MapCallOutView alloc] initWithFrame:CGRectMake(0, 0, 200, CALL_OUT_ICON_PIX)] autorelease];
    
    [view setPoiTitle:title];
    return view;
}
//request callout graphic
- (void)requestCallOutGraphic
{
    if (!callOutGraphicTask)
    {
        callOutGraphicTask = [AGSQueryTask queryTaskWithURL:[NSURL URLWithString:SERVER_ARRRESS_MAP_CALLOUT_TASK]];
        [callOutGraphicTask retain];
        callOutGraphicTask.delegate = self;
    }
    AGSQuery *query = [AGSQuery query];
    query.where = @"1 = 1";
    query.outFields = [NSArray arrayWithObject:@"*"];
    query.returnGeometry = YES;
    [callOutGraphicTask executeWithQuery:query];
}

#pragma mark - TextMark QueryTask CallBack
//success
- (void)queryTask:(AGSQueryTask *)queryTask operation:(NSOperation *)op didExecuteWithFeatureSetResult:(AGSFeatureSet *)featureSet
{
    [allCallOutGaphicCache removeAllObjects];
    [allCallOutGaphicCache addObjectsFromArray:featureSet.features];
    for (AGSGraphic *graphic in allCallOutGaphicCache)
    {
        graphic.infoTemplateDelegate = [self infoTemplate:ReplaceNULL2Empty([graphic.allAttributes objectForKey:@"Name"])];
        AGSSimpleFillSymbol *symbol = [AGSSimpleFillSymbol simpleFillSymbolWithColor:[UIColor colorWithRed:.2 green:.2 blue:.2 alpha:.3] outlineColor:[UIColor clearColor]];
        symbol.style = AGSSimpleFillSymbolStyleSolid;
        graphic.symbol = symbol;
        [layer addGraphic:graphic];
    }
    [self drawCallOutGraphic:contentView.mapScale];
}

//failed
- (void)queryTask:(AGSQueryTask *)queryTask operation:(NSOperation *)op didFailWithError:(NSError *)error
{
    
}

//按等级 隐藏graphic
- (void)drawCallOutGraphic:(int)scal
{
    if (allCallOutGaphicCache.count == 0)
    {
        [self requestCallOutGraphic];
        return;
    }
    [self performSelectorInBackground:@selector(drawCallOutGraphicInBackground:) withObject:INTTOOBJ(scal)];
}

- (void)drawCallOutGraphicInBackground:(id)sc
{
    int scal = [sc intValue];
    int level = 0;
    
    if (scal <= 6000)
    {
        level = 5;
        
    }
    else if(scal > 6000 && scal<= 9000)
    {
        level = 4;
        
    }
    else if(scal > 9000 && scal<= 12000)
    {
        level = 3;
        
    }
    else if(scal > 12000 && scal<= 24000)
    {
        level = 2;
        
    }
    else if(scal > 24000 && scal<= 48000)
    {
        level = 1;
        
    }
    else if(scal == 0)
    {   //初始化比例 按照8000
        level = 4;
    }
    else
    {
        level = 0;
    }
    
    if (lastLevel != level)
    {
        lastLevel = level;
        switch (level)
        {
            case 5:
            {
                [self visibleGraphicInBackGround:INTTOOBJ(5),INTTOOBJ(4),INTTOOBJ(3),INTTOOBJ(2),INTTOOBJ(1),INTTOOBJ(0),nil];
                break;
            }
            case 4:
            {
                [self visibleGraphicInBackGround:INTTOOBJ(4),INTTOOBJ(3),INTTOOBJ(2),INTTOOBJ(1),INTTOOBJ(0),nil];
                break;
            }
            case 3:
            {
                [self visibleGraphicInBackGround:INTTOOBJ(3),INTTOOBJ(2),INTTOOBJ(1),INTTOOBJ(0),nil];
                break;
            }
            case 2:
            {
                [self visibleGraphicInBackGround:INTTOOBJ(2),INTTOOBJ(1),INTTOOBJ(0),nil];
                break;
            }
            case 1:
            {
                [self visibleGraphicInBackGround:INTTOOBJ(1),INTTOOBJ(0),nil];
                break;
            }
            case 0:
            {
                [self visibleGraphicInBackGround:INTTOOBJ(0),nil];
                break;
            }
            default:
                break;
        }
    }
}
- (void)visibleGraphicInBackGround:(id)level,...
{
    NSMutableArray *levels = [[[NSMutableArray alloc] init] autorelease];
    [levels addObject:level];
    
    va_list args;
    va_start(args, level);
    id arg;
    while((arg = va_arg(args,id)))
    {
        [levels addObject:arg];
    }
    va_end(args);
    
    for (AGSGraphic *graphic in allCallOutGaphicCache)
    {
        graphic.visible = NO;
        int scal = [[graphic.allAttributes objectForKey:@"scall"] intValue];
        for (id level in levels)
        {
            if (scal ==  [level intValue])
            {
                graphic.visible = YES;
            }
        }
    }
    
}
#pragma mark - AGSMapViewCalloutDelegate
- (BOOL)mapView:(AGSMapView *)mapView shouldShowCalloutForGraphic:(AGSGraphic *)graphic
{
    return YES;
}
- (void)mapView:(AGSMapView *)mapView didShowCalloutForGraphic:(AGSGraphic *)graphic
{
    ZS_CustomizedSpot_entity *entity = [[DataAccessManager sharedDataModel] getSpotByName:ReplaceNULL2Empty([graphic.allAttributes objectForKey:@"Name"])];
    AGSPoint *pt = [AGSPoint pointWithX:[entity.SpotLng doubleValue] y:[entity.SpotLat doubleValue] spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326 WKT:nil]];
    [mapView.callout moveCalloutTo:pt pixelOffset:CGPointMake(0, 0) animated:YES];
}
- (void)dealloc
{
    SAFERELEASE(callOutGraphicTask)
    SAFERELEASE(allCallOutGaphicCache)
    [super dealloc];
}
@end

#pragma mark - PoiInfoTemplate

@implementation PoiInfoTemplate

- (id)initWithTitle:(NSString*)title
{
    if (self = [super init])
    {
        SAFERELEASE(infoTitle)
        infoTitle = [[NSString alloc] initWithString:title];
    }
    return self;
}
- (UIView *)customViewForGraphic:(AGSGraphic *)graphic screenPoint:(CGPoint)screen mapPoint:(AGSPoint *)mapPoint
{
    MapCallOutView *view = [[[MapCallOutView alloc] initWithFrame:CGRectMake(0, 0, 200, CALL_OUT_ICON_PIX)] autorelease];
    
    [view setTitle:infoTitle];
    return view;
}
- (void)dealloc
{

    SAFERELEASE(infoTitle)
    [super dealloc];
}
@end

#pragma mark - MapCallOutView
@implementation MapCallOutView
@synthesize infoTitlelabel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        spotspeak = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CALL_OUT_ICON_PIX, CALL_OUT_ICON_PIX)];
        [spotspeak setImage:[UIImage imageNamed:@"map-spotspeak.png"] forState:UIControlStateNormal];
        spotspeak.backgroundColor = [UIColor clearColor];
        [spotspeak addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        spotspeak.tag = 1;
        [self addSubview:spotspeak];
        
        UILabel *tmpInfoTitlelabel = [[UILabel alloc] initWithFrame:CGRectMake(CALL_OUT_ICON_PADDINHG + CALL_OUT_ICON_PIX, 0, 100, CALL_OUT_ICON_PIX)];
        
        tmpInfoTitlelabel.textAlignment = UITextAlignmentCenter;
        tmpInfoTitlelabel.textColor = [UIColor whiteColor];
        tmpInfoTitlelabel.backgroundColor = [UIColor clearColor];
        tmpInfoTitlelabel.font = [UIFont boldSystemFontOfSize:12];
        [self addSubview:tmpInfoTitlelabel];
        self.infoTitlelabel = tmpInfoTitlelabel;
        SAFERELEASE(tmpInfoTitlelabel)
        
        spotsolve = [[UIButton alloc] initWithFrame:CGRectMake(150, 0, CALL_OUT_ICON_PIX, CALL_OUT_ICON_PIX)];
        [spotsolve setImage:[UIImage imageNamed:@"map-spotsolve.png"] forState:UIControlStateNormal];
        spotsolve.backgroundColor = [UIColor clearColor];
        [spotsolve addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        spotsolve.tag = 2;
        [self addSubview:spotsolve];
    }
    return self;
}

- (void)setTitle:(NSString *)str
{
    CGSize size = [str sizeWithFont:infoTitlelabel.font constrainedToSize:CGSizeMake(300, CALL_OUT_ICON_PIX) lineBreakMode:NSLineBreakByWordWrapping];
    infoTitlelabel.frame = CGRectMake(CALL_OUT_ICON_PADDINHG + CALL_OUT_ICON_PIX, 0, size.width, CALL_OUT_ICON_PIX);
    infoTitlelabel.text = str;
    spotsolve.frame = CGRectMake(CALL_OUT_ICON_PIX + 2 * CALL_OUT_ICON_PADDINHG + size.width , 0, CALL_OUT_ICON_PIX, CALL_OUT_ICON_PIX);
    
    CGRect frame = self.frame;
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, CALL_OUT_ICON_PIX * 2 + 2 * CALL_OUT_ICON_PADDINHG + infoTitlelabel.frame.size.width, frame.size.height);
}

- (void)setPoiTitle:(NSString *)str
{
    spotspeak.hidden = YES;
    CGSize size = [str sizeWithFont:infoTitlelabel.font constrainedToSize:CGSizeMake(300, CALL_OUT_ICON_PIX) lineBreakMode:NSLineBreakByWordWrapping];
    infoTitlelabel.frame = CGRectMake(CALL_OUT_ICON_PADDINHG , 0, size.width, CALL_OUT_ICON_PIX);
    infoTitlelabel.text = str;
    spotsolve.frame = CGRectMake(2 * CALL_OUT_ICON_PADDINHG + size.width , 0, CALL_OUT_ICON_PIX, CALL_OUT_ICON_PIX);
    
    CGRect frame = self.frame;
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, CALL_OUT_ICON_PIX + 2 * CALL_OUT_ICON_PADDINHG + infoTitlelabel.frame.size.width, frame.size.height);
}
- (void)btnAction:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInt:btn.tag] forKey:@"index"];
    [dic setObject:infoTitlelabel.text forKey:@"title"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CallOutAction" object:dic];
    SAFERELEASE(dic)
}

-(void)dealloc
{
    SAFERELEASE(infoTitlelabel)
    SAFERELEASE(spotsolve)
    SAFERELEASE(spotspeak)
    [super dealloc];
}

@end
