//
//  HTEmotionView.m
//  HTEmotionView
//
//  Created by csxfno21 on 11/7/13.
//  Copyright (c) 2013 ly. All rights reserved.
//

#import "HTEmotionView.h"
#import <CoreText/CoreText.h>
#import "HTRegularExpressionManager.h"
#import "NSString+HTExtension.h"
#import "NSArray+HTExtension.h"

#define EmotionItemPattern          @"\\[(.*?)\\]"
#define PlaceHolder                 @" "
#define EmotionFileType             @"png"
#define AttributedImageNameKey      @"ImageName"

#define EmotionImageWidth           15.0
#define FontHeight                  15.0
#define ImageLeftPadding            0.0
#define ImageTopPadding             3.0
#define FontSize                    EmotionImageWidth
#define MAX_Width                   200.0

@implementation HTEmotionView
{
    dispatch_queue_t queue;
    dispatch_group_t group;
    CTTypesetterRef typesetter;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _emotionString = @"";
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _emotionString = @"";
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame emotionString:(NSString *)emotionString
{
    self = [super initWithFrame:frame];
    if (self) {
        _emotionString = emotionString;
        [self setup];
    }
    return self;
}
- (void)setEmotionString:(NSString *)emotionString
{
    _emotionString = emotionString;
//    CGSize size = [self sizeWithMessage:emotionString];
    CGSize size = [HTEmotionView sizeWithMessage:emotionString];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
    [self setup];
}
/**
 *  message 文本
 *  返回: 图文显示的宽高
 */
+(CGSize)sizeWithMessage:(NSString*)message
{
    NSString *msg = [NSString stringWithString:message];
    
    NSDictionary *emotionImageDic = [[NSDictionary alloc] initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"emotionImage.plist"]];
    NSArray *keys = emotionImageDic.allKeys;
    //求出多少个 img
    NSMutableArray *itemIndexes = [HTRegularExpressionManager itemIndexesWithPattern:
                                   EmotionItemPattern inString:msg];
    NSMutableArray *imgNames = [[NSMutableArray alloc] init];
    NSMutableArray *needRemoveIndex = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < itemIndexes.count; i++)
    {
        NSRange range = [[itemIndexes objectAtIndex:i] rangeValue];
        NSString *emotron = [msg substringWithRange:range];
        
        if(![keys containsObject:emotron])
        {
            [needRemoveIndex addObject:[itemIndexes objectAtIndex:i]];
        }
        else
        {
            [imgNames addObject:[emotionImageDic objectForKey:emotron]];
        }
    }
    for (NSObject *obj in needRemoveIndex)
    {
        [itemIndexes removeObject:obj];
    }
    NSString * cuttedmsg = [msg replaceCharactersAtIndexes:itemIndexes
                                                withString:@" "];
    CGSize size = [cuttedmsg sizeWithFont:[UIFont fontWithName:@"Helvetica" size:FontSize]];
    //    float w = size.height < 22 ? size.width:200;
    
    float w = size.width + EmotionImageWidth * itemIndexes.count;
    float countF = w / MAX_Width;
    int colum = ceil(countF);
    return CGSizeMake(colum > 1 ?MAX_Width: w, colum * size.height);
}


- (void)dealloc
{
    CFRelease(typesetter);
    dispatch_release(group);    // iOS 6.0 以下需要手动释放
}

- (void)setup
{
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    group = dispatch_group_create();
    
    [self prepare];
}

- (void)prepare
{
    self.backgroundColor = [UIColor clearColor];
    
    [self cookEmotionString];
}

#pragma mark - Cook the emotion string
- (void)cookEmotionString
{
//    CFTimeInterval startTime = CACurrentMediaTime();
    //求出 特殊字符的位置
    NSDictionary *emotionImageDic = [[NSDictionary alloc] initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"emotionImage.plist"]];
    NSArray *keys = emotionImageDic.allKeys;
    
    // 使用正则表达式查找特殊字符的位置
    NSMutableArray *itemIndexes = [HTRegularExpressionManager itemIndexesWithPattern:
                            EmotionItemPattern inString:_emotionString];
    NSMutableArray *imgNames = [[NSMutableArray alloc] init];
    NSMutableArray *needRemoveIndex = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < itemIndexes.count; i++)
    {
        NSRange range = [[itemIndexes objectAtIndex:i] rangeValue];
        NSString *emotron = [_emotionString substringWithRange:range];
        
        if(![keys containsObject:emotron])
        {
            [needRemoveIndex addObject:[itemIndexes objectAtIndex:i]];
        }
        else
        {
            [imgNames addObject:[emotionImageDic objectForKey:emotron]];
        }
    }
    for (NSObject *obj in needRemoveIndex)
    {
        [itemIndexes removeObject:obj];
    }
    __weak id target = self;
    __block NSArray *names = nil;
    __block NSString *newString = nil;
    __block NSArray *newRanges = nil;
    
    
    dispatch_group_async(group, queue, ^{
        // 查找表情对应的字符串 并加载相应的表情图片到内存中
        names = imgNames;
    });
    dispatch_group_async(group, queue, ^{
        // 将 emotionString 中的特殊字符串替换为空格
        newString = [_emotionString replaceCharactersAtIndexes:itemIndexes
                                                    withString:PlaceHolder];
    });
    dispatch_group_async(group, queue, ^{
        // 新的表情的占位符的 range 数组
        newRanges = [itemIndexes offsetRangesInArrayBy:[PlaceHolder length]];
    });
    
    dispatch_group_notify(group, queue, ^{
        _emotionNames = names;
        _emotionRanges = newRanges;
        _attrEmotionString = [target createAttributedEmotionStringWithRanges:newRanges
                                                                   forString:newString];
        // 创建typesetter 太耗费时间，所以在 typesetter 创建的时间提前到绘图前
        typesetter = CTTypesetterCreateWithAttributedString((__bridge CFAttributedStringRef)
                                               (_attrEmotionString));
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [target setNeedsDisplay];
        });
    });
