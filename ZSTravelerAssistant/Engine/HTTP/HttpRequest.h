//
//  BaseRequest.h
//  Tourism
//
//  Created by csxfno21 on 13-4-3.
//  Copyright (c) 2013年 logic. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    MSG = 0,
    UPLOAD,
    DOWNLOAD,
}Request_Type;

@interface HttpRequest : NSObject
{
    Request_Type requestType;
    REQUEST_CMD_CODE cmdCode;
    NSData          *postData;
    NSString        *url;
    id            delegate;
    id            UIDelegate;
    int          index;
}
@property(nonatomic,assign)int          index;
@property(nonatomic,assign)Request_Type requestType;
@property(nonatomic,assign)REQUEST_CMD_CODE cmdCode;
@property(nonatomic,assign)id            delegate;
@property(nonatomic,assign)id            UIDelegate;
@property(nonatomic,retain)NSString *url;
@property(nonatomic,retain)NSData   *postData;
@end
