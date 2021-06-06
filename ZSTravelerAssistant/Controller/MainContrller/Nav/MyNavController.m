//
//  MyNavController.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-6.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "MyNavController.h"
#import "MusicPlayManager.h"
#import "SpotManager.h"
#import "SOSViewController.h"
#import "SetViewController.h"
#import "TeamServiceViewController.h"
#import "AroundDetailViewController.h"
#import "CommonViewController.h"
#import "SpotViewController.h"
#import "AroundDetailTwoViewController.h"

#import "ScenicBufferDrawUtil.h"
#import "Config.h"
#import "TabbarItemView.h"


#define TOOLS_BAR_TAG       1000
@interface MyNavController ()

@end

@implementation MyNavController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [PublicUtils disabeledScreen:YES];
    if (self.map)
    {
        self.map.allowRotationByPinching = [Config isRotation];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [PublicUtils disabeledScreen:NO];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[MapManager sharedInstanced] registerMapManagerNotification:self];
    [[MusicPlayManager sharedInstanced] playMusicWithType:MUSIC_TYPE_NAV];
    [[MapManager sharedInstanced] startUpdateHeading];
    baseScenicSpeak = [[ScenicSpeaker alloc] init];
    navigationView = [NavigationView instanceNavigationView];
    navigationView.delegate = self;
    navigationView.frame = self.view.bounds;
    navgationViews = [[NSMutableArray alloc] init];
    [navgationViews addObjectsFromArray:navigationView.subviews];
    for (UIView *subView in navgationViews)
    {
        if (subView)
        {
            subView.hidden = YES;
            [self.view addSubview:subView];
            if ([subView isKindOfClass:[UIButton class]])
            {
                UIButton *btn = (UIButton*)subView;
                [btn addTarget:self action:@selector(go:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callOutAction:) name:@"CallOutAction" object:nil];
    
    //单指双击
    UITapGestureRecognizer *singleFingerTwo = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handleSingleFingerEvent:)];
    singleFingerTwo.numberOfTouchesRequired = 1;
    singleFingerTwo.numberOfTapsRequired = 2;
    singleFingerTwo.delegate = self;
    
    //双指单击
    UITapGestureRecognizer *doubleFingerTwo = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleDoubleFingerEvent:)];
    doubleFingerTwo.numberOfTouchesRequired = 2;
    doubleFingerTwo.numberOfTapsRequired = 1;
    doubleFingerTwo.delegate = self;
    
    // 放大缩小手势
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(scale:)];
    pinchRecognizer.delegate = self;
    
    // 旋转手势
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotatePiece:)];
    
    [self.view addGestureRecognizer:singleFingerTwo];
    [self.view addGestureRecognizer:doubleFingerTwo];
    [self.view addGestureRecognizer:pinchRecognizer];
    [self.view addGestureRecognizer:rotationGesture];
    
    SAFERELEASE(singleFingerTwo)
    SAFERELEASE(doubleFingerTwo)
    SAFERELEASE(pinchRecognizer)
    SAFERELEASE(rotationGesture)
    
    self.navTitle.text = [Language stringWithName:WELCOME_TO_ZHONGSHAN_TITLE];
    
    [self.settingBtn setImage:[UIImage imageNamed:@"Setting-on.png"] forState:UIControlStateHighlighted];
    
    self.backLabel.text = [Language stringWithName:BACK];
    [self.menuBtn setTitle:[Language stringWithName:MENU] forState:UIControlStateNormal];

    
    UIBarButtonItem *SOSItem;
    UIBarButtonItem *spotItem;
    UIBarButtonItem *aroundItem;
    UIBarButtonItem *commonItem;
    UIBarButtonItem *teamItem;
    UIBarButtonItem *photoItem;
    if ([PublicUtils systemVersion].floatValue >= 7.0)
    {
        TabbarItemView *tabbaritem1 = [[TabbarItemView alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
        tabbaritem1.imgView.image = [UIImage imageNamed:@"navSOS.png"];
        tabbaritem1.backgroundColor = [UIColor clearColor];
        tabbaritem1.titleLabel.text = [Language stringWithName:HELP];
        [tabbaritem1 addTarget:self action:@selector(toolsBarAction:) forControlEvents:UIControlEventTouchUpInside];
        tabbaritem1.tag =  TOOLS_BAR_TAG + 5;
        SOSItem = [[[UIBarButtonItem alloc] initWithCustomView:tabbaritem1] autorelease];
        
        TabbarItemView *tabbaritem2 = [[TabbarItemView alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
        tabbaritem2.imgView.image = [UIImage imageNamed:@"navSpot.png"];
        tabbaritem2.backgroundColor = [UIColor clearColor];
        tabbaritem2.titleLabel.text = [Language stringWithName:SPOT];
        [tabbaritem2 addTarget:self action:@selector(toolsBarAction:) forControlEvents:UIControlEventTouchUpInside];
        tabbaritem2.tag =  TOOLS_BAR_TAG + 0;
        spotItem = [[[UIBarButtonItem alloc] initWithCustomView:tabbaritem2] autorelease];

        TabbarItemView *tabbaritem3 = [[TabbarItemView alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
        tabbaritem3.imgView.image = [UIImage imageNamed:@"navCommon.png"];
        tabbaritem3.backgroundColor = [UIColor clearColor];
        tabbaritem3.titleLabel.text = [Language stringWithName:COMMON];
        [tabbaritem3 addTarget:self action:@selector(toolsBarAction:) forControlEvents:UIControlEventTouchUpInside];
        tabbaritem3.tag =  TOOLS_BAR_TAG + 1;
        aroundItem = [[[UIBarButtonItem alloc] initWithCustomView:tabbaritem3] autorelease];
        
        TabbarItemView *tabbaritem4 = [[TabbarItemView alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
        tabbaritem4.imgView.image = [UIImage imageNamed:@"navAround.png"];
        tabbaritem4.backgroundColor = [UIColor clearColor];
        tabbaritem4.titleLabel.text = [Language stringWithName:AROUND];
        [tabbaritem4 addTarget:self action:@selector(toolsBarAction:) forControlEvents:UIControlEventTouchUpInside];
        tabbaritem4.tag =  TOOLS_BAR_TAG + 2;
        commonItem = [[[UIBarButtonItem alloc] initWithCustomView:tabbaritem4] autorelease];

        TabbarItemView *tabbaritem5 = [[TabbarItemView alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
        tabbaritem5.imgView.image = [UIImage imageNamed:@"navTeam.png"];
        tabbaritem5.backgroundColor = [UIColor clearColor];
        tabbaritem5.titleLabel.text = [Language stringWithName:TEAM];
        [tabbaritem5 addTarget:self action:@selector(toolsBarAction:) forControlEvents:UIControlEventTouchUpInside];
        tabbaritem5.tag =  TOOLS_BAR_TAG + 4;
        teamItem = [[[UIBarButtonItem alloc] initWithCustomView:tabbaritem5] autorelease];

        //拍照图标
        TabbarItemView *tabbaritem6 = [[TabbarItemView alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
        tabbaritem6.imgView.image = [UIImage imageNamed:@"navCamera.png"];
        tabbaritem6.backgroundColor = [UIColor clearColor];
        tabbaritem6.titleLabel.text = [Language stringWithName:PHOTO];
        [tabbaritem6 addTarget:self action:@selector(toolsBarAction:) forControlEvents:UIControlEventTouchUpInside];
        tabbaritem6.tag =  TOOLS_BAR_TAG + 3;
        photoItem = [[[UIBarButtonItem alloc] initWithCustomView:tabbaritem6] autorelease];

    }
    else
    {
        SOSItem = [[[UIBarButtonItem alloc] init] autorelease];
        [SOSItem setImage:[UIImage imageNamed:@"navSOS.png"]];
        [SOSItem setTitle:[Language stringWithName:HELP]];
        SOSItem.tag = TOOLS_BAR_TAG + 5;
        SOSItem.action = @selector(toolsBarAction:);
        
        spotItem = [[[UIBarButtonItem alloc] init] autorelease];
        [spotItem setImage:[UIImage imageNamed:@"navSpot.png"]];
        [spotItem setTitle:[Language stringWithName:SPOT]];
        spotItem.tag = TOOLS_BAR_TAG + 0;
        spotItem.action = @selector(toolsBarAction:);
        
        aroundItem = [[[UIBarButtonItem alloc] init] autorelease];
        [aroundItem setImage:[UIImage imageNamed:@"navCommon.png"]];
        [aroundItem setTitle:[Language stringWithName:COMMON]];
        aroundItem.tag = TOOLS_BAR_TAG + 1;
        aroundItem.action = @selector(toolsBarAction:);
        
        commonItem = [[[UIBarButtonItem alloc] init] autorelease];
        [commonItem setImage:[UIImage imageNamed:@"navAround.png"]];
        [commonItem setTitle:[Language stringWithName:AROUND]];
        commonItem.tag = TOOLS_BAR_TAG + 2;
        commonItem.action = @selector(toolsBarAction:);
        
        teamItem = [[[UIBarButtonItem alloc] init] autorelease];
        [teamItem setImage:[UIImage imageNamed:@"navTeam.png"]];
        [teamItem setTitle:[Language stringWithName:TEAM]];
        teamItem.tag = TOOLS_BAR_TAG + 4;
        teamItem.action = @selector(toolsBarAction:);
        //拍照图标
        photoItem = [[[UIBarButtonItem alloc] init] autorelease];
        [photoItem setImage:[UIImage imageNamed:@"navCamera.png"]];
        [photoItem setTitle:[Language stringWithName:PHOTO]];
        photoItem.tag = TOOLS_BAR_TAG + 3;
        photoItem.action = @selector(toolsBarAction:);
        
    }

    UIBarButtonItem *flexSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil] autorelease];  
    
    self.bottomBar.items = @[spotItem,flexSpace,aroundItem,flexSpace,commonItem,flexSpace,photoItem,flexSpace,teamItem,flexSpace,SOSItem];
    
    AGSTiledMapServiceLayer *mapLayer = [[AGSTiledMapServiceLayer alloc] initWithURL:[NSURL URLWithString:SERVER_ARRRESS_MAP]];
    
    self.map.allowRotationByPinching = [Config isRotation];
    self.map.layerDelegate = self;
    self.map.touchDelegate = self;
    [self.map addMapLayer:mapLayer withName:@"TiledMapLayer"];
    [self.map zoomToScale:MAP_DIDLOAD_SCALE withCenterPoint:[[[AGSPoint alloc] initWithX:118.849 y:32.059 spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326]] autorelease] animated:YES];
    
    [mapLayer release];
    
    //注记
    textMarkDrawer = [[TextMarkDrawer alloc] initWithMapView:self.map];
    textMarkDrawer.delegate = self;
    //弹出
    callOutDrawer = [[CallOutDrawer alloc] initWithMapView:self.map];
    
    // 测试绘制 景区面
//    [[[ScenicBufferDrawUtil alloc] initWithMapView:self.map] autorelease];
    
    navigationDrawer = [[NavigationDrawer alloc] initWithMapView:self.map];
    centerLineDrawer = [[NavCenterLineDrawer alloc] initWithMapView:self.map];
    
    
    //定位点
    locationPoint = [[LocationPoint alloc] initWithMapView:self.map];
    locationPoint.delegate = self;
    
    //默认 获取旧位置 显示
    [self didUpdateCurrentSenic:[MapManager sharedInstanced].currentScenic];
    
}

#pragma mark - CallOutAction
- (void)callOutAction:(NSNotification*)noti
{
    NSDictionary *dic = noti.object;
    int index = [ReplaceNULL2Empty([dic objectForKey:@"index"]) intValue];
    NSString *spotName = ReplaceNULL2Empty([dic objectForKey:@"title"]);
     ZS_CustomizedSpot_entity *entity = [[DataAccessManager sharedDataModel] getSpotByName:spotName];
    if (index == 1)
    {
        SpotDetailViewController *controller = [[SpotDetailViewController alloc] initWithNibName:@"SpotDetailViewController" bundle:nil];
        if (entity.SpotID.intValue == 0)
        {
            SAFERELEASE(controller);
            return;
        }
        controller.spotEntity = entity;
        [self.navigationController pushViewController:controller animated:YES];
        SAFERELEASE(controller);
    }
    else
    {
        //TODO 弹出导航 选项
        CGFloat xWidth = self.view.bounds.size.width - 30.0f;
        CGFloat yHeight = 300.0f;
        CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
        RouteNavPopView *popView = [RouteNavPopView instanceRouteNavPopView];
        popView.frame = CGRectMake(15, yOffset, xWidth, yHeight);
        [popView setTitleText:spotName];
        popView.delegate = self;
        [popView show];
        SCENIC_TYPE currentType = [MapManager sharedInstanced].currentScenic;
        if(currentType == SCENIC_LGS || currentType == SCENIC_MXL || currentType == SCENIC_ZSL)
        {
            popView.choseBtn1.enabled = NO;
            popView.entryLabel1.enabled = NO;
            popView.locationLabel1.enabled = NO;
            popView.parkingLabel.enabled = NO;
            popView.l1.enabled = NO;
            popView.l2.enabled = NO;
            [popView selectSecond];
        }
    }
}
#pragma mark - routeNavAction
- (void)routeNavAction:(int)index withType:(int)type
{
    BOOL isSimulation = type;
    NAV_TYPE nav_type = (NAV_TYPE)index;
    
    UIView *callOutView = self.map.callout.customView;
    if (callOutView && [callOutView isKindOfClass:[MapCallOutView class]])
    {
        MapCallOutView *callOut = (MapCallOutView*)callOutView;
        NSString *spotName = callOut.infoTitlelabel.text;
        ZS_CustomizedSpot_entity *entity = [[DataAccessManager sharedDataModel] getSpotByName:spotName];
        if (entity.SpotID.intValue != 0)
        {
            PoiPoint *poiPoint = [PoiPoint pointWithName:entity.SpotName withLongitude:entity.SpotLng.doubleValue withLatitude:entity.SpotLat.doubleValue withPoiID:entity.SpotID.intValue];
            [[MapManager sharedInstanced] startNavByOne:poiPoint withType:nav_type simulation:isSimulation withBarriers:@""];
            if (navigationDrawer)
            {
                [navigationDrawer clearGraphic];
            }
        }
    }
}

//处理单指事件
- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender
{
    if(sender.numberOfTapsRequired == 2)
    {
        //单指双击
        [self setMapScale];
        [self changeLocation2PointRotate];
    }
}
//处理双指事件
- (void)handleDoubleFingerEvent:(UITapGestureRecognizer *)sender
{
    if(sender.numberOfTapsRequired == 1)
    {
        //双指双击
        [self setMapScale];
        [self changeLocation2PointRotate];
    }
}

- (void)scale:(UIPinchGestureRecognizer *)sender
{
    [self setMapScale];
    [self changeLocation2PointRotate];
}

- (void)rotatePiece:(UIRotationGestureRecognizer *)sender
{
    [textMarkDrawer rotateGraphicAngel:+self.map.rotationAngle];
    [self changeLocation2PointRotate];
}


- (void)changeLocation2PointRotate
{
    if (locationPoint && rotateType == LOCATION_MAP_ROTATE)
    {
        rotateType = LOCATION_POINT_ROTATE;
        locationPoint.rotateType = LOCATION_POINT_ROTATE;
        [self.locationBtn setImage:[UIImage imageNamed:@"location-f.png"] forState:UIControlStateNormal];
    }
}

- (void)setMapScale
{
    int scal = (int)self.map.mapScale;
//    [callOutDrawer drawCallOutGraphic:scal];
    [textMarkDrawer drawTextMark:scal];
    NSString *title = @"";
    
    if(scal >= 100000)
    {
        title = [NSString stringWithFormat:@"%.2f公里",(float)(scal/1000.0f)];
    }
    else
    {
        title = [NSString stringWithFormat:@"%d米",scal/100];
    }
    [textMarkDrawer rotateGraphicAngel:+self.map.rotationAngle];
    if (scal == 0)
    {
        return;
    }
    [self.mapScalView setTitle:title forState:UIControlStateNormal];
}

#pragma mark AGSMapViewLayerDelegate methods
-(void) mapViewDidLoad:(AGSMapView*)mapView
{
    //设定最大拉伸尺度
    self.map.maxEnvelope = [[[AGSEnvelope alloc] initWithXmin:118.796 ymin:32.024 xmax:118.906 ymax:32.104 spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326]] autorelease];
    [self setMapScale];
}

#pragma mark AGSMapViewTouchDelegate methods
- (void)mapView:(AGSMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint graphics:(NSDictionary *)graphics
{
    switch (_clickMapType)
    {
        case CLICK_MAP_FINDSPOT:        //查看景点
            {
                //判断当遇到点击在路线图钉时候，直接弹出
                for (NSString*key in graphics.allKeys)
                {
                    NSArray *array = (NSArray*)[graphics objectForKey:key];
                    for (AGSGraphic *graphic in array)
                    {
                        if ([ReplaceNULL2Empty([graphic.allAttributes objectForKey:@"ROUTE_LINE_POI"]) boolValue])
                        {
                            return;
                        }
                    }
                }
                [self changeLocation2PointRotate];
                NSArray *array = textMarkDrawer.allTextMarkCache;
                double minDistance = CALLOUTSHOWTOLERANCE(self.map.mapScale);
                int index = -1;
                for (int i = 0;i < array.count ;i++)
                {
                    AGSGraphic *graphic = [array objectAtIndex:i];
                    if (!graphic.visible)
                    {
                        continue;
                    }
                    AGSPoint *asgpoint = [AGSPoint pointWithX:graphic.geometry.envelope.xmax y:graphic.geometry.envelope.ymax spatialReference:self.map.spatialReference];
                    double distance = [PublicUtils GetDistanceS:mappoint.x withlat1:mappoint.y withlng2:asgpoint.x withlat2:asgpoint.y];
                    
                    if (distance <= minDistance)
                    {
                        minDistance = distance;
                        index = i;
                    }
                }
                if (index > -1 && index < array.count)
                {
                    AGSGraphic *graphic = [array objectAtIndex:index];
                    AGSPoint *asgpoint = [AGSPoint pointWithX:graphic.geometry.envelope.xmax y:graphic.geometry.envelope.ymax spatialReference:self.map.spatialReference];
                    self.map.callout.customView = [callOutDrawer infoView:[graphic.allAttributes objectForKey:@"name"]];
                    [self.map.callout showCalloutAt:asgpoint pixelOffset:CGPointMake(0, 0) animated:YES];
                }
            }
            break;
        case CLICK_MAP_GATHER:
            {
                GatherCalloutView *view = [[[GatherCalloutView alloc] initWithFrame:CGRectMake(0, 0, 150, 20)] autorelease];
                view.location = mappoint;
                view.delegate = self;
                self.map.callout.customView = view;
                [self.map.callout showCalloutAt:mappoint pixelOffset:CGPointMake(0, 0) animated:YES];
            }
            break;
            
        default:
            break;
    }
    
    
}


#pragma mark - view action
- (void)toolsBarAction:(id)sender
{
    UIBarButtonItem *item = (UIBarButtonItem*)sender;
    switch (item.tag - TOOLS_BAR_TAG)
    {
        case 0:
        {
            [[SpotManager sharedInstance] requestGetViewSpot:self];
            break;
        }
        case 1:
        {
            CommonViewController *controller = [[CommonViewController  alloc]initWithNibName:@"CommonViewController" bundle:nil];
            controller.data = [[DataAccessManager sharedDataModel] getAllCommonNav];
            [self.navigationController pushViewController:controller animated:YES];
            SAFERELEASE(controller)
            break;
        }
        case 2:
        {
            CGFloat xWidth = self.view.bounds.size.width;
            CGFloat yHeight = 320.0f;
            CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
            AroundNavPopView *popView = [AroundNavPopView instanceSOSPopView];
            popView.frame = CGRectMake(0, yOffset, xWidth, yHeight);
            popView.delegate = self;
            [popView show];
            break;
        }
        case 3:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                //                picker.allowsEditing = YES;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentModalViewController:picker animated:YES];
                [picker release];
            }else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[Language stringWithName:ERROR] message:[Language stringWithName:NO_CAMERA] delegate:nil cancelButtonTitle:[Language stringWithName:CANCEL] otherButtonTitles:nil, nil];
                [alertView show];
                SAFERELEASE(alertView)
            }
            break;
        }
        case 4:
        {
            TeamServiceViewController *viewController = [[TeamServiceViewController alloc] initWithNibName:@"TeamServiceViewController" bundle:nil];
            [self.navigationController pushViewController:viewController animated:YES];
            SAFERELEASE(viewController)

            break;
        }
        case 5:
        {
            SOSViewController *viewController = [[SOSViewController alloc] initWithNibName:@"SOSViewController" bundle:nil];
            [self.navigationController pushViewController:viewController animated:YES];
            SAFERELEASE(viewController)
            break;
        }
        default:
            break;
    }
}

#pragma mark- NavigationViewDelegate
-(void)navMenuAction:(int)index
{
    switch (index)
    {
        case 10000:
        {
            [[SpotManager sharedInstance] requestGetViewSpot:self];
            break;
        }
        case 10001:
        {
            CommonViewController *controller = [[CommonViewController  alloc]initWithNibName:@"CommonViewController" bundle:nil];
            controller.data = [[DataAccessManager sharedDataModel] getAllCommonNav];
            [self.navigationController pushViewController:controller animated:YES];
            SAFERELEASE(controller)
            break;
        }
        case 10002:
        {
            CGFloat xWidth = self.view.bounds.size.width;
            CGFloat yHeight = 320.0f;
            CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
            AroundNavPopView *popView = [AroundNavPopView instanceSOSPopView];
            popView.frame = CGRectMake(0, yOffset, xWidth, yHeight);
            popView.delegate = self;
            [popView show];
            break;
        }
        default:
            break;
    }
}

- (IBAction)menuAction:(id)sender
{
    [self bottomAnim:sender];
}
- (IBAction)narrowAction:(id)sender
{
    [self.map zoomOut:YES];
    [self setMapScale];
}
- (IBAction)fullAction:(id)sender
{
    [self.map centerAtPoint:[[[AGSPoint alloc] initWithX:118.849 y:32.059 spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326]] autorelease] animated:YES];
}
- (IBAction)zoomAction:(id)sender
{
    [self.map zoomIn:YES];
    [self setMapScale];
}
- (IBAction)locationAction:(id)sender
{
    switch (rotateType)
    {
        case LOCATION_NO://未开始定位
        {
            [locationPoint startLocation];
            rotateType = LOCATION_POINT_ROTATE;
            locationPoint.rotateType = rotateType;
            [self.locationBtn setImage:[UIImage imageNamed:@"location-f.png"] forState:UIControlStateNormal];
            break;
        }
        case LOCATION_POINT_ROTATE:
        {
            rotateType = LOCATION_MAP_ROTATE;
            locationPoint.rotateType = rotateType;
            [self.locationBtn setImage:[UIImage imageNamed:@"location-s.png"] forState:UIControlStateNormal];
            break;
        }
        case LOCATION_MAP_ROTATE:
        {
            rotateType = LOCATION_NO;
            locationPoint.rotateType = LOCATION_NO;
            [locationPoint stopLoctation];
            [self.locationBtn setImage:[UIImage imageNamed:@"location.png"] forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
    
}
- (IBAction)settingAction:(id)sender
{
    SetViewController *controller = [[SetViewController alloc]initWithNibName:@"SetViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    SAFERELEASE(controller)

}
- (IBAction)backAction:(id)sender
{
    self.clickMapType = CLICK_MAP_FINDSPOT;
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)updateLanguage:(id)sender
{

}



//anim
- (void)bottomAnim:(id)sender
{
    self.bottomBar.userInteractionEnabled = NO;
    self.menuBtn.userInteractionEnabled = NO;
    float animY = self.bottomBar.frame.origin.y ;
    float menAnimY = self.menuBtn.frame.origin.y ;
    if(self.bottomBar.tag == 0)
    {
       self.bottomBar.tag = 10;
       animY += self.bottomBar.frame.size.height;
       menAnimY += self.bottomBar.frame.size.height;
        
        [UIView animateWithDuration:0.3 animations:^
         {
             self.bottomBar.frame = CGRectMake(0, animY, 320, 44);
         } completion:^(BOOL finished)
         {
             [UIView animateWithDuration:0.2 animations:^
              {
                  self.menuBtn.frame = CGRectMake(self.menuBtn.frame.origin.x, menAnimY, self.menuBtn.frame.size.width, self.menuBtn.frame.size.height);
                  self.locationBtn.frame = CGRectMake(self.locationBtn.frame.origin.x, menAnimY, self.locationBtn.frame.size.width, self.locationBtn.frame.size.height);
                  self.zoomBtn.frame = CGRectMake(self.zoomBtn.frame.origin.x, menAnimY, self.zoomBtn.frame.size.width, self.zoomBtn.frame.size.height);
                  self.fullBtn.frame = CGRectMake(self.fullBtn.frame.origin.x, menAnimY, self.fullBtn.frame.size.width, self.fullBtn.frame.size.height);
                  self.narrowBtn.frame = CGRectMake(self.narrowBtn.frame.origin.x, menAnimY, self.narrowBtn.frame.size.width, self.narrowBtn.frame.size.height);
                  self.mapScalView.frame = CGRectMake(self.mapScalView.frame.origin.x, self.mapScalView.frame.origin.y + self.bottomBar.frame.size.height, self.mapScalView.frame.size.width, self.mapScalView.frame.size.height);
              } completion:^(BOOL finished)
              {
                  self.menuBtn.userInteractionEnabled = YES;
              }];
             
             self.bottomBar.userInteractionEnabled = YES;
             
         }];

    }
    else if(self.bottomBar.tag == 10)
    {
        self.bottomBar.tag = 0;
        animY -=self.bottomBar.frame.size.height;
        menAnimY -= self.bottomBar.frame.size.height;
        [UIView animateWithDuration:0.2 animations:^
         {
             self.menuBtn.frame = CGRectMake(self.menuBtn.frame.origin.x, menAnimY, self.menuBtn.frame.size.width, self.menuBtn.frame.size.height);
             self.locationBtn.frame = CGRectMake(self.locationBtn.frame.origin.x, menAnimY, self.locationBtn.frame.size.width, self.locationBtn.frame.size.height);
             self.zoomBtn.frame = CGRectMake(self.zoomBtn.frame.origin.x, menAnimY, self.zoomBtn.frame.size.width, self.zoomBtn.frame.size.height);
             self.fullBtn.frame = CGRectMake(self.fullBtn.frame.origin.x, menAnimY, self.fullBtn.frame.size.width, self.fullBtn.frame.size.height);
             self.narrowBtn.frame = CGRectMake(self.narrowBtn.frame.origin.x, menAnimY, self.narrowBtn.frame.size.width, self.narrowBtn.frame.size.height);
             self.mapScalView.frame = CGRectMake(self.mapScalView.frame.origin.x, self.mapScalView.frame.origin.y - self.bottomBar.frame.size.height, self.mapScalView.frame.size.width, self.mapScalView.frame.size.height);
         } completion:^(BOOL finished)
         {
             [UIView animateWithDuration:0.3 animations:^
              {
                  self.bottomBar.frame = CGRectMake(0, animY, 320, 44);
              } completion:^(BOOL finished)
              {
                  
                  self.bottomBar.userInteractionEnabled = YES;
                  self.menuBtn.userInteractionEnabled = YES;
              }];
             
         }];
    }
    
}

#pragma mark- imagePicker delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [self dismissModalViewControllerAnimated:YES];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark- aroundPopView delegate
-(void)aroundNavPopViewAction:(int)index withType:(int)type
{
    if(type == 0)       //查找周边
    {
        BaseViewController *controller = nil;
        NSArray *data = nil;
        switch (index)
        {
            case 0: //停车场
            {
                data = [[DataAccessManager sharedDataModel] getLocationPoi:POI_PARK,nil];
                controller = [[AroundDetailViewController alloc]initWithNibName:@"AroundDetailViewController" bundle:nil];
                ((AroundDetailViewController*)controller).index = index;
                ((AroundDetailViewController*)controller).data = data;

                break;
            }
            case 1: //售票处
            {
                data = [[DataAccessManager sharedDataModel] getLocationPoi:POI_SAIL,nil];
                controller = [[AroundDetailViewController alloc]initWithNibName:@"AroundDetailViewController" bundle:nil];
                ((AroundDetailViewController*)controller).index = index;
                ((AroundDetailViewController*)controller).data = data;
                break;
            }
            case 2: //医疗点 
            {
                data = [[DataAccessManager sharedDataModel] getLocationPoi:POI_TRAVEL_CENTER,nil];
                controller = [[AroundDetailViewController alloc]initWithNibName:@"AroundDetailViewController" bundle:nil];
                ((AroundDetailViewController*)controller).index = index;
                ((AroundDetailViewController*)controller).data = data;
                break;
            }
            case 3: // 洗手间
            {
                data = [[DataAccessManager sharedDataModel] getLocationPoi:POI_TOTLITE,nil];
                controller = [[AroundDetailViewController alloc]initWithNibName:@"AroundDetailViewController" bundle:nil];
                ((AroundDetailViewController*)controller).index = index;
                ((AroundDetailViewController*)controller).data = data;
                break;
            }
            case 4: //商店
            case 5: //餐饮
            {
                if(index == 4)
                {
                    data = [[DataAccessManager sharedDataModel] getLocationPoi:POI_SHOP,nil];
                }
                else
                {
                    data = [[DataAccessManager sharedDataModel] getLocationPoi:POI_REPAST,nil];
                }
                
                controller = [[AroundDetailTwoViewController alloc]initWithNibName:@"AroundDetailTwoViewController" bundle:nil];
                ((AroundDetailTwoViewController*)controller).data = data;
                break;
            }
            case 6: //观光车
            {
                data = [[DataAccessManager sharedDataModel] getLocationPoi:POI_SIGHT_SEE,nil];
                controller = [[AroundDetailViewController alloc]initWithNibName:@"AroundDetailViewController" bundle:nil];
                ((AroundDetailViewController*)controller).index = index;
                ((AroundDetailViewController*)controller).data = data;
                break;
            }
            case 7: //公交站
            {
                data = [[DataAccessManager sharedDataModel] getLocationPoi:POI_BUS,nil];
                controller = [[AroundDetailViewController alloc]initWithNibName:@"AroundDetailViewController" bundle:nil];
                ((AroundDetailViewController*)controller).index = index;
                ((AroundDetailViewController*)controller).data = data;
                break;
            }
            case 8: //电话亭
            {
                data = [[DataAccessManager sharedDataModel] getLocationPoi:POI_TEL_BOOTH,nil];
                controller = [[AroundDetailViewController alloc]initWithNibName:@"AroundDetailViewController" bundle:nil];
                ((AroundDetailViewController*)controller).index = index;
                ((AroundDetailViewController*)controller).data = data;
                break;
            }
            default:
                break;
        }
        
        [self.navigationController pushViewController:controller animated:YES];
        SAFERELEASE(controller)
        

    }
    else if(type == 1)// 最近引导
    {
        POI_TYPE poitype ;
        switch (index)
        {
            case 0: //停车场
            {
                poitype = POI_PARK;
                break;
            }
            case 1: //售票处
            {
                poitype = POI_SAIL;
                break;
            }
            case 2: //医疗点
            {
                poitype = POI_TRAVEL_CENTER;
                break;
            }
            case 3: // 洗手间
            {
                poitype = POI_TOTLITE;
                break;
            }
            case 4: //商店
            {
                poitype = POI_SHOP;
                break;
            }
            case 5: //餐饮
            {
                poitype = POI_REPAST;
                break;
            }
            case 6: //观光车
            {
                poitype = POI_SIGHT_SEE;
                break;
            }
            case 7: //公交站
            {
                poitype = POI_BUS;
                break;
            }
            case 8: //电话亭
            {
                poitype = POI_TEL_BOOTH;
                break;
            }
            default:
                poitype = POI_OTHE;
                break;
        }
        NSArray *data = [[DataAccessManager sharedDataModel] getLocationPoi:poitype,nil];
        
        if (data.count > 0)
        {
            //最近poi
            ZS_CommonNav_entity *commonEntity = (ZS_CommonNav_entity*)[data objectAtIndex:0];
            //ToDo 导航至最近poi
            BOOL isSimulation = NO;
            NAV_TYPE nav_type = NAV_TYPE_WALK;      //最近引导使用步行信息
            
            
            PoiPoint *poiPoint = [PoiPoint pointWithName:commonEntity.NavTitle withLongitude:commonEntity.NavLng.doubleValue withLatitude:commonEntity.NavLat.doubleValue withPoiID:commonEntity.NavIID.intValue];
            [[MapManager sharedInstanced] startNavByOne:poiPoint withType:nav_type simulation:isSimulation withBarriers:@""];

        }

    }
}

- (void)callBackToUI:(HttpBaseResponse *)response
{
    switch (response.cc_cmd_code)
    {
        case CC_GET_VIEW_SPOT:
        {
            if(response.error_code == E_HTTPSUCCEES)
            {
                SpotViewController *controller = [[SpotViewController alloc]initWithNibName:@"SpotViewController"bundle:nil];
                [self.navigationController pushViewController:controller animated:YES];
                SAFERELEASE(controller)
            }
            break;
        }
        default:
            break;
    }
}


#pragma mark- didUpdateScenic delegate
- (void)didUpdateCurrentSenic:(SCENIC_TYPE)scenic
{
    NSString *locationTitle = [Language stringWithName:HAVE_IN];
    switch (scenic)
    {
        case SCENIC_MXL:
        {
            [[MusicPlayManager sharedInstanced] playMusicWithType:MUSIC_TYPE_MXL];
            locationTitle = [NSString stringWithFormat:@"%@%@",locationTitle,[Language stringWithName:MXL_SPOT]];
            break;
        }
        case SCENIC_LGS:
        {
            [[MusicPlayManager sharedInstanced] playMusicWithType:MUSIC_TYPE_LGS];
            locationTitle = [NSString stringWithFormat:@"%@%@",locationTitle,[Language stringWithName:LGS_SPOT]];
            break;
        }
        case SCENIC_ZSL:
        {
            [[MusicPlayManager sharedInstanced] playMusicWithType:MUSIC_TYPE_ZSL];
            locationTitle = [NSString stringWithFormat:@"%@%@",locationTitle,[Language stringWithName:ZSL_SPOT]];
            break;
        }
        case SCENIC_IN:
        {
            [[MusicPlayManager sharedInstanced] playMusicWithType:MUSIC_TYPE_NAV];
            locationTitle = [NSString stringWithFormat:@"%@%@",locationTitle,[Language stringWithName:ZSFJQ_SPOT]];
            break;
        }
        case SCENIC_OUT:
        case SCENIC_UNKNOW:
        default:
            [[MusicPlayManager sharedInstanced] playMusicWithType:MUSIC_TYPE_NAV];
            locationTitle = [Language stringWithName:JQW_STR];
            break;
    }
    
    self.navTitle.text = locationTitle;
    
}
- (void)didUpdateHeading:(CLHeading *)newHeading
{
    self.mapCompass.transform = CGAffineTransformIdentity;
    CGAffineTransform transform = CGAffineTransformMakeRotation(-1 * M_PI*newHeading.magneticHeading/180.0);
    self.mapCompass.transform = transform;
    
}

#pragma amrk - locationPoint delegate
- (void)loctationPointHeading:(double)angle
{
    [textMarkDrawer rotateGraphicAngel:angle];
}
- (void)loctationPointScale
{
    [textMarkDrawer drawTextMark:MAP_DIDLOAD_SCALE];
}

#pragma mark - TextMarkDrawerDelegate
- (void)setWaitingMoeth:(int)moeth withObj:(id)obj
{
    if (!waitingMoeth)
    {
        waitingMoeth = [[NSMutableDictionary alloc] init];
    }
    [waitingMoeth setObject:obj forKey:INTTOOBJ(moeth)];
}
- (void)textMarkDrawerCompleted
{
    [self setMapScale];
    if (!waitingMoeth)
    {
        waitingMoeth = [[NSMutableDictionary alloc] init];
    }
    if ([waitingMoeth objectForKey:INTTOOBJ(4)])//执行未执行的函数
    {
        [self didShowCallout2Spot:[waitingMoeth objectForKey:INTTOOBJ(4)]];
        [waitingMoeth removeObjectForKey:INTTOOBJ(4)];
    }
}
#pragma mark - 处理返回地图的接口

//主动弹出 callout : 定位景点 poi等
- (void)didShowCallout2Spot:(NSString *)spotName
{
    if (ISNIL(spotName))
    {
        return;
    }
    NSArray *array = textMarkDrawer.allTextMarkCache;
    if (array.count == 0)
    {
        //添加等待函数
        [waitingMoeth setObject:spotName forKey:INTTOOBJ(4)];
        return;
    }
    for (AGSGraphic *graphic in array)
    {
        NSString *name = ReplaceNULL2Empty([graphic.allAttributes objectForKey:@"name"]);
        if ([spotName isEqualToString:name])
        {
            rotateType = LOCATION_NO;
            locationPoint.rotateType = LOCATION_NO;
            [locationPoint stopLoctation];
            [self.locationBtn setImage:[UIImage imageNamed:@"location.png"] forState:UIControlStateNormal];
            AGSPoint *asgpoint = [AGSPoint pointWithX:graphic.geometry.envelope.xmax y:graphic.geometry.envelope.ymax spatialReference:self.map.spatialReference];
            [self.map centerAtPoint:asgpoint animated:YES];
            self.map.callout.customView = [callOutDrawer infoView:name];
            [self.map.callout showCalloutAt:asgpoint pixelOffset:CGPointMake(0, 0) animated:YES];
            return;
        }
    }
}

- (void)didShowCallout2Spot:(NSString *)spotName withPoint:(AGSPoint *)point
{
    if (ISNIL(spotName) || ISNIL(point) || point.isEmpty)
    {
        return;
    }
    rotateType = LOCATION_NO;
    locationPoint.rotateType = LOCATION_NO;
    [locationPoint stopLoctation];
    [self.locationBtn setImage:[UIImage imageNamed:@"location.png"] forState:UIControlStateNormal];
    [self.map centerAtPoint:point animated:YES];
    self.map.callout.customView = [callOutDrawer infoView:spotName];
    [self.map.callout showCalloutAt:point pixelOffset:CGPointMake(0, 0) animated:YES];
}
- (void)didShowCallout2POI:(NSString *)poiName withPoint:(AGSPoint *)point
{
    if (ISNIL(poiName) || ISNIL(point) || point.isEmpty)
    {
        return;
    }
    rotateType = LOCATION_NO;
    locationPoint.rotateType = LOCATION_NO;
    [locationPoint stopLoctation];
    [self.locationBtn setImage:[UIImage imageNamed:@"location.png"] forState:UIControlStateNormal];
    [self.map centerAtPoint:point animated:YES];
    self.map.callout.customView = [callOutDrawer poiView:poiName];
    [self.map.callout showCalloutAt:point pixelOffset:CGPointMake(0, 0) animated:YES];
    
}

#pragma mark - 线路绘制
- (void)didNavLine:(id)line withEnvelope:(id)envelope withPoints:(NSArray *)points withType:(NAV_TYPE)type
{
//    if (self.map.loaded)
//    {
//       [self.map zoomToEnvelope:envelope animated:YES];
//       [self setMapScale];
//    }
    if (ISARRYCLASS(points))
    {
        PoiPoint *point = [points objectAtIndex:0];
        [self.map centerAtPoint:[AGSPoint pointWithX:point.longitude y:point.latitude spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326 WKT:nil]] animated:YES];
       
        [navigationDrawer drawLineWith:line withPoints:points withType:type];
    }
}

- (void)centerNavLine:(NSArray *)graphics
{
    if (!centerLineDrawer)
    {
        return;
    }
    [centerLineDrawer clearGraphic];
    [centerLineDrawer drawLineWith:graphics];
}
- (void)clearCenterNavLine
{
    if (!centerLineDrawer)
    {
        return;
    }
    [centerLineDrawer clearGraphic];
}

/**
 *
 * 恢复 地图页面
 */
- (void)reViewMapView
{
   
    [self hiddenMenu:NO];
    [self hiddenMapScal:NO];
    [self hiddenToolsBar:NO];
    [self hiddenCompass:NO];
    self.navTitle.hidden = NO;
    self.backLabel.hidden = NO;
    self.settingBtn.hidden = NO;
    self.backBtn.hidden = NO;
    self.topBarImgView.hidden = NO;

    for (UIView *subView in navgationViews)
    {
        if (subView)
        {
            subView.hidden = YES;
            if (subView.tag == 1100)
            {
                NavigationLabelView *view = (NavigationLabelView*)subView;
                view.nameLabel.text = @"";
            }
            if (subView.tag == 1101)
            {
                NavigationLabelView *view = (NavigationLabelView*)subView;
                view.nameLabel.text = @"";
            }
            if (subView.tag == 1102)
            {
                UIImageView *imgView = (UIImageView*)subView;
                [imgView setImage:[UIImage imageNamed:@""]];
            }
            if (subView.tag == 1103)
            {
                UILabel *disLabel = (UILabel*)subView;
                disLabel.text = @"";
            }
        }
    }
    
    //恢复 原有定位方式
    //1.如果之前没有定位
    if (rotateType == LOCATION_NO)
    {
        [locationPoint stopLoctation];
        locationPoint.rotateType = LOCATION_NO;
    }
    else
    {
        if (locationPoint.rotateType != rotateType)
        {
            [locationPoint startLocation];
            locationPoint.rotateType = rotateType;
        }
    }
    [locationPoint unVisableSimulationPoint];
}

- (void)viewNavMapView
{
    [self hiddenMenu:YES];
    [self hiddenMapScal:YES];
    [self hiddenToolsBar:YES];
    [self hiddenCompass:YES];
    self.navTitle.hidden = YES;
    self.backLabel.hidden = YES;
    self.settingBtn.hidden = YES;
    self.backBtn.hidden = YES;
    self.topBarImgView.hidden = YES;

    for (UIView *subView in navgationViews)
    {
        if (subView)
        {
            subView.hidden = NO;
            if (subView.tag == 1100)
            {
                NavigationLabelView *view = (NavigationLabelView*)subView;
                view.nameLabel.text = [Language stringWithName:ZSLPARK];
            }
            if (subView.tag == 1101)
            {
                NavigationLabelView *view = (NavigationLabelView*)subView;
                view.nameLabel.text = [NSString stringWithFormat:@"%@:%@%@",[Language stringWithName:JDQMU],@"0",[Language stringWithName:METER]];
            }
            if (subView.tag == 1102)
            {
                UIImageView *imgView = (UIImageView*)subView;
                [imgView setImage:[UIImage imageNamed:@"default_navi_action_0.png"]];
            }
            if (subView.tag == 1103)
            {
                UILabel *disLabel = (UILabel*)subView;
                disLabel.text = [NSString stringWithFormat:@"%d%@",0,[Language stringWithName:METER]];
            }
        }
    }
    [navigationView hideButtonsAnimated];
    if (centerLineDrawer)
    {
        [centerLineDrawer unRegisterMapManagerNotification];
    }
}

/**
 * 实地导航 1.判断是否开始定位，没有定位，打开定位
 *         2.判断个当前定位方式是否为 地图旋转方式 ，修改为地图旋转方式
 */
- (void)realNavigation
{
    if (centerLineDrawer)
    {
        [centerLineDrawer registerMapManagerNotification];
    }
    if (rotateType == LOCATION_NO)
    {
        [locationPoint startLocation];
    }
    if(locationPoint.rotateType != LOCATION_MAP_ROTATE)
    locationPoint.rotateType = LOCATION_MAP_ROTATE;
}

/**
 * 模拟导航 1.判断是否开始定位，要停止定位
 *         2.添加一个模拟导航点图层
 *         3.刷新模拟导航点位置，并且把地图中心点设置到模拟点
 */
- (void)simulation:(double)lon withLat:(double)lat
{
    if (centerLineDrawer)
    {
        [centerLineDrawer unRegisterMapManagerNotification];
    }
    if (rotateType != LOCATION_NO)
    {
        [locationPoint stopLoctation];
        locationPoint.rotateType = LOCATION_NO;
    }
    [locationPoint setSimulationPoint:lon withLat:lat];
}

/**
 *   导航底层与UI 交互
 *
 */
- (void)changeTarget:(NSString*)currentTarget;//当前目标的信息显示
{
    [navigationView changeTarget:currentTarget];
}

- (void)changeDis:(double)targetDis TurnDis:(double)turnDis
{
    [navigationView changeDis:targetDis TurnDis:turnDis];
}

- (void)changeDirections:(MAP_DIRECTION)orientation
{
    [navigationView changeDirections:orientation];
}


-(void)go:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    switch (btn.tag)
    {
        case 1000:
        {
            SOSViewController *viewController = [[SOSViewController alloc] initWithNibName:@"SOSViewController" bundle:nil];
            [self.navigationController pushViewController:viewController animated:YES];
            SAFERELEASE(viewController)
            break;
        }
        case 1001:
        {
            [[MapManager sharedInstanced] stopNav];
            break;
        }
        case 1002:
        {
            SetViewController *controller = [[SetViewController alloc]initWithNibName:@"SetViewController" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
            SAFERELEASE(controller)
            break;
        }
        default:
            break;
    }
}

- (void)didNavLineFailed:(NAV_TYPE)type
{
    NSString *str = @"";
    switch (type)
    {
        case NAV_TYPE_WALK:
        {
            str = [NSString stringWithFormat:@"%@%@%@",@"抱歉,未能生成",@"步行",@"线路"];
            break;
        }
        case NAV_TYPE_CAR:
        {
            str = [NSString stringWithFormat:@"%@%@%@",@"抱歉,未能生成",@"自驾",@"线路"];
            break;
        }
        case NAV_TYPE_TOUR_CAR:
        {
            str = [NSString stringWithFormat:@"%@%@%@",@"抱歉,未能生成",@"游览车",@"线路"];
            break;
        }
        default:
            break;
    }
    
    [[TTSPlayer shareInstance] play:str playMode:TTS_PLAY_JUMP_QUEUE];
}

#pragma mark - hidden View
- (void)hiddenCompass:(BOOL)hiiden
{
    self.mapCompass.hidden = hiiden;
}
- (void)hiddenMenu:(BOOL)hidden
{
    self.locationBtn.hidden = hidden;
    self.zoomBtn.hidden = hidden;
    self.fullBtn.hidden = hidden;
    self.narrowBtn.hidden = hidden;
    self.menuBtn.hidden = hidden;
}
- (void)hiddenMapScal:(BOOL)hidden
{
    self.mapScalView.hidden = hidden;
}
- (void)hiddenToolsBar:(BOOL)hidden
{
    self.bottomBar.hidden = hidden;
}

#pragma mark- NavigationViewDelegate
-(void)navigationView:(int)index
{
    switch (index)
    {
        case 0:
        {
            SOSViewController *viewController = [[SOSViewController alloc] initWithNibName:@"SOSViewController" bundle:nil];
            [self.navigationController pushViewController:viewController animated:YES];
            SAFERELEASE(viewController)
            break;
        }
        case 1:
        {
//            SetViewController *controller = [[SetViewController alloc]initWithNibName:@"SetViewController" bundle:nil];
//            [self.navigationController pushViewController:controller animated:YES];
//            SAFERELEASE(controller)
            break;
        }
        case 2:
        {
            break;
        }
        case 3:
        {
            
            break;
        }
        default:
            break;
    }
}

#pragma mark- NavigationPopMoreViewDelegate
-(void)morePopAction:(int)index
{
    switch (index)
    {
        case 0:
        {
            [[SpotManager sharedInstance] requestGetViewSpot:self];
            break;
        }
        case 1:
        {
            CGFloat xWidth = self.view.bounds.size.width;
            CGFloat yHeight = 320.0f;
            CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
            AroundNavPopView *popView = [AroundNavPopView instanceSOSPopView];
            popView.frame = CGRectMake(0, yOffset, xWidth, yHeight);
            popView.delegate = self;
            [popView show];
            break;
        }
        case 2:
        {
            CommonViewController *controller = [[CommonViewController  alloc]initWithNibName:@"CommonViewController" bundle:nil];
            controller.data = [[DataAccessManager sharedDataModel] getAllCommonNav];
            [self.navigationController pushViewController:controller animated:YES];
            SAFERELEASE(controller)
            break;
        }
        case 3:
        {
            TeamServiceViewController *viewController = [[TeamServiceViewController alloc] initWithNibName:@"TeamServiceViewController" bundle:nil];
            [self.navigationController pushViewController:viewController animated:YES];
            SAFERELEASE(viewController)
            break;
        }
        case 4:
        {
            
            break;
        }
        case 5:
        {
            SetViewController *controller = [[SetViewController alloc]initWithNibName:@"SetViewController" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
            SAFERELEASE(controller)
            break;
        }
        default:
            break;
    }
}
#pragma mark 集合队员
- (void)gatherTeamAtPoint:(AGSPoint *)location
{
    _clickMapType = CLICK_MAP_FINDSPOT;
    
    //TODO 发群消息
    [[TeamManager sharedInstanced] teamRequestSendGroupMessage:@""];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 内存告警
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[MapManager sharedInstanced] stopNav];
    for (UIView *subView in navgationViews)
    {
        [subView removeFromSuperview];
    }
    [navgationViews removeAllObjects];
    SAFERELEASE(navgationViews)
    SAFERELEASE(navigationView)
    SAFERELEASE(centerLineDrawer)
    [[MapManager sharedInstanced] stopUpdateHeading];
    [[MapManager sharedInstanced] unRegisterMapManagerNotification:self];
    [locationPoint stopLoctation];
    SAFERELEASE(baseScenicSpeak)
    SAFERELEASE(navigationDrawer)
    SAFERELEASE(locationPoint)
    SAFERELEASE(textMarkDrawer)
    SAFERELEASE(waitingMoeth)
    [_settingBtn release];
    [_navTitle release];
    [_map release];
    [[MusicPlayManager sharedInstanced] stopPlay];
    [_menuBtn release];
    [_backLabel release];
    [_bottomBar release];
    [_locationBtn release];
    [_zoomBtn release];
    [_fullBtn release];
    [_narrowBtn release];
    [_mapScalView release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CallOutAction" object:nil];
    [_mapCompass release];
    [_backBtn release];
    [_topBarImgView release];
    [super dealloc];
}
- (void)viewDidUnload
{
    [self setSettingBtn:nil];
    [self setNavTitle:nil];
    [self setMap:nil];
    [self setBottomBar:nil];
    [self setMenuBtn:nil];
    [self setBackLabel:nil];
    [self setBottomBar:nil];
    [self setLocationBtn:nil];
    [self setZoomBtn:nil];
    [self setFullBtn:nil];
    [self setNarrowBtn:nil];
    [self setMapScalView:nil];
    [self setMapCompass:nil];
    [self setBackBtn:nil];
    [self setTopBarImgView:nil];
    [super viewDidUnload];
}
@end
