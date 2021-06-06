//
//  ChatDetailBottomView.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-10-30.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "ChatDetailBottomView.h"
#import "UIToast.h"
@implementation ChatDetailBottomView
@synthesize delegate;
@synthesize m_EmotionShowFlag;
@synthesize m_KeyBoardShowFlag;
@synthesize m_chatTextView;
@synthesize m_ChatImageView;
@synthesize m_dismissButton;
@synthesize m_bottomImage;
@synthesize m_sendButton;
@synthesize m_expressionButton;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //背景
        UIImageView *bottomImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chatdetail_bottom.png"]];
		bottomImage.frame = CGRectMake(0, 0, 320, 58);
        self.m_bottomImage = bottomImage;
        [self addSubview:bottomImage];
        SAFERELEASE(bottomImage)
        
        //表情按钮
		UIImage *expressionBT = [UIImage imageNamed:@"chatdetail_expression.png"];
		UIButton *expressionButton = [UIButton buttonWithType:UIButtonTypeCustom];
		expressionButton.frame = CGRectMake(6, 6, 30, 30);
		expressionButton.tag = 0;
		[expressionButton addTarget:self action:@selector(showExpressionView:) forControlEvents:UIControlEventTouchDown];
		[expressionButton setBackgroundImage:expressionBT forState:UIControlStateNormal];
		[self addSubview:expressionButton];
        self.m_expressionButton = expressionButton;
        
        //编辑框
		
        HPGrowingTextView *chatTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(40,5,200,34)];
        chatTextView.minNumberOfLines = 1;
        chatTextView.maxNumberOfLines = 5;
        chatTextView.returnKeyType = UIReturnKeySend; //just as an example
        chatTextView.font = [UIFont boldSystemFontOfSize:14.0f];
        chatTextView.delegate = self;
        chatTextView.layer.cornerRadius = 5; //给图层的边框设置为圆角
        chatTextView.layer.masksToBounds = YES;
        chatTextView.returnKeyType = UIReturnKeySend;
        chatTextView.userInteractionEnabled = NO;
		//      chatTextView.animateHeightChange = YES; //turns off animation
        [chatTextView sizeToFit];
        
		label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 34)];
		label.text = @"请输入要发送的内容";
		label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont systemFontOfSize:16];
		label.textAlignment = UITextAlignmentLeft;
		label.textColor = [UIColor lightGrayColor];
		[chatTextView addSubview:label];
        [self addSubview:chatTextView];
        SAFERELEASE(chatTextView)
        
        //发送按钮
		UIImage *sendBT = [UIImage imageNamed:@"chatdetail_send.png"];
		UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
		sendButton.frame = CGRectMake(244, 5, 64, 34);
		[sendButton setTitle:@"发送" forState:UIControlStateNormal];
		[sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[sendButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
		[sendButton setBackgroundImage:sendBT forState:UIControlStateNormal];
		[self addSubview:sendButton];
        self.m_sendButton = sendButton;
		SAFERELEASE(sendButton)
        
        //注册键盘 show通知
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillShown:)
													 name:UIKeyboardWillShowNotification
												   object:nil];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        //背景
        UIImageView *bottomImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chatdetail_bottom.png"]];
		bottomImage.frame = CGRectMake(0, 0, 320, 60);
        [self addSubview:bottomImage];
        self.m_bottomImage = bottomImage;
        SAFERELEASE(bottomImage)
        
        //表情按钮
		UIImage *expressionBT = [UIImage imageNamed:@"chatdetail_expression.png"];
		UIButton *expressionButton = [UIButton buttonWithType:UIButtonTypeCustom];
		expressionButton.frame = CGRectMake(6, 15, 30, 30);
		expressionButton.tag = 0;
		[expressionButton addTarget:self action:@selector(showExpressionView:) forControlEvents:UIControlEventTouchDown];
		[expressionButton setBackgroundImage:expressionBT forState:UIControlStateNormal];
		[self addSubview:expressionButton];
        self.m_expressionButton = expressionButton;
        //编辑框
		
        HPGrowingTextView *chatTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(40,12,200,34)];
        chatTextView.minNumberOfLines = 1;
        chatTextView.maxNumberOfLines = 5;
        chatTextView.returnKeyType = UIReturnKeySend; //just as an example
        chatTextView.font = [UIFont boldSystemFontOfSize:14.0f];
        chatTextView.delegate = self;
        chatTextView.layer.cornerRadius = 5; //给图层的边框设置为圆角
        chatTextView.layer.masksToBounds = YES;
        chatTextView.returnKeyType = UIReturnKeySend;
		//      chatTextView.animateHeightChange = YES; //turns off animation
        [chatTextView sizeToFit];
        
		label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 34)];
		label.text = @"请输入要发送的内容";
		label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont systemFontOfSize:16];
		label.textAlignment = UITextAlignmentLeft;
		label.textColor = [UIColor lightGrayColor];
		[chatTextView addSubview:label];

        [self addSubview:chatTextView];
        
        self.m_chatTextView = chatTextView;
        SAFERELEASE(chatTextView)
        
        //发送按钮
		UIImage *sendBT = [UIImage imageNamed:@"chatdetail_send.png"];
		UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
		sendButton.frame = CGRectMake(244, 12, 64, 34);
		[sendButton setTitle:@"发送" forState:UIControlStateNormal];
		[sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[sendButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
		[sendButton setBackgroundImage:sendBT forState:UIControlStateNormal];
		[self addSubview:sendButton];
        self.m_sendButton = sendButton;
        
        ChatImageView *chatImage = [[ChatImageView alloc] initWithFrame:CGRectMake(0, 480, 320, 140)];
        if(iPhone5)
        {
            chatImage.frame = CGRectMake(0, 520, 320, 140);
        }
		chatImage.delegate = self;
		self.m_ChatImageView = chatImage;
		//[self.superview addSubview:m_ChatImageView];
		[chatImage release];
        
        
        UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[dismissButton addTarget:self action:@selector(dismissButtonClicked:) forControlEvents:UIControlEventTouchDown];
		dismissButton.tag = 0;
		dismissButton.backgroundColor = [UIColor clearColor];
		self.m_dismissButton = dismissButton;
        
        //注册键盘 show通知
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillShown:)
													 name:UIKeyboardWillShowNotification
												   object:nil];
    }
    return self;
}
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float changeH = height - self.m_chatTextView.frame.size.height;
    
    self.frame = CGRectMake(0, self.frame.origin.y - changeH, 320, self.frame.size.height + changeH);
    self.m_bottomImage.frame = CGRectMake(0, 0, 320, self.frame.size.height);
    self.m_expressionButton.frame = CGRectMake(self.m_expressionButton.frame.origin.x, self.m_expressionButton.frame.origin.y + changeH, 30, 30);
    self.m_sendButton.frame = CGRectMake(self.m_sendButton.frame.origin.x, self.m_sendButton.frame.origin.y + changeH, 64, 34);
    
    if(delegate && [delegate respondsToSelector:@selector(textViewChanged:)])
    {
         [delegate textViewChanged:changeH];
    }
}
- (void)dismissButtonClicked:(id)sender
{
    self.m_KeyBoardShowFlag = NO;
    self.m_KeyBoardShowFlag = NO;
    self.m_expressionButton.tag = 0;
	[self removeEmotionView];
	if ([m_chatTextView.text isEqualToString:@""])
    {
		label.text = @"请输入要发送的内容";
	}
	
}
/*********************************************************************
 函数名称 : showExpressionView
 函数描述 : 显示表情库
 参数    N/A
 返回值 : N/A
 作者 : csxfno21
 *********************************************************************/
