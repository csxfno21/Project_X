//
//  MsgConstant.h
//  Tourism
//
//  Created by csxfno21 on 13-4-3.
//  Copyright (c) 2013年 szmap. All rights reserved.
//

// request comd code
typedef enum
{
    //SYSTEM
    CC_VERSION_CHECK        = 0x0001,
    CC_NET_CHECK            = 0x0002,
    
    //USER
    CC_LOGIN                = 0x0101,
    CC_REGISTER             = 0x0102,
    CC_LOGOUT               = 0X0103,
    CC_FORGET               = 0X0104,
    
    CC_CHECK_TABLE_VERSION  = 0x0201,      //数据版本检查
    CC_GET_MAIN_SCROL_SPOTS = 0x0202,      //获取主页面 滚动景点信息
    CC_GET_INFO             = 0x0203,      //获取资讯
    CC_GET_SEASON_INFO      = 0x0204,      //获取季节推荐
    CC_GET_SEASON_INFO_MORE = 0x0205,      //获取季节推荐 更多
    CC_GET_REC_INFO         = 0x0206,      //获取季节推荐
    CC_GET_REC_INFO_MORE    = 0x0207,      //获取季节推荐 更多
    CC_GET_TRAFFIC          = 0x0208,      //获取交通
    CC_GET_BUSS_INFO        = 0x0209,      //获取公交
    CC_GET_BUSS_INFO_MORE   = 0x0301,      //获取公交 更多
    CC_GET_TOURISCAR_INFO   = 0x0302,      //获取景区公交
    CC_GET_TOURISCAR_INFO_MORE = 0x0303,   //获取景区公交 更多
    CC_GET_ROUTE            = 0x0304,      //获取线路
    CC_GET_THEM_ROUTE       = 0x0305,      //获取主题线路
    CC_GET_THEM_ROUTE_MORE  = 0x0306,      //获取主题线路 更多
    CC_GET_COMMON_ROUTE       = 0x0307,    //获取常规线路
    CC_GET_COMMON_ROUTE_MORE  = 0x0308,    //获取常规线路 更多
    CC_GET_SPOT             = 0x0309,      //获取景点
    CC_GET_VIEW_SPOT        = 0x0401,      //获取可视的景点 
    CC_GET_NVIEW_SPOT       = 0x0402,      //获取非可视的景点
    CC_GET_VIEW_SPOT_MORE   = 0x0403,      //获取可视的景点    更多
    CC_GET_NVIEW_SPOT_MORE  = 0x0404,      //获取非可视的景点  更多
    CC_GET_POI              = 0x0405,      //获取周边poi点
    CC_GET_SPEAK            = 0x0406,      //获取播报数据
    CC_GET_SCENIC           = 0x0407,      //获取缓冲区
    CC_GET_WORK_ROUTE       = 0x0408,
    CC_GET_CAR_ROUTE        = 0x0409,
    CC_GET_TOURCAR_ROUTE    = 0x0501,
    CC_GET_POI_RELATION     = 0x0502,      //获取poi关联信息表
    CC_GET_ROUTE_SECTION_CAR    = 0x0503,      //获取路段信息
    CC_GET_ROUTE_SECTION_TOUR_CAR    = 0x0504,      //获取路段信息
    CC_GET_ROUTE_SECTION_WALK    = 0x0505,      //获取路段信息
    
    //DOWLOAD
    CC_DOWN_IMAGE_RECOMMEND = 0x0901,
    CC_DOWN_IMAGE_SEASONINFO= 0x0902,
    CC_DOWN_IMAGE_SEASONINFO_BIG= 0x0903,
    CC_DOWN_IMAGE_REC_INFO  = 0x0904,
    CC_DOWN_IMAGE_REC_INFO_BIG= 0x0905,
    CC_DOWN_IMAGE_THEM_ROUTE_SMALL = 0x0906,
    CC_DOWN_IMAGE_COMMON_ROUTE_SMALL = 0x0907,
    CC_DOWN_IMAGE_SPOT      = 0x0908,
    CC_DOWN_IMAGE_SPOT_SMALL = 0x0909,
    CC_UNKNOW               = -1
}REQUEST_CMD_CODE;

typedef enum {
	E_HTTPSUCCEES = 0,              //成功
	E_HTTPERR_CANCEL,               //HTTP 取消请求
	E_HTTPERR_TIMEOUT,              //请求超时
	E_HTTPERR_AUTH,                 //认证错误
	E_HTTPERR_UNABLECREATE,         //无法连接
	E_HTTPERR_TOOMUTHREDIRECT,      //重定向
	E_HTTPERR_NETCLOSE,             //网络关闭
	E_HTTPERR_FAILED= -1            //失败
}HTTP_ERR_CODE;

