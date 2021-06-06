//
//  UIViewController+ProgressSheet.m
//  Larky
//
//  Created by Sandeep GS on 25/04/12.
//  Copyright 2012 Sourcebits Technologies Pvt. Ltd. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIViewController+ProgressSheet.h"
const NSInteger kNonBlockCenterViewTag = 10003;

@implementation UIViewController (ProgressSheet)

//- (void)startFullScreenBlockBysyViewWithTitle:(NSString*)inTitle
//{
//    
//    id bgView = [self.view viewWithTag:kNonBlockCenterViewTag];
//	if (bgView)	return;
//    UIView *fullScreenView = [self.view viewWithTag:kNonBlockCenterViewTag];
//    if (fullScreenView == nil)
//    {
//        CGSize blockerSize = CGSizeMake(150, 65);
//        
//        //NSLog (@"self.view.frame: %f %f", self.view.frame.size.width, self.view.frame.size.height);
//		AppDelegate *app = [UIApplication sharedApplication].delegate;
//        float screenWidth = app.window.frame.size.width;
//        float screenHeight = app.window.frame.size.height;
//        
//		UIView *NonBlockCenterView = [[UIView alloc] initWithFrame:CGRectMake( (screenWidth-blockerSize.width)/2, (screenHeight-blockerSize.height)/2, blockerSize.width, blockerSize.height)];
//		
//		NonBlockCenterView.backgroundColor = [UIColor colorWithRed:12.0/255 green:12.0/255 blue:12.0/255 alpha:0.8];
//		NonBlockCenterView.layer.cornerRadius = 10.0;
//		
//		float activityIndicatorWidth = 20.0;
//        
//		UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//		activityIndicator.frame = CGRectMake(blockerSize.width/2-activityIndicatorWidth/2, 6, activityIndicatorWidth, activityIndicatorWidth);
//		[activityIndicator startAnimating];
//		[NonBlockCenterView addSubview:activityIndicator];
//        
//		UILabel *label = [[UILabel alloc] init];
//		label.font = [UIFont systemFontOfSize: 14];
//		label.backgroundColor = [UIColor clearColor];
//		label.textColor = [UIColor whiteColor];
//		label.textAlignment = UITextAlignmentCenter;
//		label.lineBreakMode = UILineBreakModeTailTruncation;
//		label.numberOfLines = 2;
//		label.text = inTitle;
//		[label sizeToFit];
//        
//		CGSize titleSize = [PublicUtils getTextSize:inTitle withFont:[UIFont systemFontOfSize: 14] andConstrainedToSize:CGSizeMake(blockerSize.width-20, blockerSize.height)];
//		label.frame = CGRectMake(blockerSize.width/2 - titleSize.width/2, (blockerSize.height/2 - titleSize.height/2) + 8, titleSize.width, titleSize.height + 5);
//		
//		[NonBlockCenterView addSubview:label];
//		
//        fullScreenView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, app.window.frame.size.height)];
//        fullScreenView.tag = kNonBlockCenterViewTag;
//		[fullScreenView addSubview:NonBlockCenterView];
//        [app.rootViewController.view addSubview:fullScreenView];
//        
//    }
//    
//}
- (void)startCenterAndNonBlockBusyViewWithTitle:(NSString *)inTitle needUserInteraction:(BOOL)isEnabled {
	
	id bgView = [self.view viewWithTag:kNonBlockCenterViewTag]; 
	if (bgView)	return;
	
	UIView *NonBlockCenterView = [self.view viewWithTag:kNonBlockCenterViewTag];
	if (NonBlockCenterView == nil) //if an activity indicator is already not in the view then create one and place it
	{
		CGSize blockerSize = CGSizeMake(150, 65);
        
        //NSLog (@"self.view.frame: %f %f", self.view.frame.size.width, self.view.frame.size.height);
		
        float screenWidth = self.view.frame.size.width;
        float screenHeight = self.view.frame.size.height;
        
		NonBlockCenterView = [[UIView alloc] initWithFrame:CGRectMake( (screenWidth-blockerSize.width)/2, (screenHeight-blockerSize.height)/2, blockerSize.width, blockerSize.height)];
		
		NonBlockCenterView.backgroundColor = [UIColor colorWithRed:12.0/255 green:12.0/255 blue:12.0/255 alpha:0.8];
		NonBlockCenterView.layer.cornerRadius = 10.0;
		NonBlockCenterView.tag = kNonBlockCenterViewTag;		  
		
		float activityIndicatorWidth = 20.0;
                
		UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		activityIndicator.frame = CGRectMake(blockerSize.width/2-activityIndicatorWidth/2, 6, activityIndicatorWidth, activityIndicatorWidth);
		[activityIndicator startAnimating];
		[NonBlockCenterView addSubview:activityIndicator];
        
		UILabel *label = [[UILabel alloc] init];
		label.font = [UIFont systemFontOfSize: 14];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor whiteColor];
		label.textAlignment = UITextAlignmentCenter;
		label.lineBreakMode = UILineBreakModeTailTruncation;
		label.numberOfLines = 2;
		label.text = inTitle;
		[label sizeToFit];

		CGSize titleSize = [PublicUtils getTextSize:inTitle withFont:[UIFont systemFontOfSize: 14] andConstrainedToSize:CGSizeMake(blockerSize.width-20, blockerSize.height)];
		label.frame = CGRectMake(blockerSize.width/2 - titleSize.width/2, (blockerSize.height/2 - titleSize.height/2) + 8, titleSize.width, titleSize.height + 5);
		
		[NonBlockCenterView addSubview:label];
		
		[self.view setUserInteractionEnabled:isEnabled];
        
		[self.view addSubview:NonBlockCenterView];
	}
}

