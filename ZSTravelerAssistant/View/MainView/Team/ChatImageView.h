//
//  ChatImageView.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-10-30.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChatImageViewDelegate <NSObject>
- (void)setImage:(NSInteger )type withText:(NSString *)expression;

@end

@interface ChatImageView : UIView
{
    UIScrollView *m_expressScro;
	
	id<ChatImageViewDelegate> delegate;
	

	UIImageView *m_backgroundView;

}
@property(retain,nonatomic)UIScrollView *m_expressScro;
@property(nonatomic,assign)id<ChatImageViewDelegate> delegate;

@property(retain,nonatomic) UIImageView *m_backgroundView;

-(void)emojiView;
@end
