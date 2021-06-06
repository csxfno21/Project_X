//
//  StringDef.h
//  Tourism
//
//  Created by csxfno21 on 13-4-1.
//  Copyright (c) 2013年 szmap. All rights reserved.
//
#pragma mark-
#define NOTIFY_NETUNCONNECT         @"netUnconnect"
#define NOTIFY_NETCONNECT           @"netconnect"
#define NOTIFY_MEDIAVALUE_CHAGE     @"NOTIFY_MEDIAVALUE_CHAGE"
#define NOTIFY_APPWILLEFOREGROUND  @"applicationWillEnterForeground"

#pragma mark - Server    

#ifndef SERVER_SERVICE
#define SERVER_SERVICE
#endif


#ifdef SERVER_SERVICE
#define  SERVER_IP                                  @"http://202.119.107.85:8011"
#define  SERVER_ADDRESS                             [NSString stringWithFormat:@"%@%@",SERVER_IP,@"/TourService.svc/"]
#define  SERVER_ROUTE_REQUEST_ADDRESS               @"http://202.119.107.85:8012/MapServer/rest/services/"
#define  SERVER_ARRRESS_MAP                         @"http://202.119.107.85:8012/MapServer/rest/services/ZS_Map/MapServer"
#define  SERVER_ARRRESS_MAP_MARK_TEXT_TASK          @"http://202.119.107.85:8012/MapServer/rest/services/ZS_Map/MapServer/0"
#define  SERVER_ARRRESS_MAP_CALLOUT_TASK            @"http://202.119.107.85:8012/MapServer/rest/services/ZS_Map/MapServer/2"
#endif

#ifdef SERVER_LOCAL
#define  SERVER_IP                                  @"http://192.168.1.12:8011"
#define  SERVER_ADDRESS                             [NSString stringWithFormat:@"%@%@",SERVER_IP,@"/TourService.svc/"]
#define  SERVER_ROUTE_REQUEST_ADDRESS               @"http://192.168.1.12:8012/MapServer/rest/services/"
#define  SERVER_ARRRESS_MAP                         @"http://192.168.1.12:8012/MapServer/rest/services/ZS_Map/MapServer"
#define  SERVER_ARRRESS_MAP_MARK_TEXT_TASK          @"http://192.168.1.12:8012/MapServer/rest/services/ZS_Map/MapServer/1"
#define  SERVER_ARRRESS_MAP_CALLOUT_TASK            @"http://192.168.1.12:8012/MapServer/rest/services/ZS_Map/MapServer/2"
#endif




#define  ACTION_CHECK_APPLICATION_VERSION           @"checkAppVersion"
#define  ACTION_CHECK_TABLE_VERSION                 @"checkTableVersion"
#define  ACTION_GET_MAIN_SCORLL_SPOTS               @"getMianScrolSpots"
#define  ACTION_GET_INFO                            @"getInfo"
#define  ACTION_GET_SEASON_INFO                     @"getSeasonInfo"
#define  ACTION_GET_SEASON_INFO_MORE                @"getSeasonInfoMore"
#define  ACTION_GET_REC_INFO                        @"getSeasonInfo"
#define  ACTION_GET_REC_INFO_MORE                   @"getSeasonInfoMore"

#define  ACTION_GET_TRAFFIC                         @"getTraffic"
#define  ACTION_GET_BUSS                            @"getBusInfo"
#define  ACTION_GET_BUSS_MORE                       @"getBusInfoMore"
#define  ACTION_GET_TOURIS                          @"getTourisCar"
#define  ACTION_GET_TOURIS_MORE                     @"getTourisCarMore"

#define  ACTION_GET_ROUTE                           @"getRoute"
#define  ACTION_GET_THEM_ROUTE                      @"getThemeRoute"
#define  ACTION_GET_THEM_ROUTE_MORE                 @"getThemeRouteMore"
#define  ACTION_GET_COMMON_ROUTE                    @"getCommonRoute"
#define  ACTION_GET_COMMON_ROUTE_MORE               @"getCommonRouteMore"

#define  ACTION_GET_SPOT                            @"getSpot"
#define  ACTION_GET_VIEW_SPOT                       @"getCustomSpotDetail"
#define  ACTION_GET_NVIEW_SPOT                      @"getNViewSpot"
#define  ACTION_GET_VIEW_SPOT_MORE                  @"getCustomSpotDetailMore"
#define  ACTION_GET_NVIEW_SPOT_MORE                 @"getNViewSpotMore"
#define  ACTION_GET_SPOT_BY_ID                      @"getCustomSpotDetailByID"

#define  ACTION_GET_POI                             @"getPoi"
#define  ACTION_GET_POIRELATION                     @"getPoirelationMore"

#define  ACTION_GET_SPEAK                           @"getSpeakData"
#define  ACTION_GET_SCENIC                          @"getScenic"

#define  ACTION_GET_ROUTE_SECTION                   @"GetRouteService"


#define  ACTION_GET_MAP_ROUTE                      @"&barriers=&polylineBarriers=&polygonBarriers=&outSR=4326&ignoreInvalidLocations=true&accumulateAttributeNames=&impedanceAttributeName=dis&restrictionAttributeNames=&attributeParameterValues=&restrictUTurns=esriNFSBAllowBacktrack&useHierarchy=false&returnDirections=true&returnRoutes=false&returnStops=false&returnBarriers=false&returnPolylineBarriers=false&returnPolygonBarriers=false&directionsLanguage=zh-CN&directionsStyleName=NA+Desktop&outputLines=esriNAOutputLineTrueShape&findBestSequence=false&preserveFirstStop=true&preserveLastStop=true&useTimeWindows=false&startTime=&outputGeometryPrecision=&outputGeometryPrecisionUnits=esriMeters&directionsTimeAttributeName=&directionsLengthUnits=esriNAUMeters&f=json"
#define  ACTION_GET_MAP_ROUTE_WALK                  [NSString stringWithFormat:@"%@ZS_RouteWalk/NAServer/route/solve?",SERVER_ROUTE_REQUEST_ADDRESS]
#define  ACTION_GET_MAP_ROUTE_CAR                   [NSString stringWithFormat:@"%@ZS_RouteCar/NAServer/route/solve?",SERVER_ROUTE_REQUEST_ADDRESS]
#define  ACTION_GET_MAP_ROUTE_TOURCAR               [NSString stringWithFormat:@"%@ZS_RouteTourCar/NAServer/route/solve?",SERVER_ROUTE_REQUEST_ADDRESS]

#define  ACTION_GET_MAP_ROUTE_POST(stops)           [NSString stringWithFormat:@"stops=%@%@",stops,ACTION_GET_MAP_ROUTE]


#define  COUNTY_KEY                                 @"b8bd8c9e72cd70523b7ae6fcf014261e"







#define NOTIFICATION_REMOVE_SPOT      @"NOTIFICATION_REMOVE_SPOT"














