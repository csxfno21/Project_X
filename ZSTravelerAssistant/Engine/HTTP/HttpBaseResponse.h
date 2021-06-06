//
//  HttpBaseResponse.h
//  Tourism
//
//  Created by csxfno21 on 13-4-3.
//  Copyright (c) 2013年 logic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpBaseResponse : NSObject
{
    REQUEST_CMD_CODE   cc_cmd_code;
    HTTP_ERR_CODE      error_code;
    id                 UIDelegate;
}
@property(nonatomic,assign)HTTP_ERR_CODE      error_code;
@property(nonatomic,assign)REQUEST_CMD_CODE   cc_cmd_code;
@property(nonatomic,assign)id                 UIDelegate;
@end
