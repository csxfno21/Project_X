//
//  HTEmotionView.h
//  HTEmotionView
//
//  Created by csxfno21 on 11/7/13.
//  Copyright (c) 2013 ly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTEmotionView : UIView

// 原始的字符串
@property (strong, nonatomic) NSString *emotionString;

// 处理过后的用户绘图的富文本字符串
@property (strong, nonatomic, readonly) NSAttributedString *attrEmotionString; 

// 按顺序保存的 emotionString 中包含的表情名字
@property (strong, nonatomic, readonly) NSArray *emotionNames;

@property (strong, nonatomic, readonly) NSArray *emotionRanges;






- (id)initWithFrame:(CGRect)frame emotionString:(NSString *)emotionString;

+ (CGSize)sizeWithMessage:(NSString*)message;

/// 将 emotionString 中的特殊字符串替换为空格
// @discussion 不要直接调用此方法
- (void)cookEmotionString;



@end
