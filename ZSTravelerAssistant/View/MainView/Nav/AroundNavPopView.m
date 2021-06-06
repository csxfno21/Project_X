//
//  CommonNavPopView.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-12.
//  Copyright (c) 2013年 company. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "AroundNavPopView.h"

@implementation AroundNavPopView
@synthesize delegate;

+(AroundNavPopView *)instanceSOSPopView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"AroundNavPopView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

-(id)initWithCoder:(NSCoder *)aDecoder
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
        cell1 = [[AroundCell alloc]initWithFrame:CGRectMake(10 - 8, 70, 90, 75)];
        cell1.imageView.image = [UIImage imageNamed:@"Around1.png"];
        cell1.nameLabel.text = [Language stringWithName:PARK];
        [cell1 setBackgroundImage:[UIImage imageNamed:@"AroundHightlight.png"] forState:UIControlStateHighlighted];
        cell1.tag = 0;
        [cell1 addTarget:self action:@selector(go:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cell1];
        
        cell2 = [[AroundCell alloc]initWithFrame:CGRectMake(115 - 8, 70, 90, 75)];
        cell2.imageView.image = [UIImage imageNamed:@"Around2.png"];
        cell2.nameLabel.text = [Language stringWithName:TICKET_OFFICE];
        [cell2 setBackgroundImage:[UIImage imageNamed:@"AroundHightlight.png"] forState:UIControlStateHighlighted];
        cell2.tag = 1;
        [cell2 addTarget:self action:@selector(go:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cell2];
        
        cell3 = [[AroundCell alloc]initWithFrame:CGRectMake(220 - 8, 70, 90, 75)];
        cell3.imageView.image = [UIImage imageNamed:@"Around3.png"];
        cell3.nameLabel.text = [Language stringWithName:MEDICAL_CENTER];
        [cell3 setBackgroundImage:[UIImage imageNamed:@"AroundHightlight.png"] forState:UIControlStateHighlighted];
        cell3.tag = 2;
        [cell3 addTarget:self action:@selector(go:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cell3];
        
        cell4 = [[AroundCell alloc]initWithFrame:CGRectMake(10 - 8, 155, 90, 75)];
        cell4.imageView.image = [UIImage imageNamed:@"Around4.png"];
        cell4.nameLabel.text = [Language stringWithName:TOILET];
        [cell4 setBackgroundImage:[UIImage imageNamed:@"AroundHightlight.png"] forState:UIControlStateHighlighted];
        cell4.tag = 3;
        [cell4 addTarget:self action:@selector(go:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cell4];

        cell5 = [[AroundCell alloc]initWithFrame:CGRectMake(115 - 8, 155, 90, 75)];
        cell5.imageView.image = [UIImage imageNamed:@"Around5.png"];
        cell5.nameLabel.text = [Language stringWithName:SHOP];
        [cell5 setBackgroundImage:[UIImage imageNamed:@"AroundHightlight.png"] forState:UIControlStateHighlighted];
        cell5.tag = 4;
        [cell5 addTarget:self action:@selector(go:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cell5];
        
        cell6 = [[AroundCell alloc]initWithFrame:CGRectMake(220 - 8, 155, 90, 75)];
        cell6.imageView.image = [UIImage imageNamed:@"Around6.png"];
        cell6.nameLabel.text = [Language stringWithName:CATERING];
        [cell6 setBackgroundImage:[UIImage imageNamed:@"AroundHightlight.png"] forState:UIControlStateHighlighted];
        cell6.tag = 5;
        [cell6 addTarget:self action:@selector(go:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cell6];

        cell7 = [[AroundCell alloc]initWithFrame:CGRectMake(10 - 8, 240, 90, 75)];
        cell7.imageView.image = [UIImage imageNamed:@"Around7.png"];
        cell7.nameLabel.text = [Language stringWithName:TOUR_BUS];
        [cell7 setBackgroundImage:[UIImage imageNamed:@"AroundHightlight.png"] forState:UIControlStateHighlighted];
        cell7.tag = 6;
        [cell7 addTarget:self action:@selector(go:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cell7];
        
        cell8 = [[AroundCell alloc]initWithFrame:CGRectMake(115 - 8, 240, 90, 75)];
        cell8.imageView.image = [UIImage imageNamed:@"Around8.png"];
        cell8.nameLabel.text = [Language stringWithName:BUS_STATION];
        [cell8 setBackgroundImage:[UIImage imageNamed:@"AroundHightlight.png"] forState:UIControlStateHighlighted];
        cell8.tag = 7;
        [cell8 addTarget:self action:@selector(go:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cell8];

        cell9 = [[AroundCell alloc]initWithFrame:CGRectMake(220 - 8, 240, 90, 75)];
        cell9.imageView.image = [UIImage imageNamed:@"Around9.png"];
        cell9.nameLabel.text = [Language stringWithName:CALLBOX];
        [cell9 setBackgroundImage:[UIImage imageNamed:@"AroundHightlight.png"] forState:UIControlStateHighlighted];
        cell9.tag = 8;
        [cell9 addTarget:self action:@selector(go:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cell9];

        
        [self.searchAroundBtn addTarget:self action:@selector(firstSelected) forControlEvents:UIControlEventTouchUpInside];
        [self.closestNavBtn addTarget:self action:@selector(secondSelected) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)go:(id)sender
{
    AroundCell *cell = (AroundCell*)sender;
    [self dismiss];
    if(delegate && [delegate respondsToSelector:@selector(aroundNavPopViewAction: withType:)])
    {
        [delegate aroundNavPopViewAction:cell.tag withType:selectedIndex];
    }
    
}

- (IBAction)selectedActionF:(id)sender
{
    [self.searchAroundBtn setImage:[UIImage imageNamed:@"Route-nav-pop-item-selected.png"] forState:UIControlStateNormal];
    [self.closestNavBtn setImage:[UIImage imageNamed:@"Route-nav-pop-item-nselected.png"] forState:UIControlStateNormal];
    selectedIndex = 0;

}

- (IBAction)selectedActionS:(id)sender
{
    [self.closestNavBtn setImage:[UIImage imageNamed:@"Route-nav-pop-item-selected.png"] forState:UIControlStateNormal];
    [self.searchAroundBtn setImage:[UIImage imageNamed:@"Route-nav-pop-item-nselected.png"] forState:UIControlStateNormal];
    selectedIndex = 1;
}

- (void)show
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:overlayView];
    [keywindow addSubview:self];
    
    self.center = CGPointMake(keywindow.bounds.size.width/2.0f,
                              keywindow.bounds.size.height/2.0f);
    
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

-(void)dealloc
{
    SAFERELEASE(overlayView)
    SAFERELEASE(cell1)
    SAFERELEASE(cell2)
    SAFERELEASE(cell3)
    SAFERELEASE(cell4)
    SAFERELEASE(cell5)
    SAFERELEASE(cell6)
    SAFERELEASE(cell7)
    SAFERELEASE(cell8)
    SAFERELEASE(cell9)
    [_searchAroundBtn release];
    [_closestNavBtn release];
    [_searchAroundLabel release];
    [_closestNavLabel release];
    [super dealloc];
}

@end