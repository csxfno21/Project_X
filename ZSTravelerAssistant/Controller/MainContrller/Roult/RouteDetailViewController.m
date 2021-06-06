//
//  RouteDetailViewController.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-5.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "RouteDetailViewController.h"

@interface RouteDetailViewController ()

@end

@implementation RouteDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        gmScrollerView = [[GMScrollerView alloc] initWithFrame:CGRectMake(0, 44, 320, 60)];
        gmScrollerView.delegate = self;
        [self.view addSubview:gmScrollerView];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mTour.text = [Language stringWithName:ROUR_GUIDE] ;
    self.mBack.text = [Language stringWithName:BACK];

    self.mScrollerView.delegate = self;
    
    pageControl = [[SMPageControl alloc] initWithFrame:CGRectMake(10, 270, 300, 10)];
    pageControl.alignment = SMPageControlAlignmentCenter;
    pageControl.pageIndicatorImage = [UIImage imageNamed:@"page-nom.png"];
    pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"page-sel.png"];
    [pageControl addTarget:self action:@selector(pageControl:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
    
}
- (void)setContent:(int)count
{
    if(count < self.data.count)
    {
        ZS_CustomizedSpot_entity *entity = (ZS_CustomizedSpot_entity*)[self.data objectAtIndex:count];
        self.mTextView.text = entity.SpotContent;
    }
}
- (void)setData:(NSArray *)data
{
    _data = [data retain];
    NSMutableArray *titles = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < _data.count; i++)
    {
        ZS_CustomizedSpot_entity *entity = (ZS_CustomizedSpot_entity*)[_data objectAtIndex:i];
        [titles addObject:entity.SpotName];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(320 * i + 6, 0, 310, 150)];
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingView.frame = CGRectMake(0, 0, 310, 150);
        loadingView.tag = i + 100;
        [imgView addSubview:loadingView];
        
        
        UIImage *image = [[NetFileLoadManager sharedInstanced] loadImageByURL:entity.SpotImgUrl withDelegate:self withID:entity.ID withImgName:entity.SpotImgName withCmdcode:CC_DOWN_IMAGE_SPOT];
        if(image)
        {
            [imgView setImage:image];
        }
        else
        {
            [loadingView startAnimating];
        }
        imgView.tag = i + 1000;
        [self.mScrollerView addSubview:imgView];
        SAFERELEASE(loadingView)
        SAFERELEASE(imgView)
    }
    gmScrollerView.titles = titles;
    pageControl.currentPage = 0;
    pageControl.numberOfPages = _data.count;
    self.mScrollerView.contentSize = CGSizeMake(320 * _data.count, 0);
    [self setContent:0];
}
-(void)pageControl:(id)sender
{
    SMPageControl *pc = (SMPageControl *)sender;
    int currentPage = pc.currentPage;
    [self.mScrollerView setContentOffset:CGPointMake(currentPage * 320, 0) animated:YES];
    gmScrollerView.selectedIndex = currentPage;
    [self speakNew];
    [self setContent:currentPage];
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)navAction:(id)sender
{

    CGFloat xWidth = self.view.bounds.size.width - 30.0f;
    CGFloat yHeight = 300.0f;
    CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
    RouteNavPopView *popView = [RouteNavPopView instanceRouteNavPopView];
    popView.frame = CGRectMake(15, yOffset, xWidth, yHeight);
    [popView setTitleText:self.mTitle.text];
    popView.delegate = self;
    [popView show];
}

- (void)speakNew
{
    [[TTSPlayer shareInstance] stopVideo];
    [self.speakBtn setImage:[UIImage imageNamed:@"Route-voice-off"] forState:UIControlStateNormal];
    isSpeaking = NO;
}
- (IBAction)speakAction:(id)sender
{
    if(isSpeaking)
    {
        [[TTSPlayer shareInstance] pauseVideo];
        isSpeaking = NO;
        [(UIButton*)sender setImage:[UIImage imageNamed:@"Route-voice-off"] forState:UIControlStateNormal];
    }
    else
    {
        [(UIButton*)sender setImage:[UIImage imageNamed:@"Route-voice-on"] forState:UIControlStateNormal];
        isSpeaking = YES;
        if([TTSPlayer shareInstance].delegate == self)
        {
            [[TTSPlayer shareInstance] rePlayVideo];
        }
        else
        {
            [TTSPlayer shareInstance].delegate = self;
            [[TTSPlayer shareInstance] play:self.mTextView.text playMode:TTS_DEFAULT];
        }
    }

}
#pragma mark - ttsEnd
- (void)ttsPlayEnd
{
    [self.speakBtn setImage:[UIImage imageNamed:@"Route-voice-on"] forState:UIControlStateNormal];
}
#pragma mark - popViewDelegate
- (void)routeNavAction:(int)index withType:(int)type
{
    
}
#pragma mark - gmScrollerViewDelegate
- (void)gmScrollerViewAction:(int)index
{
    [self setContent:index];
    pageControl.currentPage = index;
    [self.mScrollerView setContentOffset:CGPointMake(index * 320, 0) animated:YES];
    [self speakNew];
}
#pragma mark- ScrollerViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offSet = scrollView.contentOffset.x;
    int currentPage = offSet / 320;
    pageControl.currentPage = currentPage;
    gmScrollerView.selectedIndex = currentPage;
    [self speakNew];
    [self setContent:currentPage];
}


- (void)updateLanguage:(id)sender
{
    
}
- (void)callBackToUI:(HttpBaseResponse *)response
{
    switch (response.cc_cmd_code)
    {
        case CC_DOWN_IMAGE_SPOT:
        {
            if(response.error_code == E_HTTPSUCCEES)
            {
                DwonImgResponse *res = (DwonImgResponse*)response;
                for (int i = 0;i < self.data.count; i++)
                {
                    ZS_CustomizedSpot_entity *entity = [self.data objectAtIndex:i];
                    if(res.imgID != entity.ID)continue;
                    UIImageView *imageView = (UIImageView*)[self.mScrollerView viewWithTag:i + 1000];
                    if(imageView)
                    {
                        UIImage *image = [[NetFileLoadManager sharedInstanced] loadImageByURL:entity.SpotImgUrl withDelegate:self withID:entity.ID withImgName:entity.SpotImgName withCmdcode:CC_DOWN_IMAGE_SPOT];
                        if(image)
                        {
                            [imageView setImage:image];
                            UIActivityIndicatorView *loadingView = (UIActivityIndicatorView *)[imageView viewWithTag:i + 100];
                            if(loadingView)
                            [loadingView stopAnimating];
                        }
                        return;
                    }
                }
                
            }
            break;
        }
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    if([TTSPlayer shareInstance].delegate == self)
    {
        [[TTSPlayer shareInstance] stopVideo];
    }
    [[NetFileLoadManager sharedInstanced] cancelRequest:self];
    SAFERELEASE(_data)
    SAFERELEASE(gmScrollerView)
    SAFERELEASE(pageControl)
    [_mScrollerView release];
    [_mTextView release];
    [_mTour release];
    [_mBack release];
    [_speakBtn release];
    [super dealloc];
}
- (void)viewDidUnload
{
    [self setMScrollerView:nil];
    [self setMTextView:nil];
    [self setMTour:nil];
    [self setMBack:nil];
    [self setSpeakBtn:nil];
    [super viewDidUnload];
}
@end
