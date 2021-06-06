//
//  PoiPoint.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-9-13.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <Foundation/Foundation.h>

//poi 点 结构
@interface PoiPoint : NSObject
{
    NSString *name;
    double longitude;
    double latitude;
    int poiID;
}
@property(nonatomic,retain)NSString *name;
@property(nonatomic,assign)double longitude;
@property(nonatomic,assign)double latitude;
@property(nonatomic,assign)int poiID;
+(id)pointWithName:(NSString*)name withLongitude:(double)longitude withLatitude:(double)latitude;
+(id)pointWithName:(NSString*)name withLongitude:(double)longitude withLatitude:(double)latitude withPoiID:(int)poiID;
@end

@interface RouteSection : NSObject
{
    PoiPoint *startPoi;
    PoiPoint *endPoi;
    int navType;
}
@property(nonatomic,retain)PoiPoint *startPoi;
@property(nonatomic,retain)PoiPoint *endPoi;
@property(nonatomic,assign)int navType;
+(id)sectionWithStartPoi:(PoiPoint*)start withEndPoi:(PoiPoint*)end withNavType:(int)navType;
@end
