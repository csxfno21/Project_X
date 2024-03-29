//
//  PullUpRefreshViewController.h
//  Tourism
//
//  Created by csxfno21 on 13-4-8.
//  Copyright (c) 2013年 szmap. All rights reserved.
//

#import "BaseViewController.h"
#define REFRESH_HEADER_HEIGHT 52.0f
@interface PullUpRefreshViewController : BaseViewController
{
    UIView *refreshFooterView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
    UITableView *supertableView;
}
@property (nonatomic, strong) UIView *refreshFooterView;
@property (nonatomic, strong) UILabel *refreshLabel;
@property (nonatomic, strong) UIImageView *refreshArrow;
@property (nonatomic, strong) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, strong) NSString *textPull;
@property (nonatomic, strong) NSString *textRelease;
@property (nonatomic, strong) NSString *textLoading;
@property (nonatomic, strong) NSString *textNoMore;
@property (nonatomic) BOOL hasMore;

- (void)setupStrings;
-(void)addPullToRefreshFooter:(UITableView*)tbView;
- (void)startLoading;
- (void)stopLoading;
- (void)refresh;
@end
