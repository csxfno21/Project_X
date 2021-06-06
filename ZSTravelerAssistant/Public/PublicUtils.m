//
//  PublicUtils.m
//  Tourism
//
//  Created by csxfno21 on 13-4-8.
//  Copyright (c) 2013年 szmap. All rights reserved.
//

#import "PublicUtils.h"
#import "OpenUDID.h"

#define dSemiMajorAxis 6378245.00  //参考椭球体的长半轴
#define dFlattening 0.006693421622966  //定义椭球体 参考椭球体的扁率

@implementation PublicUtils

+ (CGSize)getTextSize:(NSString *)aText withFont:(UIFont *)aFont andConstrainedToSize:(CGSize)aSize
{
	return [aText sizeWithFont:aFont constrainedToSize:aSize lineBreakMode:UILineBreakModeWordWrap];
}

+ (BOOL)isNumber:(NSString *)string
{
    NSString *pattern = @"[0-9]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF matches %@",pattern];
    return [pred evaluateWithObject:ReplaceNULL2Empty(string)];
}

+ (BOOL)cleanCache
{
    NSError *error = nil;
    return [[NSFileManager defaultManager] removeItemAtPath:[K_DOCUMENT_FOLDER stringByAppendingPathComponent:IMAGE_PATH] error:&error];
}
+ (void)disabeledScreen:(BOOL)disabled
{
    [UIApplication sharedApplication].idleTimerDisabled = disabled;
}
+ (void)setBrightness:(float)brightess
{
    [[UIScreen mainScreen]setBrightness:brightess];
}
+ (NetworkStatus) getNetState
{
   
    Reachability* reach = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus status;
    status = [reach currentReachabilityStatus];
    
    switch (status)
    {
        case NotReachable:
            break;
        case ReachableViaWiFi:
            break;
        case ReachableViaWWAN:
            break;
        default:
            break;
    }
    return status;
}

+ (NSString*)currentDetatilTime
{
    NSDate * senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * locationString=[dateformatter stringFromDate:senddate];
    SAFERELEASE(dateformatter)
    return locationString;
}
+ (NSString*)currentTime
{
    NSDate * startDate = [[NSDate alloc] init];
    NSCalendar * chineseCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit |
    NSSecondCalendarUnit | NSDayCalendarUnit  |
    NSMonthCalendarUnit | NSYearCalendarUnit;
    
    NSDateComponents * cps = [chineseCalendar components:unitFlags fromDate:startDate];
    
    NSUInteger hour = [cps hour];
    NSUInteger minute = [cps minute];
//    NSUInteger second = [cps second];
//    NSUInteger day = [cps day];
//    NSUInteger month = [cps month];
//    NSUInteger year = [cps year];
    [chineseCalendar release];
    [startDate release];
    
    return [NSString stringWithFormat:@"%d:%d",hour,minute];
}
+ (NSString*)currentDate
{    
    NSDate * senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString * locationString=[dateformatter stringFromDate:senddate];
    SAFERELEASE(dateformatter)
return locationString;
}


+ (NSString*)version
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    return version;
}
+(NSString*)systemVersion
{
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    return systemVersion;
}
+(NSString*)currentDevice
{
    NSString *device = @"iphone4s";
    if (iPhone5)
    {
        device = @"iphone5";
    }
    return device;
}
+ (void)actionForTel:(NSString*)tel
{
    if(tel && tel.length > 0)
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",tel]]];
}

//点到点直线距离
+ (double) GetDistanceS:(double)lng1 withlat1:(double)lat1 withlng2:(double)lng2 withlat2:(double)lat2
{
    double EARTH_RADIUS = 6378137;
    
    double radLat1 = [self rad:lat1];
    double radLat2 = [self rad:lat2];
    double a = radLat1 - radLat2;
    double b = [self rad:lng1] - [self rad:lng2];
    double s = 2 * asin(sqrt(pow(sin(a / 2), 2)
                             + cos(radLat1) * cos(radLat2)
                             * pow(sin(b / 2), 2)));
    
    s = s * EARTH_RADIUS;
    s = round(s * 1000000) / 1000000;
    return s;
}

+ (double)GetDistances:(CGPoint)p1 withPoint:(CGPoint)p2
{
    double dis = 0.0;
    dis = sqrt((p1.x - p2.x)*(p1.x - p2.x) + (p1.y - p2.y)*(p1.y - p2.y));
    return dis;
}

+ (double)rad:(double)d
{
    return d * M_PI / 180.0;
}

+(CGPoint)GetCartesianCoordinate:(CLLocationCoordinate2D)location
{
    CGPoint point = CGPointMake(location.longitude * (M_PI * 6378137)/180, log(tan((90 + location.latitude) * M_PI / 360)) / (M_PI / 180) * (M_PI * 6378137)/180);
    return point;
}

