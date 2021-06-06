//
//  MapRouteNavResponse.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-9-12.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "httpBaseResponse.h"

@interface MapRouteNavResponse : HttpBaseResponse
{
    int routeId;
    NSString *routeName;
    double totalLength;
    double xmin;
    double ymin;
    double xmax;
    double ymax;
    int wkid;
    
    NSMutableArray *features;
    NSMutableArray *points;
}
@property(nonatomic,assign)int routeId;
@property(nonatomic,assign)int wkid;
@property(nonatomic,retain)NSString *routeName;
@property(nonatomic,assign)double totalLength;
@property(nonatomic,assign)double xmin;
@property(nonatomic,assign)double ymin;
@property(nonatomic,assign)double xmax;
@property(nonatomic,assign)double ymax;
@property(nonatomic,retain)NSMutableArray *features;
@property(nonatomic,retain)NSMutableArray *points;
- (void)addFeature:(NSString*)text withRoute:(NSArray*)route withLength:(double)Length withDirection:(MAP_DIRECTION)direction;

@end
@interface Feature : NSObject
{
    double Length;
    NSString *text;
    NSArray *routePoints;
    MAP_DIRECTION direction;
}
@property(nonatomic)double Length;
@property(nonatomic,retain)NSString *text;
@property(nonatomic,retain)NSArray *routePoints;
@property(nonatomic)MAP_DIRECTION direction;
@end
