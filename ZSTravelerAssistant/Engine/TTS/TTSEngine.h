//
//  TTSEngine.h
//  MAPDemo
//
//  Created by csxfno21 on 13-5-13.
//  Copyright (c) 2013年 szmap. All rights reserved.
//

#define NOTIFICATION_MAV_READY              @"NOTIFICATION_MAV_READY"
#define NOTIFICATION_APP_TO_FOREGROUND      @"NOTIFICATION_APP_TO_FOREGROUND"

#import <Foundation/Foundation.h>
#import "eJTTS.h"
#import "WriteWavHeader.h"
typedef struct tagUserData
{
	FILE *	pInputFile;		// 文本输入文件
	FILE *	pOutputFile;	// 合成语音数据输出文件
	unsigned long	hTTS;	// 合成引擎句柄
    const char *cnText;
}jtUserData;

@interface TTSEngine : NSObject
{
	unsigned long		hTTS;		// 引擎句柄
	unsigned char       *pHeap;		// 外部空间指针
    FILE * 			fpOutPut;
}
- (void)stopSynthsize;
- (void)startSynthsizeInBackground:(NSString*)text;
- (void)synthesizeText:(NSString*)text;
@end