//以给定的大地坐标点为圆心，给定的弧度和半径，求圆上的任一点的笛卡尔坐标，并将该点转换为大地坐标
+(CTDGEODETIC)GetCartesianCoordinate:(CTDGEODETIC) geoCoordinate withRadius:(double)radius withAngle:(double)angle
{
    CRDCARTESIAN centerPoint;
    CRDCARTESIAN point;
    
    double x = geoCoordinate.longitude *(M_PI * 6378137)/180;
    double y = log(tan((90 + geoCoordinate.latitude) * M_PI / 360)) / (M_PI / 180);
    y = y *(M_PI * 6378137)/180;
    
    centerPoint = CRDCARTESIANMake(x, y, geoCoordinate.altitude);
    
    point = CRDCARTESIANMake(radius * cos(M_PI/180 * angle) + centerPoint.x, radius * sin(M_PI/180 * angle) + centerPoint.y, centerPoint.z);
    /**
    double lon = point.x /20037508.34*180;
    double lat = point.y/20037508.34*180;
    lat = 180 / M_PI * (2 * atan(exp(lat * M_PI / 180)) - M_PI / 2);
     */
    double lon = point.x / (M_PI * 6378137) * 180;
    double lat = point.y / (M_PI * 6378137) * 180;
    lat = 180 / M_PI * (2 * atan(exp(lat * M_PI / 180.0)) - M_PI / 2.0);
    return CTDGEODETICMake(lon, lat, centerPoint.z);
}

+ (UIImage*)extrudeImage:(UIImage*)image withSize:(CGSize)size
{
    int w = size.width;
	int h = size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
    
    
    CGImageRef imgCombined = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
	UIImage *retImage = [UIImage imageWithCGImage:imgCombined];
	CGImageRelease(imgCombined);

    return retImage;
}


+ (NSArray*) ExtractPointsFromCompressedGeometry:(NSString*) compresedGeometry
{
    NSMutableArray *result = [[[NSMutableArray alloc]init] autorelease];
    int nIndex = 0;
    double dMultBy = (double)[self ExtractInt:compresedGeometry withStartPos:&nIndex]; // exception
    int nLastDiffX = 0;
    int nLastDiffY = 0;
    int nLength = compresedGeometry.length; // reduce call stack
    while (nIndex != nLength)
    {
        // extract number
        int nDiffX = [self ExtractInt:compresedGeometry withStartPos:&nIndex]; // exception
        int nDiffY = [self ExtractInt:compresedGeometry withStartPos:&nIndex]; // exception
        // decompress
        int nX = nDiffX + nLastDiffX;
        int nY = nDiffY + nLastDiffY;
        double dX = (double)nX / dMultBy;
        double dY = (double)nY / dMultBy;
        // add result item
        PoiPoint *pt = [[PoiPoint alloc]init];
        pt.longitude = dX;
        pt.latitude = dY;
        
        [result addObject:pt];
        [pt release];
        nLastDiffX = nX;
        nLastDiffY = nY;
    }
    return result;
}

+ (int) ExtractInt:(NSString*) src withStartPos:(int*)nStartPos // exception
{
    bool bStop = false;
    NSString *result = @"";
    int nCurrentPos = *nStartPos;
    while (!bStop)
    {
        char cCurrent = [src characterAtIndex:nCurrentPos];
        if (cCurrent == '+' || cCurrent == '-')
        {
            if (nCurrentPos != *nStartPos)
            {
                bStop = true;
                continue;
            }
        }
//        [@"" stringByAppendingString:[NSString stringWithFormat:@"%c",cCurrent]];
        result = [result stringByAppendingString:[NSString stringWithFormat:@"%c",cCurrent]];
        nCurrentPos++;
        if (nCurrentPos == src.length) // check overflow
            bStop = true;
    }
    int nResult = -1;
    if (result.length != 0)
    {
        nResult = [self FromStringRadix32:(result)];
        *nStartPos = nCurrentPos;
    }
    return nResult;
}


+ (int) FromStringRadix32:(NSString*)s
{
    int result = 0;
    for (int i = 1; i < s.length; i++)
    {
        char cur = [s characterAtIndex:i];
        if((cur >= '0' && cur <= '9') || (cur >= 'a' && cur <= 'v'))
        {
            if (cur >= '0' && cur <= '9')
                result = (result << 5) + (int)cur - (int)('0');
            else if (cur >= 'a' && cur <= 'v')
                result = (result << 5) + (int)(cur) - (int)('a') + 10;
        }
    }
    if ([s characterAtIndex:0] == '-')
        result = -result;
    else if ([s characterAtIndex:0] != '+') // exception
        result = -1;
    return result;
}

/**
 *  定位点保存
 *
 */
+(void)saveTestLocation:(double)lon withLa:(double)lat
{
    NSData *writeData = [[NSString stringWithFormat:@"%@ %f,%f\n",[PublicUtils currentTime],lon,lat] dataUsingEncoding: NSUTF8StringEncoding];
    NSString *saveFilePath = [K_DOCUMENT_FOLDER stringByAppendingPathComponent:
                              [NSString stringWithFormat:@"%@.txt",[PublicUtils currentDate]]];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:saveFilePath])
    {
        NSLog(@"创建定位点存储文件");
        [fm createFileAtPath:saveFilePath contents:nil attributes:nil];
    }
    NSFileHandle *outFile = [NSFileHandle fileHandleForWritingAtPath:saveFilePath];
    if(outFile == nil)
    {
        NSLog(@"打开定位点文件错误");
        return;
    }
    [outFile seekToEndOfFile];
    [outFile writeData:writeData];
    [outFile closeFile];
}

+(double)GetMin:(double)dis1 withDis:(double)dis2
{
    if (dis1 < dis2)
    {
        return dis1;
    }
    else
    {
        return dis2;
    }
}

+(NSString*)StringArry:(NSArray*)arry atIndex:(int)index
{
    NSString* strReturn = @"";
    if (index < [arry count])
    {
        strReturn = [arry objectAtIndex:index];
    }
    return strReturn;
}

@end
