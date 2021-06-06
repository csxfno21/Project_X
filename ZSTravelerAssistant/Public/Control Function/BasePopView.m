//
//  BasePopView.m
//  Tourism
//
//  Created by logic on 13-4-8.
//  Copyright (c) 2013年 logic. All rights reserved.
//

#import "BasePopView.h"

@implementation BasePopView
@synthesize centBgView = _centBgView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed:82.0/255.0 green:82.0/255.0 blue:82.0/255.0 alpha:0.6];
        _centBgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 150, 300, 145)];
        UIImage *image = [UIImage imageNamed:@"tool_box_bkg_wood.png"];
        [_centBgView setImage:[image stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
      
        [self addSubview:_centBgView];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPopView:)];
        gesture.numberOfTapsRequired = 1;
        gesture.delegate = self;
        [self addGestureRecognizer:gesture];
        [gesture release];
    }
    return self;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView *touchView = touch.view;
    if([touchView isKindOfClass:[UIButton class]] || touchView.tag == GESTURE || [touchView.superview isKindOfClass:[UIDatePicker class]])
    {
        return NO;
    }
    return YES;
}
- (void)show:(UIView*)contentView
{
    [contentView addSubview:self];
}
- (void)dismissPopView:(BOOL)anim
{
    if(anim)
    {
        [UIView animateWithDuration:0.3 animations:^
         {
             self.alpha = 0.0f;
         } completion:^(BOOL finished)
         {
             [self removeFromSuperview];
             
         }];
    }
    else
    {
        [self removeFromSuperview];
    }

}
- (void)setCentBgViewFrame:(CGRect)frame
{
    _centBgView.frame = frame;
}
- (void)dealloc
{
    SAFERELEASE(_centBgView)
    [super dealloc];
}
@end
