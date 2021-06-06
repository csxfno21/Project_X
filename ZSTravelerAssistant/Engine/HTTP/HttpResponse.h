//
//  BaseResponse.h
//  Tourism
//
//  Created by csxfno21 on 13-4-3.
//  Copyright (c) 2013年 logic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpResponse : NSObject
{
    REQUEST_CMD_CODE cmdCode;
    NSData              *data;
    int              index;
    id               UIDelegate;
    HTTP_ERR_CODE    errorCode;
}
@property(nonatomic,assign)HTTP_ERR_CODE    errorCode;
@property(nonatomic,assign)int              index;
@property(nonatomic,assign)id               UIDelegate;
@property(nonatomic,assign)REQUEST_CMD_CODE cmdCode;
@property(nonatomic,copy)NSData *data;
@end
