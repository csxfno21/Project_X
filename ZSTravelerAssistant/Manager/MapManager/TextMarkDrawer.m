//
//  TextMarkDrawer.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-9-3.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "TextMarkDrawer.h"
@implementation TextMarkDrawer
@synthesize delegate;
- (id)initWithMapView:(AGSMapView*)mapView
{
    if (self = [super init])
    {
        conentView = mapView;
        _allTextMarkCache = [[NSMutableArray alloc] init];
        layer = [AGSGraphicsLayer graphicsLayer];
        [mapView addMapLayer:layer withName:@"TextMarkLayer"];
//        mapView.calloutDelegate = self;
        lastLevel = -1;
        callOutDrawer = [[CallOutDrawer alloc] init];
        
        lastAnagle = -1;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSpeakImg:) name:@"CHANGE_SPEAK_SYMBOL_ICON" object:nil];
    }
    return self;
}

//request textMark
- (void)requestTextMark
{
    if (!textMarkTask)
    {
        textMarkTask = [AGSQueryTask queryTaskWithURL:[NSURL URLWithString:SERVER_ARRRESS_MAP_MARK_TEXT_TASK]];
        [textMarkTask retain];
        textMarkTask.delegate = self;
    }
    AGSQuery *query = [AGSQuery query];
    query.where = @"1 = 1";
    query.outFields = [NSArray arrayWithObject:@"*"];
    query.returnGeometry = YES;
    [textMarkTask executeWithQuery:query];
}
#pragma mark - TextMark QueryTask CallBack
//success
- (void)queryTask:(AGSQueryTask *)queryTask operation:(NSOperation *)op didExecuteWithFeatureSetResult:(AGSFeatureSet *)featureSet
{
    if (_allTextMarkCache.count == 0)
    {
        [_allTextMarkCache addObjectsFromArray:featureSet.features];

        [self drawTextMarkAndIcon:[MapManager sharedInstanced].currentScenic];
        
        if (delegate && [delegate respondsToSelector:@selector(textMarkDrawerCompleted)])
        {
            [delegate textMarkDrawerCompleted];
        }
    }
}

//failed
- (void)queryTask:(AGSQueryTask *)queryTask operation:(NSOperation *)op didFailWithError:(NSError *)error
{
    
}


#pragma mark - AGSMapViewCalloutDelegate
- (BOOL)mapView:(AGSMapView *)mapView shouldShowCalloutForGraphic:(AGSGraphic *)graphic
{
    return YES;
}

