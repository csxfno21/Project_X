//
//  DwonImgResponse.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-8.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "HttpBaseResponse.h"

@interface DwonImgResponse : HttpBaseResponse
{
    BOOL  downSuccess;
    int   imgID;
}
@property(assign,nonatomic)BOOL  downSuccess;
@property(assign,nonatomic)int   imgID;
@end
