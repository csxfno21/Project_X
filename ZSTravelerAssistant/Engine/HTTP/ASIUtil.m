//
//  ASIUtil.m
//  Tourism
//
//  Created by csxfno21 on 13-4-3.
//  Copyright (c) 2013年 logic. All rights reserved.
//

#import "ASIUtil.h"
static ASIUtil *asiUtil;
@implementation ASIUtil
@synthesize httpQueue,downloadQueue,downloadDictionary,requestArray;
- (id) init {
    
    if(self = [super init])
    {
        ASINetworkQueue *queue = [[ASINetworkQueue alloc] init];
        self.httpQueue = queue;
        [queue release];
        
        queue = [[ASINetworkQueue alloc] init];
        self.downloadQueue = queue;
        [queue release];
        
        NSMutableArray  *requestarray = [[NSMutableArray alloc] init];
        self.requestArray = requestarray;
        [requestarray release];
        
        NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
        self.downloadDictionary = dictionary;
        [dictionary release];
        
        [self.httpQueue reset];
        [self.httpQueue setDelegate:self];
        [self.httpQueue setRequestDidStartSelector:@selector(requestDidStart:)];
        [self.httpQueue setRequestDidReceiveResponseHeadersSelector:@selector(request:didRecieveResponseHeaders:)];
        [self.httpQueue setRequestWillRedirectSelector:@selector(request:willRedirectToNewURL:)];
        [self.httpQueue setRequestDidFinishSelector:@selector(requestDidFinish:)];
        [self.httpQueue setRequestDidFailSelector:@selector(requestDidFail:)];
        [self.httpQueue setQueueDidFinishSelector:@selector(queueDidFinish:)];
        [self.httpQueue setMaxConcurrentOperationCount:3];
        [self.httpQueue setShouldCancelAllRequestsOnFailure:NO];
        [self.httpQueue go];
        
        [self.downloadQueue reset];
        [self.downloadQueue setDelegate:self];
        [self.downloadQueue setRequestDidStartSelector:@selector(requestDidStart:)];
        [self.downloadQueue setRequestDidReceiveResponseHeadersSelector:@selector(request:didRecieveResponseHeaders:)];
        [self.downloadQueue setRequestWillRedirectSelector:@selector(request:willRedirectToNewURL:)];
        [self.downloadQueue setRequestDidFinishSelector:@selector(requestDidFinish:)];
        [self.downloadQueue setRequestDidFailSelector:@selector(requestDidFail:)];
        [self.downloadQueue setQueueDidFinishSelector:@selector(queueDidFinish:)];
        [self.downloadQueue setMaxConcurrentOperationCount:3];
        [self.downloadQueue setShouldCancelAllRequestsOnFailure:NO];
        [self.downloadQueue setShowAccurateProgress:YES];
        [self.downloadQueue go];
    }
    
    return self;
}
+ (ASIUtil*)sharedInstance
{
    @synchronized(self)
    {
        if(asiUtil == nil)
        {
            asiUtil = [[ASIUtil alloc] init];
        }
    }
    
    return asiUtil;
}
+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (asiUtil == nil)
        {
            asiUtil = [super allocWithZone:zone];
            return asiUtil;
        }
    }
    return nil;
}
- (id)retain
{
    return self;
}
- (id)autorelease
{
    return self;
}
- (void)dealloc
{
    SAFERELEASE(httpQueue)
    SAFERELEASE(downloadQueue)
    SAFERELEASE(requestArray)
    SAFERELEASE(downloadDictionary)
    [super dealloc];
}