- (void)drawTextMark:(int)scal
{
    if (_allTextMarkCache.count == 0)
    {
        [self requestTextMark];
        return;
    }
    [self performSelectorInBackground:@selector(drawTextMarkInBackground:) withObject:INTTOOBJ(scal)];
}
- (void)drawTextMarkInBackground:(id)sc
{
    int scal = [sc intValue] == 0 ? MAP_DIDLOAD_SCALE : [sc intValue];
   
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

- (void)drawTextMarkAndIcon:(SCENIC_TYPE)type
{
    [layer removeAllGraphics];
    if (_allTextMarkCache.count > 0)
    {
        for (AGSGraphic *graphic in _allTextMarkCache)
        {
            AGSCompositeSymbol *comSymbol = [AGSCompositeSymbol compositeSymbol];
            
           
            AGSTextSymbol *textSymble = [[AGSTextSymbol alloc] initWithText:ReplaceNULL2Empty([graphic.allAttributes objectForKey:@"name"]) color:[UIColor blackColor]];
//            textSymble.text = [graphic.allAttributes objectForKey:@"name"];
            textSymble.fontFamily = @"Heiti SC";
            textSymble.fontSize = 13;
            textSymble.bold = YES;
//            textSymble.color = [UIColor blackColor];
            textSymble.borderLineColor = [UIColor whiteColor];
            textSymble.borderLineWidth = 2.5;
            
            int parentID = [ReplaceNULL2Empty([graphic.allAttributes objectForKey:@"ParentID"]) intValue];
            if (parentID == -1)
            {
                [comSymbol addSymbol:textSymble];
                
            }
            else
            {
                UIImage *pic = NULL;
                int spotID = [ReplaceNULL2Empty([graphic.allAttributes objectForKey:@"UniqueCode"]) intValue];
                if([[MapManager sharedInstanced].hasSpeaked containsObject:INTTOOBJ(spotID)])
                {
                    pic = [UIImage imageNamed:@"startpoint.png"];
                }
                else
                {
                    pic = [UIImage imageNamed:@"map-callout-icon.png"];
                }
                CGSize textSize = [PublicUtils getTextSize:textSymble.text withFont:[UIFont fontWithName:@"Heiti SC" size:13] andConstrainedToSize:CGSizeMake(200, pic.size.height)];
                AGSPictureMarkerSymbol* pmarkSymbol = [[AGSPictureMarkerSymbol alloc] initWithImage:[PublicUtils extrudeImage:pic withSize:CGSizeMake(textSize.width + pic.size.width*2 , pic.size.height)]];
                NSMutableArray *symbols = [NSMutableArray array];

                [symbols addObject:textSymble];
                [symbols addObject:pmarkSymbol];
                SAFERELEASE(textSymble)
                SAFERELEASE(pmarkSymbol)
                [comSymbol addSymbols:symbols];
               
//                graphic.infoTemplateDelegate = [callOutDrawer infoTemplate:textSymble.text];
            }

            graphic.symbol = comSymbol;
            
            [layer addGraphic:graphic];
        }
        [self drawTextMark:conentView.mapScale];
    }

}
- (void)visibleGraphicInBackGround:(id)level,...
{
    @synchronized(_allTextMarkCache)
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
        
        for (AGSGraphic *graphic in _allTextMarkCache)
        {
            graphic.visible = NO;
            int scal = [[graphic.allAttributes objectForKey:@"Scale"] intValue];
            for (id level in levels)
            {
                if (scal ==  [level intValue])
                {
                    graphic.visible = YES;
                }
            }
        }
    }
}
- (void)rotateGraphicAngel:(double)angle
{
    @synchronized(_allTextMarkCache)
    {
        if (lastAnagle != -1 && abs(lastAnagle - angle) < 40)
        {
            return;
        }
        lastAnagle = angle;
        for (AGSGraphic *graphic in _allTextMarkCache)
        {
            AGSCompositeSymbol *symbol = (AGSCompositeSymbol*)graphic.symbol;
            if (!symbol)
            {
                continue;
            }
            NSArray *symbols = symbol.symbols;
            if (symbols.count > 0)
            {
                id textSymbol = [symbols objectAtIndex:0];
                if ([textSymbol isKindOfClass:[AGSTextSymbol class]])
                {
                    AGSTextSymbol *sym = textSymbol;
//                        NSLog(@"AGSTextSymbol symbol retainCount %d",sym.retainCount);
                    if (sym)
                    {
                        sym.angle = angle;
                    }
                
                }
            }
            if (symbols.count > 1)
            {
                id picSymbol = [symbols objectAtIndex:1];
                if ([picSymbol isKindOfClass:[AGSPictureMarkerSymbol class]])
                {
                    AGSPictureMarkerSymbol *pic = picSymbol;
                    pic.angle = angle;
////                    NSLog(@"AGSPictureMarkerSymbol symbol retainCount %d",pic.retainCount);
                }
            }
        }
    }
}
// 修改 播报过的 景点喇叭
- (void)changeSpeakImg:(NSNotification*)notification
{
    int notiData = [notification.object intValue];
    for (AGSGraphic *graphic in layer.graphics)
    {
        int spotID = [ReplaceNULL2Empty([graphic.allAttributes objectForKey:@"UniqueCode"]) intValue];
        if(notiData == spotID)//同一个 景点 
        {
            AGSCompositeSymbol *symbol = (AGSCompositeSymbol*)graphic.symbol;
            if (!symbol)
            {
                continue;
            }
            NSArray *symbols = symbol.symbols;
            if (symbols.count > 1)
            {
                id textSymbol = [symbols objectAtIndex:0];
                double angle = 0;
                NSString *lb = @"";
                if ([textSymbol isKindOfClass:[AGSTextSymbol class]])
                {
                    AGSTextSymbol *sym = textSymbol;
                    if (sym)
                    {
                        lb = sym.text;
                        angle = sym.angle;
                    }
                    
                }
                id picSymbol = [symbols objectAtIndex:1];
                if ([picSymbol isKindOfClass:[AGSPictureMarkerSymbol class]])
                {
                    AGSPictureMarkerSymbol *pic = picSymbol;
                    UIImage *p = [UIImage imageNamed:@"startpoint.png"];
                    CGSize textSize = [PublicUtils getTextSize:lb withFont:[UIFont fontWithName:@"Heiti SC" size:13] andConstrainedToSize:CGSizeMake(200, p.size.height)];
                    pic.image = [PublicUtils extrudeImage:p withSize:CGSizeMake(textSize.width + p.size.width*2 , p.size.height)];
                    pic.angle = angle;
                }
            }
            return;
        }
    }
}

#pragma mark - scenic change delegate
- (void)didUpdateCurrentSenic:(SCENIC_TYPE)scenic
{
//    [self drawTextMarkAndIcon:scenic];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CHANGE_SPEAK_SYMBOL_ICON" object:nil];
    lastAnagle = -1;
    delegate = nil;
    SAFERELEASE(callOutDrawer)
    SAFERELEASE(textMarkTask)
    SAFERELEASE(_allTextMarkCache)
    [super dealloc];
}
@end
