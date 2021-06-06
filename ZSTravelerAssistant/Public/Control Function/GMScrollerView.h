//
//  GMScrollerView.h
//  GMScrollerView
//
//  Created by csxfno21 on 13-8-1.
//  Copyright (c) 2013年 company. All rights reserved.
//
@protocol GMScrollerViewDelegate <NSObject>

- (void)gmScrollerViewAction:(int)index;

@end
#import <UIKit/UIKit.h>

@interface GMScrollerView : UIView<UIScrollViewDelegate>
{
    UIScrollView *contentView;
    UIImageView *highlightedView;
    
    
    int selectedIndex;
    int leftIndex;
    
    int hightLightIndex;
    
    id<GMScrollerViewDelegate> delegate;
}

@property(nonatomic,assign)id<GMScrollerViewDelegate> delegate;
@property(nonatomic,retain)NSArray *titles;
@property(nonatomic,assign)int selectedIndex;
@end
