//
//  NetFileLoadManager.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-8.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "NetFileLoadManager.h"
static NetFileLoadManager *manager;
@implementation NetFileLoadManager
- (id)init
{
    if(self = [super init])
    {
        downImgRequestCache = [[NSMutableDictionary alloc] init];
        [self createPath:IMAGE_PATH];

    }
    return self;
}

+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (manager == nil)
        {
            manager = [super allocWithZone:zone];
            return manager;
        }
    }
    return nil;
}

+(NetFileLoadManager*)sharedInstanced
{
    @synchronized(self)
    {
        if(manager == nil)
        {
            manager = [[NetFileLoadManager alloc] init];
        }
    }
    return manager;
}


/**
 *请求图片文件
 */
- (UIImage*)loadImageByURL:(NSString*)url withDelegate:(id)delegate withID:(int)imgID withImgName:(NSString*)name withCmdcode:(REQUEST_CMD_CODE)cmdcode 
{
    if(ISNIL(url) || ISNIL(name) || imgID < 0)
    {
        NSLog(@"loadImageByURL Error , arg can not be nil!");
        return nil;
    }
    //1.读取本地文件，看文件是否存在
    NSString *imgPath = [NSString stringWithFormat:@"%@/%d_%@",[K_DOCUMENT_FOLDER stringByAppendingPathComponent:IMAGE_PATH],imgID,name];
    UIImage *image = [UIImage imageWithContentsOfFile:imgPath];
//    [self isJPEGValid:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%d_%@",[K_DOCUMENT_FOLDER stringByAppendingPathComponent:IMAGE_PATH],imgID,name]]] == 0 &&
    //如果jpg
    BOOL imgisBroken = NO;
    if(image && [name hasSuffix:@".jpg"])
    {
        NSData *data = [NSData dataWithContentsOfFile:imgPath];
        if ([self isJPEGValid:data] != 0)
        {
            [[NSFileManager defaultManager] removeItemAtPath:imgPath error:nil];
            imgisBroken = YES;
        }
    }
    else if(image && [name hasSuffix:@".png"])
    {
        NSData *data = [NSData dataWithContentsOfFile:imgPath];
        if ([self isPNGValid:data] != 0)
        {
//            [[NSFileManager defaultManager] removeItemAtPath:imgPath error:nil];
//            imgisBroken = YES;
        }
    }
    if (image && !imgisBroken)
    {
        return image;
    }
    else
    {
        if([downImgRequestCache objectForKey:[NSString stringWithFormat:@"%d_%d",cmdcode,imgID]])return nil;
        NSString *imgType = @".jpg";
        if([name hasSuffix:@".png"])imgType = @".png";
        else if([name hasSuffix:@".jpg"])imgType = @".jpg";
        DownImgCache *cache = [[DownImgCache alloc] init];
        cache.imgID = imgID;
        cache.imgName = name;
        cache.imgType = imgType;
        cache.imgUrl = url;
        cache.UIDelegate = delegate;
        [downImgRequestCache setObject:cache forKey:[NSString stringWithFormat:@"%d_%d",cmdcode,imgID]];
        SAFERELEASE(cache)
        
        HttpRequest *request = [[HttpRequest alloc] init];
        request.UIDelegate = delegate;
        request.cmdCode = cmdcode;
        request.requestType = DOWNLOAD ;
        request.delegate = self;
        request.url = url;
        request.index = imgID;
        
        [[ASIUtil sharedInstance] GETRequest:request];
        [request release];
    }
    return nil;
}