- (void)showExpressionView:(id)sender
{
	UIButton *btn = (UIButton *)sender;
	if (0 == btn.tag)
    {
		[self popExpressionView];
		btn.tag = 1;
	}
    else
    {
		[self removeEmotionView];
		btn.tag = 0;
	}
}

/*********************************************************************
 函数名称 : showExpressionView
 函数描述 : 显示表情库
 参数    N/A
 返回值 : N/A
 作者 : csxfno21
 *********************************************************************/
- (void)popExpressionView
{
	self.m_EmotionShowFlag = YES;
    self.m_KeyBoardShowFlag = NO;
	if (delegate != nil && [delegate respondsToSelector:@selector(setToDisplayEmotionViewCallBack)])
    {
		[delegate setToDisplayEmotionViewCallBack];
	}
}
/*********************************************************************
 函数名称 : removeEmotionView
 函数描述 : 移出表情库
 参数    N/A
 返回值 : N/A
 作者 : csxfno21
 *********************************************************************/
- (void)removeEmotionView
{
    self.m_EmotionShowFlag = NO;
    
	if (delegate != nil && [delegate respondsToSelector:@selector(setToDissmissEmotionViewCallBack)])
    {
		[delegate setToDissmissEmotionViewCallBack];
	}
}
/*********************************************************************
 函数名称 : keyboardWillShown
 函数描述 : 键盘显示的通知
 参数
 返回值 : N/A
 作者 : csxfno21
 *********************************************************************/
