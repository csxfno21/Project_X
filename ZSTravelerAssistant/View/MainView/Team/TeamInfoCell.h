//
//  TeamInfoCell.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-10-28.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTJoinTeamButton.h"

@protocol TeamInfoCellDelegate <NSObject>

-(void)teamInfoJoinAction:(int)index withCellTag:(int)tag;

@end

@interface TeamInfoCell : UITableViewCell
{
    id<TeamInfoCellDelegate> delegate;
}
@property (nonatomic, assign) id<TeamInfoCellDelegate> delegate;
@property (nonatomic, retain) UIImageView *picImgView;
@property (nonatomic, retain) UILabel     *teamNameLabel;
@property (nonatomic, retain) UIImageView *teamCreatorImgView;
@property (nonatomic, retain) UILabel     *teamCreatorLabel;
@property (nonatomic, retain) UIImageView *teamMatesCountImgView;
@property (nonatomic, retain) UILabel     *teamMatesCountLabel;
@property (nonatomic, retain) UIImageView *teamCreatedTimeImgView;
@property (nonatomic, retain) UILabel     *teamCreatedTimeLabel;
@property (nonatomic, retain) HTJoinTeamButton *joinTeamBtn;
@property(assign, nonatomic)BOOL bIsShow;

-(void)setTeamName:(NSString *)teamName withTeamCreater:(NSString *)teamCreator withTeamMatesCount:(NSString *)count;

@end