#pragma mark - reciveHttpRespondInfo
- (void)reciveHttpRespondInfo:(HttpResponse *)response
{
    DownImgCache *cache = [downImgRequestCache objectForKey:[NSString stringWithFormat:@"%d_%d",response.cmdCode,response.index]];
    switch (response.cmdCode)
    {
        case CC_DOWN_IMAGE_THEM_ROUTE_SMALL:
        case CC_DOWN_IMAGE_COMMON_ROUTE_SMALL:
        case CC_DOWN_IMAGE_SPOT_SMALL:
        case CC_DOWN_IMAGE_SPOT:
        case CC_DOWN_IMAGE_REC_INFO:
        case CC_DOWN_IMAGE_REC_INFO_BIG:
        case CC_DOWN_IMAGE_SEASONINFO_BIG:
        case CC_DOWN_IMAGE_SEASONINFO:
        case CC_DOWN_IMAGE_RECOMMEND://下载主封面 图片
        {
            NSData *data = response.data;
            DwonImgResponse *res = [[[DwonImgResponse alloc] init] autorelease];
            res.cc_cmd_code = response.cmdCode;
            res.UIDelegate = response.UIDelegate;
            res.error_code = E_HTTPERR_FAILED;
            res.imgID = response.index;
            UIImage *img =  [UIImage imageWithData:data];
            if(data && data.length > 0 && img)
            {
                //判断文件夹是否存在
                [self createPath:IMAGE_PATH];
                
                if(cache)
                {
                    
                    NSString *path =  [NSString stringWithFormat:@"%d_%@",cache.imgID,cache.imgName];
                    [data writeToFile:[NSString stringWithFormat:@"%@/%@",[K_DOCUMENT_FOLDER stringByAppendingPathComponent:IMAGE_PATH],path] atomically:YES];
                    res.error_code = E_HTTPSUCCEES;
                    [downImgRequestCache removeObjectForKey:[NSString stringWithFormat:@"%d_%d",response.cmdCode,response.index]];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:DOWNLOAD_IMAGE_SCUUESS object:INTTOOBJ(response.index)];
                    
                }
                else
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:DOWNLOAD_IMAGE_FAILED object:INTTOOBJ(response.index)];
                }
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:DOWNLOAD_IMAGE_FAILED object:INTTOOBJ(response.index)];
            }
            if(response.UIDelegate && [response.UIDelegate respondsToSelector:@selector(callBackToUI:)])
            {
                [response.UIDelegate callBackToUI:res];
            }

            break;
        }
        default:
            break;
    }
}


- (void)createPath:(NSString*)filePath
{
    BOOL isDir = YES;
    NSString *path = [K_DOCUMENT_FOLDER stringByAppendingPathComponent:filePath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory: &isDir])
    {
        if ([[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil]==NO)
        {
        }
    }
}

- (void)cancelAllRequest
{
    [downImgRequestCache removeAllObjects];
    [super cancelAllRequest];
}
- (void)cancelRequestWithCode:(REQUEST_CMD_CODE)cc_code
{
    //暂不支持
    assert(@"not support");
    [super cancelRequestWithCode:cc_code];
}
- (void)cancelRequest:(id)delegate
{
    [super cancelRequest:delegate];
    
    for (NSString *key in downImgRequestCache.allKeys)
    {
        DownImgCache *cache = [downImgRequestCache objectForKey:key];
        if(cache.UIDelegate == delegate)
        {
            [downImgRequestCache removeObjectForKey:key];
        }
    }
  
}
-(int)isJPEGValid:(NSData *)jpeg
{
    if ([jpeg length] < 4)
        return 1;
    const unsigned char * bytes = (const unsigned char *)[jpeg bytes];
    if (bytes[0] != 0xFF || bytes[1] != 0xD8) return 2;
    if (bytes[[jpeg length] - 2] != 0xFF ||
        bytes[[jpeg length] - 1] != 0xD9) return 3;
    return 0;
}
-(int)isPNGValid:(NSData *)jpeg
{
    if ([jpeg length] < 20)
    {
        return 1;
    }
    const unsigned char *bytes = (const unsigned char *)[jpeg bytes];
    if (bytes[0] != 0x89 || bytes[1] != 0x50 || bytes[2] !=0x4E || bytes[3] != 0x47 || bytes[4] != 0x0D || bytes[5] !=0x0A || bytes[6] != 0x1A || bytes[7] != 0x0A)
    {
        return 2;
    }
    if (bytes[[jpeg length] - 1] != 0x82 || bytes[[jpeg length] - 2] != 0x60 || bytes[[jpeg length] - 3] != 0x42 || bytes[[jpeg length] - 4] != 0xAE || bytes[[jpeg length] - 5] != 0x44 || bytes[[jpeg length] - 6] != 0x4E || bytes[[jpeg length] - 7] != 0x45 || bytes[[jpeg length] - 8] != 0x49 ||bytes[[jpeg length] - 9] != 0x00 || bytes[[jpeg length] - 10] != 0x000 || bytes[[jpeg length] - 11] != 0x00 || bytes[[jpeg length] - 12] != 0x00)
    {
        return 3;
    }
    return 0;
}
- (id)retain
{
    return self;
}

- (id)autorelease
{
    return self;
}
+(void)freeInstance
{
    manager = nil;
    
}

- (void)dealloc
{
   SAFERELEASE(downImgRequestCache)
    [super dealloc];
}
@end



@implementation DownImgCache
@synthesize imgID;
@synthesize imgUrl;
@synthesize imgName;
@synthesize imgType;
@synthesize UIDelegate;

- (void)dealloc
{
    SAFERELEASE(imgUrl)
    SAFERELEASE(imgName)
    SAFERELEASE(imgType)
    [super dealloc];
}
@end
