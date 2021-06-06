//
//  ChatDetailBottomView.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-10-30.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "HPGrowingTextView.h"
#import "ChatImageView.h"
@protocol ChatDetailBottomViewDelegate <NSObject>
@optional
- (void)sendMessage:(NSString *)msgContent;
- (void)setToDisplayEmotionViewCallBack;
- (void)setToDissmissEmotionViewCallBack;
- (void)keyboardWillShowCallBack:(float)height;
- (void)sendMsgToSetCtlSubViewFrame;
- (void)textViewChanged:(float)height;
@end
@interface ChatDetailBottomView : UIView<HPGrowingTextViewDelegate,ChatImageViewDelegate>
{
    //发送按钮
    //输入框
    //表情符号
    id<ChatDetailBottomViewDelegate> delegate;
    BOOL m_EmotionShowFlag;
    BOOL m_KeyBoardShowFlag;
    UILabel *label;
    HPGrowingTextView *m_chatTextView;
    ChatImageView *m_ChatImageView;
    UIButton *m_dismissButton;
    UIButton *m_expressionButton;
    UIImageView *m_bottomImage;
    UIButton *m_sendButton;
    CGFloat m_KeyBoardHeight;
}
@property (nonatomic,retain) HPGrowingTextView *m_chatTextView;
@property (nonatomic,retain) ChatImageView *m_ChatImageView;
@property (nonatomic,retain) UIButton *m_dismissButton;
@property (nonatomic,retain) UIImageView *m_bottomImage;
@property (nonatomic,retain) UIButton *m_expressionButton;
@property (nonatomic,retain) UIButton *m_sendButton;
@property (nonatomic,assign) id<ChatDetailBottomViewDelegate> delegate;
@property (nonatomic,assign) BOOL m_EmotionShowFlag;
@property (nonatomic,assign) BOOL m_KeyBoardShowFlag;
@end