- (void)startCenterAndNonBlockBusyViewWithTitle:(NSString *)inTitle needUserInteraction:(BOOL)isEnabled viewSize:(CGSize) size 
{
	
	id bgView = [self.view viewWithTag:kNonBlockCenterViewTag]; 
	if (bgView)	return;
	
	UIView *NonBlockCenterView = [self.view viewWithTag:kNonBlockCenterViewTag];
	if (NonBlockCenterView == nil) //if an activity indicator is already not in the view then create one and place it
	{
		CGSize blockerSize = CGSizeMake(150, 65);
        
        //NSLog (@"self.view.frame: %f %f", self.view.frame.size.width, self.view.frame.size.height);
		      
        float screenWidth = size.width;
        float screenHeight = size.height;
        
        NonBlockCenterView = [[UIView alloc] initWithFrame:CGRectMake( (screenWidth-blockerSize.width)/2, (screenHeight-blockerSize.height)/2, blockerSize.width, blockerSize.height)];
        
		NonBlockCenterView.backgroundColor = [UIColor colorWithRed:12.0/255 green:12.0/255 blue:12.0/255 alpha:0.8];
		NonBlockCenterView.layer.cornerRadius = 10.0;
		NonBlockCenterView.tag = kNonBlockCenterViewTag;		  
		
		float activityIndicatorWidth = 20.0;
        
		UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		activityIndicator.frame = CGRectMake(blockerSize.width/2-activityIndicatorWidth/2, 6, activityIndicatorWidth, activityIndicatorWidth);
		[activityIndicator startAnimating];
		[NonBlockCenterView addSubview:activityIndicator];
        
		UILabel *label = [[UILabel alloc] init];
		label.font = [UIFont systemFontOfSize: 14];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor whiteColor];
		label.textAlignment = UITextAlignmentCenter;
		label.lineBreakMode = UILineBreakModeTailTruncation;
		label.numberOfLines = 2;
		label.text = inTitle;
		[label sizeToFit];
        
		CGSize titleSize = [PublicUtils getTextSize:inTitle withFont:[UIFont systemFontOfSize: 14] andConstrainedToSize:CGSizeMake(blockerSize.width-20, blockerSize.height)];
		label.frame = CGRectMake(blockerSize.width/2 - titleSize.width/2, (blockerSize.height/2 - titleSize.height/2) + 8, titleSize.width, titleSize.height + 5);
		
		[NonBlockCenterView addSubview:label];
		
		[self.view setUserInteractionEnabled:isEnabled];
        
		[self.view addSubview:NonBlockCenterView];
	}
}



- (void)stopCenterAndNonBlockBusyViewWithTitle {
	
	id bgView = [self.view viewWithTag:kNonBlockCenterViewTag];
	if(bgView) {
		[self.view setUserInteractionEnabled:YES];
		[bgView removeFromSuperview];
	}
//    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
//    id fullScreenView = [delegate.rootViewController.view viewWithTag:kNonBlockCenterViewTag];
//    if(fullScreenView)
//    {
//		[fullScreenView removeFromSuperview];
//	}
}

@end