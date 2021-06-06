//
//  ChatImageView.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-10-30.
//  Copyright (c) 2013年 company. All rights reserved.
//
#import "ChatImageView.h"

@implementation ChatImageView
@synthesize m_expressScro;
@synthesize delegate;
@synthesize m_backgroundView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		//背景图片
		UIImage *backgroundImg = [UIImage imageNamed:@"chatdetail_expression_background.png"];
		UIImageView *backgroundView = [[UIImageView alloc] initWithImage:backgroundImg];
		backgroundView.frame = CGRectMake(0, 0, 320, 140);
		self.m_backgroundView=backgroundView;
		[self addSubview:m_backgroundView];
		[backgroundView  release];
		[backgroundImg release];
        
        
        UIScrollView *i_emojiScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 140)];
        //设置表情列表scrollview属性
        self.m_expressScro = i_emojiScrollView;			
        [i_emojiScrollView release]; 
        m_expressScro.showsHorizontalScrollIndicator = NO;
        m_expressScro.showsVerticalScrollIndicator = YES;
        m_expressScro.backgroundColor = [UIColor clearColor];
        [self addSubview:m_expressScro];			
        [self emojiView];
		
        // Initialization code
    }
    return self;
}






/********************************************************************
 函数名称  : emojiView
 函数描述  : 创建表情视图
 输入参数  : 无
 输出参数  : N/A
 返回值    : 无
 备注      : N/A
 *********************************************************************/