- (void)keyboardWillShown:(NSNotification*)aNotification
{
	self.m_KeyBoardShowFlag = YES;
	self.m_EmotionShowFlag = NO;
    
	NSDictionary* info = [aNotification userInfo];
	CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到键盘的高度
    
	if (delegate != nil && [delegate respondsToSelector:@selector(keyboardWillShowCallBack:)])
    {
		[delegate keyboardWillShowCallBack:kbSize.height];
	}
	
}

- (void)setImage:(NSInteger)type withText:(NSString *)expression
{
    NSString *text = nil;
    m_KeyBoardHeight = 105;
	switch (type){
		case 1:
            
            text = self.m_chatTextView.text;
            NSString *str = [text stringByAppendingString:expression];
            [self.m_chatTextView setText:str];
            [m_chatTextView textViewDidChange:m_chatTextView.internalTextView];
            [m_chatTextView setSelectedRange:NSMakeRange(m_chatTextView.internalTextView.text.length, 0)];
			[self growingTextViewDidChange:m_chatTextView];
		    break;
            
		case 2:
		{
            if ([m_chatTextView.text length]>0) {
                m_chatTextView.text = [m_chatTextView.text substringToIndex:[m_chatTextView.text length]-1];
				[self.m_chatTextView setText:m_chatTextView.text];
				[m_chatTextView textViewDidChange:m_chatTextView.internalTextView];
                [self growingTextViewDidChange:m_chatTextView];
            }
            
		}
			
			break;
            
	}
	
	if ([m_chatTextView.text isEqualToString:@""]) {
		label.text = @"请输入要发送的内容";
		
		m_sendButton.enabled = NO;
		m_sendButton.alpha = 0.6;
	}else {
		label.text = @"";
		m_sendButton.enabled = YES;
		m_sendButton.alpha = 1;
	}
    
}
- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    if ([growingTextView.text length] > 400) {
		NSString *textValu = growingTextView.text;
		growingTextView.text = [textValu substringToIndex:400];
	}
	
    if ([growingTextView.text isEqualToString:@""]) {
		label.text = @"请输入要发送的内容";
		m_sendButton.enabled = NO;
		m_sendButton.alpha = 0.6;
	}else {
		label.text = @"";
		m_sendButton.enabled = YES;
		m_sendButton.alpha = 1;
	}
	
}
- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    [self sendMessage];
	return YES;
}
/*********************************************************************
 函数名称 : sendMessage
 函数描述 : 发送消息
 参数    N/A
 返回值 : N/A
 作者 : csxfno21
 *********************************************************************/
- (void)sendMessage
{
	self.m_expressionButton.tag = 1;
    
    if ([m_chatTextView.text isEqualToString:@""])
    {
        // 不能发送空的消息
        UIToast *toast = [[UIToast alloc] init];
		[toast show:@"请先输入要发送的内容."];
		[toast release];
	}
    else
    {
        if([PublicUtils getNetState] == NotReachable)
        {
            UIToast *toast = [[UIToast alloc] init];
            [toast show:@"抱歉,当前网络不佳,请检查您的网络"];
            [toast release];
        }
        else
        {
            if(delegate && [delegate respondsToSelector:@selector(sendMessage:)])
            {
                [delegate sendMessage:m_chatTextView.text];
            }
        }
	}
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    SAFERELEASE(m_bottomImage)
    SAFERELEASE(m_ChatImageView)
    SAFERELEASE(m_chatTextView)
    [super dealloc];
}
@end
