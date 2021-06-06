//
//  RouteNavPopView.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-5.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "RouteNavPopView.h"
#define TAG_ROUTE_TITLE     1000
@implementation RouteNavPopView
@synthesize delegate;
+(RouteNavPopView *)instanceRouteNavPopView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"RouteNavPopView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius = 10.0f;
        self.clipsToBounds = TRUE;
        overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        overlayView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
        [overlayView addTarget:self
                         action:@selector(dismiss)
               forControlEvents:UIControlEventTouchUpInside];
        self.goLabel.text = [Language stringWithName:GO];
        self.locationLabel1.text = [Language stringWithName:LOCATION];
        self.locationLabel2.text = [Language stringWithName:LOCATION];
        self.locationLabel3.text = [Language stringWithName:LOCATION];
        
        self.parkingLabel.text = [Language stringWithName:SPOT_PARKING];
        self.parkingLabel2.text = [Language stringWithName:SIGHT_SEEING_PARKING];
        
        self.entryLabel1.text = [Language stringWithName:SPOT_ENTRY];
        self.entryLabel2.text = [Language stringWithName:SPOT_ENTRY];
        self.entryLabel3.text = [Language stringWithName:SPOT_ENTRY];
        
        self.realTravelBtn.titleLabel.text = REAL_TRAVEL;
        self.simulateBtn.titleLabel.text = SIMULATE_TRAVEL;
        self.cancleBtn.titleLabel.text = CANCEL;
        
        [self.choseBtn1 addTarget:self action:@selector(firstSelected) forControlEvents:UIControlEventTouchUpInside];
        [self.choseBtn2 addTarget:self action:@selector(secondSelected) forControlEvents:UIControlEventTouchUpInside];
        [self.choseBtn3 addTarget:self action:@selector(thirdSelected) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (IBAction)selectedActionF:(id)sender
{
    [self.choseBtn1 setImage:[UIImage imageNamed:@"Route-nav-pop-item-selected.png"] forState:UIControlStateNormal];
    [self.choseBtn2 setImage:[UIImage imageNamed:@"Route-nav-pop-item-nselected.png"] forState:UIControlStateNormal];
    [self.choseBtn3 setImage:[UIImage imageNamed:@"Route-nav-pop-item-nselected.png"] forState:UIControlStateNormal];
    selectedIndex = 0;
}
- (IBAction)selectedActionS:(id)sender
{
    [self.choseBtn2 setImage:[UIImage imageNamed:@"Route-nav-pop-item-selected.png"] forState:UIControlStateNormal];
    [self.choseBtn1 setImage:[UIImage imageNamed:@"Route-nav-pop-item-nselected.png"] forState:UIControlStateNormal];
    [self.choseBtn3 setImage:[UIImage imageNamed:@"Route-nav-pop-item-nselected.png"] forState:UIControlStateNormal];
    selectedIndex = 1;
}
- (IBAction)selectedActionT:(id)sender
{
    [self.choseBtn3 setImage:[UIImage imageNamed:@"Route-nav-pop-item-selected.png"] forState:UIControlStateNormal];
    [self.choseBtn2 setImage:[UIImage imageNamed:@"Route-nav-pop-item-nselected.png"] forState:UIControlStateNormal];
    [self.choseBtn1 setImage:[UIImage imageNamed:@"Route-nav-pop-item-nselected.png"] forState:UIControlStateNormal];
    selectedIndex = 2;
}

- (void)selectSecond
{
    [self.choseBtn2 setImage:[UIImage imageNamed:@"Route-nav-pop-item-selected.png"] forState:UIControlStateNormal];
    [self.choseBtn1 setImage:[UIImage imageNamed:@"Route-nav-pop-item-nselected.png"] forState:UIControlStateNormal];
    [self.choseBtn3 setImage:[UIImage imageNamed:@"Route-nav-pop-item-nselected.png"] forState:UIControlStateNormal];
    selectedIndex = 1;
}

- (IBAction)sdNavAction:(id)sender
{
    if(delegate && [delegate respondsToSelector:@selector(routeNavAction:withType:)])
    {
        [delegate routeNavAction:selectedIndex withType:0];
    }
    [self dismiss];
}

- (IBAction)mnNavAction:(id)sender
{
    if(delegate && [delegate respondsToSelector:@selector(routeNavAction:withType:)])
    {
        [delegate routeNavAction:selectedIndex withType:1];
    }
    [self dismiss];
}


- (IBAction)cancelAction:(id)sender
{
    [self dismiss];
}

- (void)setTitleText:(NSString*)title
{
    if(!title || title.length == 0)return;
    UIView *titleViewF = [self viewWithTag:TAG_ROUTE_TITLE + 1];
    UIView *titleViewT = [self viewWithTag:TAG_ROUTE_TITLE + 2];
    if(titleViewF)
    {
        [titleViewF removeFromSuperview];
    }
    if(titleViewT)
    {
        [titleViewT removeFromSuperview];
    }
    
    CGSize titleSize = [title sizeWithFont:self.goLabel.font constrainedToSize:CGSizeMake(150, 20) lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.goLabel.frame.origin.x + self.goLabel.frame.size.width + 3, self.goLabel.frame.origin.y, titleSize.width, 20)];
    titleLabel.tag = TAG_ROUTE_TITLE + 1;
    titleLabel.font = [UIFont systemFontOfSize:15.0f];
    titleLabel.textColor = [UIColor orangeColor];
    titleLabel.text = title;
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel sendSubviewToBack:self.goLabel];
    
    //跑马灯
    CGRect frame = titleLabel.frame;
    frame.origin.x = titleLabel.frame.origin.x + titleLabel.frame.size.width;
    titleLabel.frame = frame;
    [UIView beginAnimations:@"beginAnimations" context:NULL];
    [UIView setAnimationDuration:5.0f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationRepeatCount:HUGE_VALF];
    frame = titleLabel.frame;
    frame.origin.x = self.goLabel.frame.origin.x + self.goLabel.frame.size.width - frame.size.width;
    titleLabel.frame = frame;
    [UIView commitAnimations];
    
    [self addSubview:titleLabel];
    
    [self sendSubviewToBack:titleLabel];
    
    CGFloat parentWidth = self.frame.size.width;
    CGSize outSize = [[Language stringWithName:OUT_OPTION] sizeWithFont:self.goLabel.font constrainedToSize:CGSizeMake(110, 20) lineBreakMode:NSLineBreakByWordWrapping];
