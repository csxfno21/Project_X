//
//  UIViewController+ProgressSheet.h
//  Larky
//
//  Created by Sandeep GS on 25/04/12.
//  Copyright 2012 Sourcebits Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ProgressSheet)

//- (void)startFullScreenBlockBysyViewWithTitle:(NSString*)inTitle;
/*!
 @method     startCenterAndNonBlockBusyViewWithTitle:inTitle:needUserInteraction
 @abstract   Returns the blocker view with acitivity indicator and title for this view.
 @discussion This method puts up a view in the center of the screen and assigns it a specific tag (10003) for identifying the view for later use.
 */
- (void)startCenterAndNonBlockBusyViewWithTitle:(NSString *)inTitle needUserInteraction:(BOOL)isEnabled;


/*!
 @method     startCenterAndNonBlockBusyViewWithTitle:inTitle:needUserInteraction:center:
 @abstract   Returns the blocker view with acitivity indicator and title for this view.
 @discussion This method puts up a view in the center of the screen and assigns it a specific tag (10003) for identifying the view for later use.
 */

- (void)startCenterAndNonBlockBusyViewWithTitle:(NSString *)inTitle needUserInteraction:(BOOL)isEnabled viewSize:(CGSize) size;


/*!
 @method     stopCenterAndNonBlockBusyViewWithTitle
 @abstract   Removes the blocker view put up by startCenterAndNonBlockBusyViewWithTitle.
 @discussion This method finds the view with a tag (10003) and removes it from the view
 */
- (void)stopCenterAndNonBlockBusyViewWithTitle;




@end