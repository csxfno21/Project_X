//
//  MyNavController.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-6.
//  Copyright (c) 2013年 company. All rights reserved.
//


#import "BaseViewController.h"
#import "AroundNavPopView.h"
#import "LocationPoint.h"
#import "TextMarkDrawer.h"
#import "CallOutDrawer.h"
#import "MapManagerDelegate.h"
#import "NavigationDrawer.h"
#import "RouteNavPopView.h"
#import "ScenicSpeaker.h"
//#import "TabbarItemView.h"
#import "NavCenterLineDrawer.h"
#import "NavigationView.h"
#import "NavigationPopMoreView.h"
#import "GatherCalloutView.h"

typedef enum {
	CLICK_MAP_FINDSPOT = 0,     //查看景点
    CLICK_MAP_GATHER = 1,       //选择集合点
}CLICK_MAP_TYPE;

@protocol gatherTeamCompleteDelegate <NSObject>

- (void) gatherTeamCompleteAtPoint:(AGSPoint*)location;

@end

@interface MyNavController : BaseViewController<RouteNavPopViewDelegate,AGSMapViewTouchDelegate,AGSMapViewLayerDelegate,AGSMapViewTouchDelegate,AroundNavPopViewDelegate,HttpManagerDelegate,MapManagerDelegate,UIGestureRecognizerDelegate,AGSQueryTaskDelegate,TextMarkDrawerDelegate,LocationPointDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NavigationPopMoreViewDelegate,NavigationViewDelegate,
    GatherTeamBtnDelegate>
{
    LocationPoint *locationPoint;
    TextMarkDrawer *textMarkDrawer;//注记图层
    CallOutDrawer *callOutDrawer;  //弹出
    NavigationDrawer *navigationDrawer;
    
    NavCenterLineDrawer *centerLineDrawer;
    
    LOCATION_TYPE   rotateType;
    NSMutableDictionary *waitingMoeth;//等待指令
    
    ScenicSpeaker *baseScenicSpeak;
    NavigationView *navigationView;
    NSMutableArray *navgationViews;
   
}

@property (retain, nonatomic) IBOutlet UIImageView *topBarImgView;
@property (retain, nonatomic) IBOutlet UIButton *backBtn;
@property (retain, nonatomic) IBOutlet UILabel *navTitle;
@property (retain, nonatomic) IBOutlet UIButton *settingBtn;
@property (retain, nonatomic) IBOutlet AGSMapView *map;

@property (retain, nonatomic) IBOutlet UIToolbar *bottomBar;

@property (retain, nonatomic) IBOutlet UIImageView *mapCompass;
@property (retain, nonatomic) IBOutlet UIButton *locationBtn;
@property (retain, nonatomic) IBOutlet UIButton *zoomBtn;
@property (retain, nonatomic) IBOutlet UIButton *fullBtn;
@property (retain, nonatomic) IBOutlet UIButton *narrowBtn;
@property (retain, nonatomic) IBOutlet UIButton *mapScalView;

@property (retain, nonatomic) IBOutlet UIButton *menuBtn;
@property (retain, nonatomic) IBOutlet UILabel *backLabel;
@property ( nonatomic) CLICK_MAP_TYPE clickMapType;

- (void)setWaitingMoeth:(int)moeth withObj:(id)obj;

@end
