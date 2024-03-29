//
//  CommonTableViewDelegate.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-9-10.
//  Copyright (c) 2013年 company. All rights reserved.
//

#ifndef ZSTravelerAssistant_CommonTableViewDelegate_h
#define ZSTravelerAssistant_CommonTableViewDelegate_h

@protocol CommonTableViewDelegate <NSObject>

- (void)commontableViewAction:(int)index withAction:(COMMON_NAV_TYPE)action withEntity:(id)entity;

@end
typedef enum
{
    TOUR_BUS_TYPE = 0,
    SPOT_BUS_TYPE = 1,
}BUS_TYPE;

@protocol CommonTableViewTwoDelegate <NSObject>

-(void)commonItemDidSelected:(int)index withBusType:(BUS_TYPE) busType withType:(COMMON_NAV_TYPE) action withEntity:(id)entiyty;

@end
#endif