- (void) POSTREQUEST:(HttpRequest*)postRequest withHeader:(NSString*)header
{
    NSString *urlFormat =  [postRequest.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"URL:%@",urlFormat);
    if(urlFormat == nil || urlFormat.length == 0)
    {
        return;
    }
    NSURL *requestUrl = [NSURL URLWithString:urlFormat];
    switch (postRequest.requestType)
    {
        case MSG:
        {
            AsyncHttpRequest *request = [AsyncHttpRequest requestWithURL:requestUrl];
            [self.requestArray addObject:request];
            NSData *data = postRequest.postData;
            [request appendPostData:data];
            request.downIndex = postRequest.index;
            request.requestDelegae = postRequest.delegate;
            request.requestUIDelegae = postRequest.UIDelegate;
            request.cmdCode = postRequest.cmdCode;
            [request setRequestMethod:@"POST"];
            NSMutableDictionary* dicHeaders = [NSMutableDictionary dictionaryWithCapacity:1];
            [dicHeaders setObject:header forKey:@"Content-Type"];
            [request setRequestHeaders:dicHeaders];
            //    [request setUploadProgressDelegate:self];
            //    [request setDownloadProgressDelegate:self];
            
            //设置是否压缩post数据
            [request setShouldCompressRequestBody:NO];
            [request setAllowCompressedResponse:NO];
            
            [self.httpQueue addOperation:request];
            break;
        }
        case DOWNLOAD:
        {
            break;
        }
        default:
            break;
    }
    
    
}

- (void) POSTRequest:(HttpRequest*)postRequest
{
    NSString *urlFormat =  [postRequest.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"URL:%@",urlFormat);
    if(urlFormat == nil || urlFormat.length == 0)
    {
        return;
    }
    NSURL *requestUrl = [NSURL URLWithString:urlFormat];
    switch (postRequest.requestType)
    {
        case MSG:
        {
            AsyncHttpRequest *request = [AsyncHttpRequest requestWithURL:requestUrl];
            [self.requestArray addObject:request];
            NSData *data = postRequest.postData;
            [request appendPostData:data];
            request.downIndex = postRequest.index;
            request.requestDelegae = postRequest.delegate;
            request.requestUIDelegae = postRequest.UIDelegate;
            request.cmdCode = postRequest.cmdCode;
            [request setRequestMethod:@"POST"];
            NSMutableDictionary* dicHeaders = [NSMutableDictionary dictionaryWithCapacity:1];
            [dicHeaders setObject:@"application/bin;charset=UTF-8;" forKey:@"Content-Type"];
            [request setRequestHeaders:dicHeaders];
            //    [request setUploadProgressDelegate:self];
            //    [request setDownloadProgressDelegate:self];
            
            //设置是否压缩post数据
            [request setShouldCompressRequestBody:NO];
            [request setAllowCompressedResponse:NO];
            
            [self.httpQueue addOperation:request];
            break;
        }
        case DOWNLOAD:
        {
            break;
        }
        default:
            break;
    }

    
}
- (void) GETRequest:(HttpRequest*)getRequest
{
    NSString *urlFormat =  [getRequest.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"URL:%@",urlFormat);
    if(urlFormat == nil || urlFormat.length == 0)
    {
        return;
    }
    NSURL *requestUrl = [NSURL URLWithString:urlFormat];
    switch (getRequest.requestType)
    {
        case MSG:
        {

            break;
        }
        case DOWNLOAD:
        {
            AsyncHttpRequest *request = [AsyncHttpRequest requestWithURL:requestUrl];
            [self.requestArray addObject:request];
            NSData *data = getRequest.postData;
            [request appendPostData:data];
            request.requestDelegae = getRequest.delegate;
            request.requestUIDelegae = getRequest.UIDelegate;
            request.cmdCode = getRequest.cmdCode;
            request.downIndex = getRequest.index;
            [request setRequestMethod:@"GET"];
            NSMutableDictionary* dicHeaders = [NSMutableDictionary dictionaryWithCapacity:1];
            [dicHeaders setObject:@"applicatioin/bin;charset=UTF-8" forKey:@"Content-Type"];
            [request setRequestHeaders:dicHeaders];
            //    [request setUploadProgressDelegate:self];
            //    [request setDownloadProgressDelegate:self];
            
            //设置是否压缩数据
            [request setShouldCompressRequestBody:NO];
            [request setAllowCompressedResponse:NO];
            
            [self.httpQueue addOperation:request];
            break;
        }
        default:
            break;
    }
    
}

