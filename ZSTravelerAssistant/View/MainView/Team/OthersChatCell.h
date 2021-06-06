//
//  OthersChatCell.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-11-4.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTEmotionView.h"

@protocol OthersChatCellDelegate <NSObject>

-(void)othersLocation;

@end

@interface OthersChatCell : UITableViewCell
{
    id<OthersChatCellDelegate>  delegate;
}
@property (assign ,nonatomic) id<OthersChatCellDelegate>  delegate;
@property (retain ,nonatomic) UIImageView *headImgView;
@property (retain ,nonatomic) UIImageView *chatBackgroundImgView;
@property (retain ,nonatomic) HTEmotionView     *chatContentLabel;
@property (retain ,nonatomic) UILabel     *chatPeopleLabel;
@property (nonatomic, assign) BOOL        isSingleChat;
@property (retain ,nonatomic) UIButton    *locationBtn;

-(void)setHeadImage:(NSString *)image;
-(void)setChatContentText:(NSString *)chatContent;
-(void)setChatContentImageWithPoint:(CLLocationCoordinate2D )point;
-(void)setChatPeopleText:(NSString *)chatPeople;
@end
