//
//  NetFileLoadManager.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-8.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequestManager.h"
#import "DwonImgResponse.h"

#define DOWNLOAD_IMAGE_SCUUESS   @"DOWNLOAD_IMAGE_SCUUESS"
#define DOWNLOAD_IMAGE_FAILED    @"DOWNLOAD_IMAGE_FAILED"


@interface NetFileLoadManager : BaseRequestManager
{

    NSMutableDictionary *downImgRequestCache;
}
+(NetFileLoadManager*)sharedInstanced;
+(void)freeInstance;




- (UIImage*)loadImageByURL:(NSString*)url withDelegate:(id)delegate withID:(int)imgID withImgName:(NSString*)name withCmdcode:(REQUEST_CMD_CODE)cmdcode;
@end


@interface DownImgCache : NSObject
{
    int      imgID;
    NSString *imgUrl;
    NSString *imgName;
    NSString *imgType;
    id    UIDelegate;
}
@property(assign,nonatomic)id    UIDelegate;
@property(assign,nonatomic)int      imgID;
@property(retain,nonatomic)NSString *imgUrl;
@property(retain,nonatomic)NSString *imgName;
@property(retain,nonatomic)NSString *imgType;
@end
