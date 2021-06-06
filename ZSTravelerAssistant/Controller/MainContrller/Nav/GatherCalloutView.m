//
//  gatherCalloutView.m
//  MapViewDemo
//
//  Created by 梁谢超 on 13-11-14.
//
//

#import "GatherCalloutView.h"
#define CALL_OUT_ICON_PIX       20
#define CALL_OUT_ICON_PADDINHG  5


@implementation GatherCalloutView
@synthesize location,delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, CALL_OUT_ICON_PIX)];
        _title.textAlignment = UITextAlignmentCenter;
        _title.textColor = [UIColor whiteColor];
        _title.backgroundColor = [UIColor clearColor];
        _title.font = [UIFont boldSystemFontOfSize:12];
        _title.text = @"这您要集合的位置";
        [self addSubview:_title];

        _btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        CGRect btn2Frame = CGRectMake(110, 0, 30, CALL_OUT_ICON_PIX);
        _btn.frame =btn2Frame;
        [_btn setTitle:@"OK" forState:UIControlStateNormal];
        [_btn setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
        _btn.backgroundColor = [UIColor clearColor];
        [_btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];


        [self addSubview:_btn];
    }
    return self;
}

- (void)btnAction:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(gatherTeamAtPoint:)])
    {
        [delegate gatherTeamAtPoint:self.location];
    }
}

-(void)dealloc
{
    SAFERELEASE(_title)
    SAFERELEASE(location)
    self.delegate = nil;
    [super dealloc];
}
@end
