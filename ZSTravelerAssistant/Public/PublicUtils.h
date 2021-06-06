//
//  PublicUtils.h
//  Tourism
//
//  Created by logic on 13-4-8.
//  Copyright (c) 2013年 logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

struct CTDGEODETIC
{
    double longitude;
    double latitude;
    double altitude;
};
typedef struct CTDGEODETIC CTDGEODETIC;

static CTDGEODETIC
CTDGEODETICMake(double longitude, double latitude, double altitude)
{
    CTDGEODETIC p; p.longitude = longitude; p.latitude = latitude; p.altitude = altitude ;return p;
}

struct CRDCARTESIAN
{
    double x;
    double y;
    double z;
};
typedef struct CRDCARTESIAN CRDCARTESIAN;

static CRDCARTESIAN
CRDCARTESIANMake(double x,double y,double z)
{
    CRDCARTESIAN p;p.x = x;p.y = y;p.z = z;return p;
}

struct VECTOR
{
    double x;
    double y;
};
typedef struct VECTOR VECTOR;

static VECTOR
VECTORMake(double x,double y)
{
    VECTOR v;
    v.x = x;
    v.y = y;
    return v;
}

@interface PublicUtils : NSObject
+ (CGSize)getTextSize:(NSString *)aText withFont:(UIFont *)aFont andConstrainedToSize:(CGSize)aSize;
+ (BOOL)isNumber:(NSString*)string;
+ (BOOL)cleanCache;
+ (NSString*)currentDetatilTime;
+ (NSString*)currentTime;
+ (NSString*)currentDate;
+ (NSString*)version;
+ (NSString*)systemVersion;
+ (NSString*)currentDevice;
+ (void)disabeledScreen:(BOOL)disabled;
+ (void)setBrightness:(float)brightess;
+ (NetworkStatus) getNetState;
+ (void)actionForTel:(NSString*)tel;
+ (double) GetDistanceS:(double)lng1 withlat1:(double)lat1 withlng2:(double)lng2 withlat2:(double)lat2;
+ (CTDGEODETIC) GetCartesianCoordinate:(CTDGEODETIC) geoCoordinate withRadius:(double)radius withAngle:(double)angle;
+ (UIImage*)extrudeImage:(UIImage*)image withSize:(CGSize)size;
+ (NSArray*) ExtractPointsFromCompressedGeometry:(NSString*) compresedGeometry;
+ (CGPoint) GetCartesianCoordinate:(CLLocationCoordinate2D)location;
+ (double) GetDistances:(CGPoint)p1 withPoint:(CGPoint)p2;
+(void)saveTestLocation:(double)lon withLa:(double)lat;
+(double)GetMin:(double)dis1 withDis:(double)dis2;
+(NSString*)StringArry:(NSArray*)arry atIndex:(int)index;

@end
