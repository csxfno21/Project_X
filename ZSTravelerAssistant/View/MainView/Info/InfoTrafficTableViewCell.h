//
//  InfoTrafficTableViewCell.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-7-24.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoTrafficTableViewCell : UITableViewCell
{
    UIImageView *cellImgView;
    UILabel *cellTitle;
    UILabel *cellTime;
    UIImageView *cellGoAndBackImgView;
    UILabel *cellTrafficStart;
    UILabel *cellTrafficEnd;
    UILabel *cellContent;
    UIImageView *cellRigthArrow;
}
@property (nonatomic,retain) UIImageView *cellImgView;
@property (nonatomic,retain) UILabel *cellTitle;
@property (nonatomic,retain) UILabel *cellTime;
@property (nonatomic,retain) UIImageView *cellGoAndBackImgView;
@property (nonatomic,retain) UILabel *cellTrafficStart;
@property (nonatomic,retain) UILabel *cellTrafficEnd;
@property (nonatomic,retain) UILabel *cellContent;
@property (nonatomic,retain) UIImageView *cellRigthArrow;


-(void)setTitle:(NSString *)title;
-(void)setTime:(NSString *)time;
-(void)setTrafficStart:(NSString *)trafficStart withEnd:(NSString*)trafficStartEnd;
-(void)setContent:(NSString *)content;
@end
