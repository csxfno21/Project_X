//
//  ASIUtil.h
//  Tourism
//
//  Created by csxfno21 on 13-4-3.
//  Copyright (c) 2013年 logic. All rights reserved.
//
@protocol ASIRequestInteface <NSObject>
- (void) cancelRequestWithCode:(REQUEST_CMD_CODE)cc_code;
- (void) cancelRequest:(id)delegate;
- (void)cancelAllRequest;
@end
#import <Foundation/Foundation.h>
#import "HttpRequest.h"
#import "HttpResponse.h"
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
#import "HttpManagerCenter.h"
@interface ASIUtil : NSObject<ASIHTTPRequestDelegate,ASIRequestInteface>
{
    ASINetworkQueue *httpQueue;// http任务队列
    ASINetworkQueue *downloadQueue;//  http下载队列
    NSMutableArray  *requestArray;
    NSMutableDictionary *downloadDictionary;// http下载字典，用于取消请求
}
@property (nonatomic,retain) ASINetworkQueue *httpQueue;
@property (nonatomic,retain) ASINetworkQueue *downloadQueue;
@property (nonatomic,retain) NSMutableArray  *requestArray;
@property (nonatomic,retain) NSMutableDictionary *downloadDictionary;
+ (ASIUtil*)sharedInstance;

//- (void) requestDidStart:(ASIHTTPRequest*) request;
//- (void) request:(ASIHTTPRequest*) request didRecieveResponseHeaders:(NSDictionary*) header;
//- (void) request:(ASIHTTPRequest*) request willRedirectToNewURL:(NSURL*) newUrl;
//- (void) requestDidFinish:(ASIHTTPRequest*) request;
//- (void) requestDidFail:(ASIHTTPRequest*) request;
//- (void) queueDidFinish:(ASINetworkQueue*) queue;

- (void) POSTREQUEST:(HttpRequest*)postRequest withHeader:(NSString*)header;
- (void) POSTRequest:(HttpRequest*)postRequest;
- (void) GETRequest:(HttpRequest*)getRequest;
@end

@interface AsyncHttpRequest : ASIHTTPRequest
{
    int      downIndex;
    id       requestDelegae;
    id       requestUIDelegae;
    REQUEST_CMD_CODE   cmdCode;
    
}
@property(nonatomic,assign)int      downIndex;
@property(nonatomic,assign)id requestDelegae;
@property(nonatomic,assign)id requestUIDelegae;
@property(nonatomic,assign)REQUEST_CMD_CODE   cmdCode;
@end