- (void) cancelRequest:(id)delegate
{
    NSMutableArray *needRemoveRequest = [[NSMutableArray alloc] init];
    for(AsyncHttpRequest *request in self.requestArray)
    {
        if(request.requestDelegae == delegate || request.requestUIDelegae == delegate)
        {
            request.requestDelegae = nil;
            request.requestUIDelegae = nil;
            [request cancel];
            [needRemoveRequest addObject:request];
        }
    }
    for(AsyncHttpRequest *request in needRemoveRequest)
    {
        [self.requestArray removeObject:request];
    }
    [needRemoveRequest release];
}
- (void) cancelRequestWithCode:(REQUEST_CMD_CODE)cc_code
{
    NSMutableArray *needRemoveRequest = [[NSMutableArray alloc] init];
    for(AsyncHttpRequest *request in self.requestArray)
    {
        if(request.cmdCode == cc_code)
        {
            request.requestDelegae = nil;
            request.requestUIDelegae = nil;
            [request cancel];
            [needRemoveRequest addObject:request];
        }
    }
    for(AsyncHttpRequest *request in needRemoveRequest)
    {
        [self.requestArray removeObject:request];
    }
    [needRemoveRequest release];
}
- (void)cancelAllRequest
{
    for(AsyncHttpRequest *request in self.requestArray)
    {
        request.requestDelegae = nil;
        request.requestUIDelegae = nil;
        [request cancel];
    }
    [self.requestArray removeAllObjects];
}

- (void) requestDidStart:(AsyncHttpRequest*) request
{
    
}
- (void) request:(AsyncHttpRequest*) request didRecieveResponseHeaders:(NSDictionary*) header
{
    
}
- (void) request:(AsyncHttpRequest*) request willRedirectToNewURL:(NSURL*) newUrl
{
    
}
- (void) requestDidFinish:(AsyncHttpRequest*) request
{
    NSData* responseData = [request responseData];
//    int statusCode = [request responseStatusCode];
    HttpResponse * response = [[HttpResponse alloc] init];
    response.cmdCode = request.cmdCode;
    response.data = responseData;
    response.UIDelegate = request.requestUIDelegae;
    response.index = request.downIndex;
    response.errorCode = request.error.code;
    id delegate = request.requestDelegae;
    
    if(delegate && [delegate respondsToSelector:@selector(reciveHttpRespondInfo:)])
    {
        [delegate reciveHttpRespondInfo:response];
    }
    [response release];
    [requestArray removeObject:request];
}
- (void) requestDidFail:(AsyncHttpRequest*) request
{
    NSData* responseData = [request responseData];
    //    int statusCode = [request responseStatusCode];
    HttpResponse * response = [[HttpResponse alloc] init];
    response.cmdCode = request.cmdCode;
    response.data = responseData;
    response.UIDelegate = request.requestUIDelegae;
    id delegate = request.requestDelegae;
    response.index = request.downIndex;
    response.errorCode = request.error.code;
    if ([PublicUtils getNetState] == NotReachable)
    {
        response.errorCode = E_HTTPERR_NETCLOSE;//当前没有网络
    }
    if(delegate && [delegate respondsToSelector:@selector(reciveHttpRespondInfo:)])
    {
        [delegate reciveHttpRespondInfo:response];
    }
    [requestArray removeObject:request];
    [response release];
}
- (void) queueDidFinish:(ASINetworkQueue*) queue
{
    
}

#pragma mark -
#pragma mark ASINetworkQueueDelegate
- (void)requestStarted:(ASIHTTPRequest *)request
{
    NSLog(@"requestStarted");
}
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    NSLog(@"didReceiveResponseHeaders");
}
- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL
{
    NSLog(@"willRedirectToURL");
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"requestFinished");
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"requestFailed");
}
- (void)requestRedirected:(ASIHTTPRequest *)request
{
    NSLog(@"requestRedirected");
}
- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data;
{
    NSLog(@"didReceiveData");
}
- (void)authenticationNeededForRequest:(ASIHTTPRequest *)request
{
    NSLog(@"authenticationNeededForRequest");
}
- (void)proxyAuthenticationNeededForRequest:(ASIHTTPRequest *)request
{
    NSLog(@"proxyAuthenticationNeededForRequest");
}
@end




@implementation AsyncHttpRequest
@synthesize requestDelegae,requestUIDelegae,cmdCode,downIndex;

- (void)dealloc
{
    requestDelegae = nil;
    requestUIDelegae = nil;
    [super dealloc];
}
@end