-(void)emojiView
{
    [m_expressScro setContentSize:CGSizeMake(0, 310)];
    m_expressScro.scrollEnabled = YES;
	//    NSString *filePathImg = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"emotionImg.plist"];	
	//	NSDictionary *m_pEmojiDicImg = [[NSDictionary alloc] initWithContentsOfFile:filePathImg];
	NSArray *picImage =[[NSArray alloc] initWithObjects:@"wx",@"pz",@"se",@"fd",@"bs",@"dy",@"kk",@"hx",@"hy",@"jx",
						@"yx",@"bz",@"qq",@"qr",@"dk",@"dr",@"kel",@"gg",@"fn",@"xig",
						@"cy",@"jy",@"kuk",@"chifan",@"chr",@"chx",@"cr",@"zt",@"zk",@"mg",
						@"nanwen",@"px",@"sa",@"xin",@"bx",@"baiy",@"dg",@"snd",@"sq",@"ss",
						@"bsh",@"kun",@"kx",@"zhd",@"lh",@"lr",@"hanx",@"db",@"bb",@"fendou",
						@"zhm",@"zhouma",@"zht",@"lw",@"yb",@"yihuo",@"yun",@"qiang",@"shuai",@"shx",
						@"shy",@"ws",@"wunai",@"shl",@"bq",@"qt",@"rn",@"hd",@"bh",nil];
    
	
	//表情界面创建
	for (int n = 1; n < 70; n++) {
		
		if (n <= 8) {
			
			//创建第一行表情
			UIButton *btn = [[UIButton alloc] init];
			[btn setFrame:CGRectMake(32*(n-1) + n*7, 7, 32, 32)];
			[btn setBackgroundColor:[UIColor clearColor]];
			//            NSString *imgValue = [m_pEmojiDicImg objectForKey:[NSString stringWithFormat:@"%d",n]];
			//            NSString *imageStr = [imgValue substringWithRange:NSMakeRange(1, imgValue.length-1)];
			NSString *imageStr = [picImage objectAtIndex:n-1];
			[btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"exp_%@",imageStr]] forState:UIControlStateNormal];
			[btn addTarget:self action:@selector(emojiButtonPress:) forControlEvents:UIControlEventTouchUpInside];
			[btn setTag:n];
			[m_expressScro addSubview:btn];
            [btn release];
		}
		else if (8< n && n<=16) {
			
			//创建第二行表情
			UIButton *btn = [[UIButton alloc]init];
			[btn setFrame:CGRectMake(32*(n-9) + (n-8)*7, 39, 32, 32)];
			[btn setBackgroundColor:[UIColor clearColor]];
			//			NSString *imgValue = [m_pEmojiDicImg objectForKey:[NSString stringWithFormat:@"%d",n]];
			//            NSString *imageStr = [imgValue substringWithRange:NSMakeRange(1, imgValue.length-1)];
			NSString *imageStr = [picImage objectAtIndex:n-1];
			[btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"exp_%@",imageStr]] forState:UIControlStateNormal];
			[btn addTarget:self action:@selector(emojiButtonPress:) forControlEvents:UIControlEventTouchUpInside];
			[btn setTag:n];
			[m_expressScro addSubview:btn];
			[btn release];
		}
		
		else if (16< n && n <=24) {
			
			//创建第三行表情
			UIButton *btn = [[UIButton alloc] init];
			[btn setFrame:CGRectMake(32*(n-17) +(n-16)*7, 71, 32, 32)];
			[btn setBackgroundColor:[UIColor clearColor]];
			//			NSString *imgValue = [m_pEmojiDicImg objectForKey:[NSString stringWithFormat:@"%d",n]];
			//            NSString *imageStr = [imgValue substringWithRange:NSMakeRange(1, imgValue.length-1)];
			NSString *imageStr = [picImage objectAtIndex:n-1];
			[btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"exp_%@",imageStr]] forState:UIControlStateNormal];
			[btn addTarget:self action:@selector(emojiButtonPress:) forControlEvents:UIControlEventTouchUpInside];
			[btn setTag:n];
			[m_expressScro addSubview:btn];
			[btn release];
		}
		
		else if (24< n && n <=32) {
			
			//创建第四行表情
			UIButton *btn = [[UIButton alloc] init];
			[btn setFrame:CGRectMake(32*(n-25) + (n-24)*7, 103, 32, 32)];
			[btn setBackgroundColor:[UIColor clearColor]];
			//			NSString *imgValue = [m_pEmojiDicImg objectForKey:[NSString stringWithFormat:@"%d",n]];
			//            NSString *imageStr = [imgValue substringWithRange:NSMakeRange(1, imgValue.length-1)];
			NSString *imageStr = [picImage objectAtIndex:n-1];
			[btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"exp_%@",imageStr]] forState:UIControlStateNormal];
			[btn addTarget:self action:@selector(emojiButtonPress:) forControlEvents:UIControlEventTouchUpInside];
			[btn setTag:n];
			[m_expressScro addSubview:btn];
			[btn release];
		}
		else if (32< n && n <=40) {
			
			//创建第五行表情
			UIButton *btn = [[UIButton alloc] init];
			[btn setFrame:CGRectMake(32*(n-33)+(n-32)*7, 135, 32, 32)];
			[btn setBackgroundColor:[UIColor clearColor]];
			//			NSString *imgValue = [m_pEmojiDicImg objectForKey:[NSString stringWithFormat:@"%d",n]];
			//            NSString *imageStr = [imgValue substringWithRange:NSMakeRange(1, imgValue.length-1)];
			NSString *imageStr = [picImage objectAtIndex:n-1];
			[btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"exp_%@",imageStr]] forState:UIControlStateNormal];
			[btn addTarget:self action:@selector(emojiButtonPress:) forControlEvents:UIControlEventTouchUpInside];
			[btn setTag:n];
			[m_expressScro addSubview:btn];
			[btn release];
		}
		
		else if (40< n && n <=48) {
			
			//创建第六行表情
			UIButton *btn = [[UIButton alloc] init];
			[btn setFrame:CGRectMake(32*(n-41)+(n-40)*7, 167, 32, 32)];
			[btn setBackgroundColor:[UIColor clearColor]];
			//            NSString *imgValue = [m_pEmojiDicImg objectForKey:[NSString stringWithFormat:@"%d",n]];
			//            NSString *imageStr = [imgValue substringWithRange:NSMakeRange(1, imgValue.length-1)];
			NSString *imageStr = [picImage objectAtIndex:n-1];
			[btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"exp_%@",imageStr]] forState:UIControlStateNormal];
			[btn addTarget:self action:@selector(emojiButtonPress:) forControlEvents:UIControlEventTouchUpInside];
			[btn setTag:n];
			[m_expressScro addSubview:btn];
			[btn release];
		}
		else if (48< n && n <=56) {
			
			//创建第七行表情
			UIButton *btn = [[UIButton alloc] init];
			[btn setFrame:CGRectMake(32*(n-49)+(n-48)*7, 199,32, 32)];
			[btn setBackgroundColor:[UIColor clearColor]];
			//			NSString *imgValue = [m_pEmojiDicImg objectForKey:[NSString stringWithFormat:@"%d",n]];
			//            NSString *imageStr = [imgValue substringWithRange:NSMakeRange(1, imgValue.length-1)];
			NSString *imageStr = [picImage objectAtIndex:n-1];
			[btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"exp_%@",imageStr]] forState:UIControlStateNormal];
			[btn addTarget:self action:@selector(emojiButtonPress:) forControlEvents:UIControlEventTouchUpInside];
			[btn setTag:n];
			[m_expressScro addSubview:btn];
			[btn release];
		}
        else if (56< n && n <=64) {
			
			//创建第七行表情
			UIButton *btn = [[UIButton alloc] init];
			[btn setFrame:CGRectMake(32*(n-57)+(n-56)*7, 238,32, 32)];
			[btn setBackgroundColor:[UIColor clearColor]];
			//			NSString *imgValue = [m_pEmojiDicImg objectForKey:[NSString stringWithFormat:@"%d",n]];
			//            NSString *imageStr = [imgValue substringWithRange:NSMakeRange(1, imgValue.length-1)];
			NSString *imageStr = [picImage objectAtIndex:n-1];
			[btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"exp_%@",imageStr]] forState:UIControlStateNormal];
			[btn addTarget:self action:@selector(emojiButtonPress:) forControlEvents:UIControlEventTouchUpInside];
			[btn setTag:n];
			[m_expressScro addSubview:btn];
			[btn release];
		}
        else if (64< n && n <=69) {
			
			//创建第七行表情
			UIButton *btn = [[UIButton alloc] init];
			[btn setFrame:CGRectMake(32*(n-65)+(n-64)*7, 277,32, 32)];
			[btn setBackgroundColor:[UIColor clearColor]];
			//			NSString *imgValue = [m_pEmojiDicImg objectForKey:[NSString stringWithFormat:@"%d",n]];
			//            NSString *imageStr = [imgValue substringWithRange:NSMakeRange(1, imgValue.length-1)];
			NSString *imageStr = [picImage objectAtIndex:n-1];
			[btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"exp_%@",imageStr]] forState:UIControlStateNormal];
			[btn addTarget:self action:@selector(emojiButtonPress:) forControlEvents:UIControlEventTouchUpInside];
			[btn setTag:n];
			[m_expressScro addSubview:btn];
			[btn release];
		}
		
	}
}

/********************************************************************
 函数名称  : emojiButtonPress
 函数描述  : 表情事件响应
 输入参数  : sender
 输出参数  : N/A
 返回值    : 无
 备注      : N/A
 *********************************************************************/
-(void)emojiButtonPress:(id)sender
{
	//获取对应的button
	UIButton *selectedButton = (UIButton *) sender;
	int  n = selectedButton.tag;
	
	//根据button的tag获取对应的图片名
	NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"emotionImg.plist"];	
	NSDictionary *m_pEmojiDic = [[NSDictionary alloc] initWithContentsOfFile:filePath];	
	NSString *i_transCharacter = [m_pEmojiDic objectForKey:[NSString stringWithFormat:@"%d",n]];
	
	[self.delegate setImage:1 withText:i_transCharacter];
    /*do something here*/
	[m_pEmojiDic release];
}


-(void)dealloc
{
    [m_expressScro release];
	[m_backgroundView release];
    [super dealloc];
}
@end
