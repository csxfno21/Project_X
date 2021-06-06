//
//  RevolvingLabel.m
//  Tourism
//
//  Created by csxfno21 on 13-4-29.
//  Copyright (c) 2013年 szmap. All rights reserved.
//

#import "RevolvingLabel.h"
#define ANIM_WRAIT_TIME          2
#define VELOCITY                 25.0f   // px每毫秒

@interface RevolvingLabel(Private)
- (void)startRevolving;
@end
@implementation RevolvingLabel
@synthesize oldFrame = _oldFrame;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.textColor = [UIColor blackColor];
        self.textAlignment = UITextAlignmentCenter;
        self.font = [UIFont boldSystemFontOfSize:18];
    }
    return self;
}

- (void)setOldFrame:(CGRect)oldFrame
{
    _oldFrame = oldFrame;
}

- (void)startAnim
{
    animing = YES;
    [NSTimer scheduledTimerWithTimeInterval:ANIM_WRAIT_TIME target:self selector:@selector(startRevolving) userInfo:nil repeats:NO];
}
- (void)stopAnim
{
    animing = NO;
    self.frame = _oldFrame;
}
- (void)startRevolving
{
    CGSize fontSize =[self.text sizeWithFont:self.font
                                    forWidth:10000
                               lineBreakMode:UILineBreakModeTailTruncation];
    float width = fontSize.width > 320.0f ? fontSize.width : 320;
    [UIView animateWithDuration:width/VELOCITY delay:0 options:UIViewAnimationOptionCurveEaseOut
                    animations:^
                    {
                        self.frame = CGRectMake(_oldFrame.origin.x - _oldFrame.size.width,_oldFrame.origin.y,_oldFrame.size.width, _oldFrame.size.height);
                    }
                     completion:^(BOOL finished)
                    {
                        if (finished)
                        {
                            
                            self.frame = CGRectMake(320,_oldFrame.origin.y,_oldFrame.size.width, _oldFrame.size.height);
                            [UIView animateWithDuration:320.0f/VELOCITY  animations:^
                            {
                                self.frame = _oldFrame;
                                
                            } completion:^(BOOL finished)
                            {
                                
                                if (animing)
                                {
                                    [NSTimer scheduledTimerWithTimeInterval:ANIM_WRAIT_TIME target:self selector:@selector(startRevolving) userInfo:nil repeats:NO];
                                }
                            }];

                        }
                    }
     ];
}
- (void)animationFinish:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    
}
- (void)dealloc
{
    [super dealloc];
}
@end