//    NSLog(@"-----%f",outSize.width);
    if(titleLabel.frame.origin.x + titleLabel.frame.size.width + 3 + outSize.width + 20 > parentWidth)
    {
        UILabel *outLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 55, outSize.width, 20)];
        outLabel.textColor = [UIColor blackColor];
        outLabel.tag = TAG_ROUTE_TITLE + 2;
        outLabel.font = [UIFont systemFontOfSize:15.0f];
        outLabel.text = [Language stringWithName:OUT_OPTION];
        [self addSubview:outLabel];
        SAFERELEASE(outLabel)
    }
    else
    {
        UILabel *outLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.goLabel.frame.origin.x + self.goLabel.frame.size.width + 3 + titleLabel.frame.size.width + 3, self.goLabel.frame.origin.y,  320 - titleLabel.frame.origin.x - titleLabel.frame.size.width, 20)];//outSize.width
        outLabel.textColor = [UIColor blackColor];
        outLabel.tag = TAG_ROUTE_TITLE + 2;
        outLabel.font = [UIFont systemFontOfSize:15.0f];
        outLabel.text = [Language stringWithName:OUT_OPTION];
        [self addSubview:outLabel];
        SAFERELEASE(outLabel)
    }
    SAFERELEASE(titleLabel);
}
- (void)show
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:overlayView];
    [keywindow addSubview:self];
    self.center = CGPointMake(keywindow.bounds.size.width/2.0f,
                              keywindow.bounds.size.height/2.0f);
    self.alpha = 0.0f;
    [UIView animateWithDuration:0.2 animations:^
     {
         self.alpha = 1.0f;
     } completion:^(BOOL finished)
     {
         
     }];
    
}
- (void)dismiss
{
    [UIView animateWithDuration:0.2 animations:^
     {
         self.alpha = 0.0f;
     } completion:^(BOOL finished)
     {
         [overlayView removeFromSuperview];
         [self removeFromSuperview];
         
     }];
}

- (void)dealloc
{
    delegate = nil;
    [overlayView release];
    [_choseBtn1 release];
    [_choseBtn2 release];
    [_choseBtn3 release];
    [_goLabel release];
    [_locationLabel1 release];
    [_parkingLabel release];
    [_entryLabel1 release];
    [_locationLabel2 release];
    [_parkingLabel2 release];
    [_entryLabel2 release];
    [_locationLabel3 release];
    [_entryLabel3 release];
    [_realTravelBtn release];
    [_simulateBtn release];
    [_cancleBtn release];
    
    [_l1 release];
    [_l2 release];
    [super dealloc];
}
@end
