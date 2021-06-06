//
//  BasePopView.h
//  Tourism
//
//  Created by csxfno21 on 13-4-8.
//  Copyright (c) 2013年 logic. All rights reserved.
//

#import <UIKit/UIKit.h>
#define  GESTURE     1000
@interface BasePopView : UIView<UIGestureRecognizerDelegate>
{
    
}
@property(nonatomic,retain)UIImageView *centBgView;
- (void)setCentBgViewFrame:(CGRect)frame;
- (void)dismissPopView:(BOOL)anim;
- (void)show:(UIView*)contentView;
@end
