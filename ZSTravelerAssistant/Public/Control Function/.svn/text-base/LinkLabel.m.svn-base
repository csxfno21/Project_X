//
//  LinkLabel.m
//  Showcase
//
//  Created by  on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LinkLabel.h"

#define FONTSIZE 18
#define COLOR(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

@implementation LinkLabel
@synthesize delegate;

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setLineBreakMode:UILineBreakModeWordWrap|UILineBreakModeTailTruncation];
//        [self setFont:[UIFont fontWithName:@"Verdana-Italic" size:FONTSIZE]];
//        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        [self setNumberOfLines:0];
        [self setHighlightedTextColor:[UIColor blackColor]];
    }
    return self;
}

- (void)setText:(NSString *)text{
    [super setText:text];
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGSize fontSize =[self.text sizeWithFont:self.font 
                                               forWidth:self.bounds.size.width
                                          lineBreakMode:UILineBreakModeTailTruncation];

    if (self.highlighted) {
        CGContextSetStrokeColorWithColor(ctx, self.highlightedTextColor.CGColor);
    }
    else
    {
        CGContextSetStrokeColorWithColor(ctx, self.textColor.CGColor);
    }
    
    CGContextSetLineWidth(ctx, 1.0f);
    if (self.textAlignment == UITextAlignmentRight) {
        CGContextMoveToPoint(ctx, self.bounds.origin.x + self.bounds.size.width - fontSize.width, self.bounds.size.height - 10);
        
        CGContextAddLineToPoint(ctx, self.bounds.origin.x + self.bounds.size.width, self.bounds.size.height - 10);
    }
    else
    {
        CGContextMoveToPoint(ctx, 0, self.bounds.size.height - 3);
        
        CGContextAddLineToPoint(ctx, fontSize.width, self.bounds.size.height - 3);
    }
    
    CGContextStrokePath(ctx);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.highlighted = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.highlighted = NO;
    
    if(delegate && [delegate respondsToSelector:@selector(linkLabelTouche:touchesWtihTag:)])
    {
        [delegate linkLabelTouche:self touchesWtihTag:self.tag];
    }
}

-(void)dealloc
{
    [super dealloc];
}

@end