//    CFTimeInterval endTime = CACurrentMediaTime();
}

#pragma mark - Utility for emotions relative operations
// 根据调整后的字符串，生成绘图时使用的 attribute string
- (NSAttributedString *)createAttributedEmotionStringWithRanges:(NSArray *)ranges
                                                      forString:(NSString*)aString
{
    NSAssert(_emotionString != nil, @"emotionString 不可以为Nil");
    NSAssert(aString != nil,        @"aString 不可以为Nil");
    
    
    NSMutableAttributedString *attrString =
    [[NSMutableAttributedString alloc] initWithString:aString];
    CTFontRef helvetica = CTFontCreateWithName(CFSTR("Helvetica"), FontSize, NULL);
    
    [attrString addAttribute:(id)kCTFontAttributeName value:(__bridge id)(helvetica) range:NSMakeRange(0, [aString length])];
    for(NSInteger i = 0; i < [ranges count]; i++)
    {
        NSRange range = [[ranges objectAtIndex:i] rangeValue];
        NSString *emotionName = [self.emotionNames objectAtIndex:i];
        [attrString addAttribute:AttributedImageNameKey value:emotionName range:range];
        [attrString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge_transfer id)newEmotionRunDelegate() range:range];
    }
    return attrString;
}

// 通过表情名获得表情的图片
- (UIImage *)getEmotionForKey:(NSString *)key
{
    // 使用系统缓存
    return [UIImage imageNamed:key];
}

CTRunDelegateRef newEmotionRunDelegate()
{
    static NSString *emotionRunName = @"njht";
    
    CTRunDelegateCallbacks imageCallbacks;
    imageCallbacks.version = kCTRunDelegateVersion1;
    imageCallbacks.dealloc = RunDelegateDeallocCallback;
    imageCallbacks.getAscent = RunDelegateGetAscentCallback;
    imageCallbacks.getDescent = RunDelegateGetDescentCallback;
    imageCallbacks.getWidth = RunDelegateGetWidthCallback;
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallbacks,
                                   (__bridge void *)(emotionRunName));
    
    return runDelegate;
}

#pragma mark - Run delegate
void RunDelegateDeallocCallback( void* refCon )
{
    // Do nothing here
}

CGFloat RunDelegateGetAscentCallback( void *refCon )
{
    return FontHeight;
}

CGFloat RunDelegateGetDescentCallback(void *refCon)
{
    return 0.0;
}

CGFloat RunDelegateGetWidthCallback(void *refCon)
{
    // EmotionImageWidth + 2 * ImageLeftPadding
    return  19.0;
}

#pragma mark - Drawing
- (void)drawRect:(CGRect)rect
{
    // 没有内容时取消本次绘制
    if (!typesetter)   return;
    
    CGFloat w = CGRectGetWidth(self.frame);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 保存 context 信息
    CGContextSaveGState(context);
    
    // 翻转坐标系
    Flip_Context(context, FontHeight);
    
    CGFloat y = 0;
    CFIndex start = 0;
    NSInteger length = [_attrEmotionString length];
    while (start < length)
    {
        CFIndex count = CTTypesetterSuggestClusterBreak(typesetter, start, w);
        CTLineRef line = CTTypesetterCreateLine(typesetter, CFRangeMake(start, count));
        CGContextSetTextPosition(context, 0, y);
        
        // 画字
        CTLineDraw(line, context);  
        
        // 画表情
        Draw_Emoji_For_Line(context, line, self, CGPointMake(0, y)); 
        
        start += count;
        y -= 13.0 + 4.0;
        
        CFRelease(line);
    }

    // 恢复 context 信息
    CGContextRestoreGState(context);
}


// 翻转坐标系
static inline
void Flip_Context(CGContextRef context, CGFloat offset) // offset为字体的高度
{
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -offset);
}

// 生成每个表情的 frame 坐标
static inline
CGPoint Emoji_Origin_For_Line(CTLineRef line, CGPoint lineOrigin, CTRunRef run)
{
    CGFloat x = lineOrigin.x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL) + ImageLeftPadding;
    CGFloat y = lineOrigin.y - ImageTopPadding;
    return CGPointMake(x, y);
}


// 绘制每行中的表情
void Draw_Emoji_For_Line(CGContextRef context, CTLineRef line, id owner, CGPoint lineOrigin)
{
    CFArrayRef runs = CTLineGetGlyphRuns(line);
    
    // 统计有多少个run
    NSUInteger count = CFArrayGetCount(runs);
    
    // 遍历查找表情run
    for(NSInteger i = 0; i < count; i++)
    {
        CTRunRef aRun = CFArrayGetValueAtIndex(runs, i);
        CFDictionaryRef attributes = CTRunGetAttributes(aRun);
        NSString *emojiName = (NSString *)CFDictionaryGetValue(attributes, AttributedImageNameKey);
        if (emojiName)
        {
            // 画表情
            CGRect imageRect = CGRectZero;
            imageRect.origin = Emoji_Origin_For_Line(line, lineOrigin, aRun);
            imageRect.size = CGSizeMake(EmotionImageWidth, EmotionImageWidth);
            CGImageRef img = [[owner getEmotionForKey:emojiName] CGImage];
            CGContextDrawImage(context, imageRect, img);
        }
    }
}

@end
