//
//  MyselfChatCell.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-11-4.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTEmotionView.h"



@protocol MyselfChatCellDelegate <NSObject>

-(void)reSendMessage:(NSString *)emotionString;
-(void)location;

@end

@interface MyselfChatCell : UITableViewCell
{
    id<MyselfChatCellDelegate> delegate;
}
@property (assign ,nonatomic) id<MyselfChatCellDelegate> delegate;
@property (retain ,nonatomic) UIImageView *headImgView;
@property (retain ,nonatomic) UIImageView *chatBackgroundImgView;
@property (retain ,nonatomic) HTEmotionView     *chatContentLabel;
@property (retain ,nonatomic) UIButton    *warningBtn;
@property (strong, nonatomic) UIActivityIndicatorView *refreshSpinner;
@property (retain ,nonatomic) UIButton    *locationBtn;

-(void)setHeadImage:(NSString *)image;
-(void)setChatContentText:(NSString *)chatContent;
-(void)setChatContentImageWithPoint:(CLLocationCoordinate2D)point;
@end
