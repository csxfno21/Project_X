//
//  PublicDef.h
//  Tourism
//
//  Created by logic on 13-4-1.
//  Copyright (c) 2013年 logic. All rights reserved.
//
#pragma mark
#pragma mark 资源

#define IMAGE_PATH                  @"IMAGE_CACHE"
#define SPOT_ZONE_PATH              @"SPOT_ZONE_PATH"
#define DOCUMENT_TMP				[NSHomeDirectory() stringByAppendingPathComponent:TMP]
#define TMPDOWNLOADPIC_FOLDER       [DOCUMENT_TMP stringByAppendingPathComponent:DOWNLOADPIC]

#pragma mark
#pragma mark macro

#define K_DOCUMENT_FOLDER             [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define SAFERELEASE(obj)     if(obj){[obj release]; obj = nil;}
#define ReplaceNULL2Empty(str)   ((nil == (str)) ? @"" : (str))
#define INTTOOBJ(intNum)         [NSNumber numberWithInt:intNum]
#define FLOATTOOBJ(floatNum)     [NSNumber numberWithFloat:floatNum]
#define LONGTOOBJ(longNum)       [NSNumber numberWithLong:longNum]
#define DOUBLETOOBJ(doubleNum)   [NSNumber numberWithDouble:doubleNum]
#define DOUBLETOSTR(doubleNum)   [NSString stringWithFormat:@"%.2lf",doubleNum];
#define ISNIL(obj)               (nil == (obj))
#define CLASSSTR(className)      NSStringFromClass([className class])
#define ISNULLCLASS(variable)    ((!ISNIL(variable))&&([variable  isKindOfClass:[NSNull class]]))
#define ISDICTIONARYCLASS(variable) ((!ISNIL(variable))&&([variable  isKindOfClass:[NSDictionary class]]))
#define ISARRYCLASS(variable) ((!ISNIL(variable))&&([variable  isKindOfClass:[NSArray class]]))
#define ISEXISTSTR(str) ((nil != (str)) && ((str).length > 0))

#define RootViewControllerPush(controller)            [[(AppDelegate *)[[UIApplication sharedApplication] delegate] rootViewController] pushViewController:controller animated:YES] ;
#define RootViewControllerPop           [[(AppDelegate *)[[UIApplication sharedApplication] delegate] rootViewController] popViewControllerAnimated:YES] ;

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define WINDOW_HEIGHT    [UIApplication sharedApplication].delegate.window.frame.size.height

#define POINT2NUMBER(point)     LONGTOOBJ((long)point)
#define NUMBER2POINT(number)    (id)[number longValue]
#define CALLOUTSHOWTOLERANCE(scale) (int)(scale/100 * .8)     
#define MAXVIEWDISTANCE         1000 * 20    //最大显示距离，超出则显示 未知距离
#define MAXAROUNDDISTANCE       3000         //最大附近距离