//
//  LoadingTableView.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-15.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "LoadingTableView.h"
#import <QuartzCore/QuartzCore.h>


@implementation LoadingTableView
@synthesize refreshFooterView, refreshLabel, refreshArrow, refreshSpinner, hasMore;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupStrings];
    }
    return self;
}
- (void)setupStrings
{
    textPull    = [Language stringWithName:PULL_REFUSH];
    textRelease = [Language stringWithName:DOWN_REFUSH];
    textLoading = [Language stringWithName:ISLOADING];
    textNoMore  = [Language stringWithName:NODATA];
    hasMore = YES;
}
-(void)addPullToRefreshFooter
{
    
    refreshFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height+20, 320, REFRESH_HEADER_HEIGHT)];
    refreshFooterView.backgroundColor = [UIColor clearColor];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = UITextAlignmentCenter;
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
                                    (floorf(REFRESH_HEADER_HEIGHT - 24) / 2),
                                    17, 30);
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshFooterView addSubview:refreshLabel];
    [refreshFooterView addSubview:refreshArrow];
    [refreshFooterView addSubview:refreshSpinner];
    [self addSubview:refreshFooterView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (isLoading) return;
    isDragging = YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (isLoading && scrollView.contentOffset.y > 0)
    {
        // Update the content inset, good for section headers
        self.contentInset = UIEdgeInsetsMake(0, 0, REFRESH_HEADER_HEIGHT, 0);
    }else if(!hasMore)
    {
        refreshLabel.text = textNoMore;
        refreshArrow.hidden = YES;
    }else if (isDragging && scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentInset.bottom) <= 0 )
    {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        refreshArrow.hidden = NO;
        if (scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentInset.bottom) <= -REFRESH_HEADER_HEIGHT)
        {
            // User is scrolling above the header
            refreshLabel.text = textRelease;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } else
        { // User is scrolling somewhere within the header
            refreshLabel.text = textPull;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
        [UIView commitAnimations];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (isLoading || !hasMore) return;
    isDragging = NO;
    //上拉刷新
    if(scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentInset.bottom) <= -REFRESH_HEADER_HEIGHT && scrollView.contentOffset.y > 0)
    {
        [self startLoading];
    }
}

- (void)startLoading
{
    isLoading = YES;
    
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    refreshLabel.text = textLoading;
    refreshArrow.hidden = YES;
    [refreshSpinner startAnimating];
    [UIView commitAnimations];
    
    // Refresh action!
    [self refresh];
}
- (void)stopLoading
{
    isLoading = NO;
    
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    self.contentInset = UIEdgeInsetsZero;
    UIEdgeInsets tableContentInset = self.contentInset;
    tableContentInset.top = 0.0;
    self.contentInset = tableContentInset;
    [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    [UIView commitAnimations];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    
    refreshLabel.text = textPull;
    refreshArrow.hidden = NO;
    [self reloadData];
    if(self.contentSize.height > self.frame.size.height + 20)
    {
        [refreshFooterView setFrame:CGRectMake(0, self.contentSize.height, 320, 0)];
    }
    
    
    [refreshSpinner stopAnimating];
    
}

- (void)refresh
{
    //TODO
    
    
}

- (void)dealloc
{
    SAFERELEASE(refreshFooterView)
    SAFERELEASE(refreshLabel)
    SAFERELEASE(refreshArrow)
    SAFERELEASE(refreshSpinner)
    
    [super dealloc];
}
@end
