//
//  SOSTableViewCell.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-7.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "SOSTableViewCell.h"

@implementation SOSTableViewCell
@synthesize imgView,alarmLabel,contentLabel,phoneNumLabel,numberLabel;
@synthesize celldelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UIImageView *tmpImgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 30, 30)];
        tmpImgView.backgroundColor = [UIColor clearColor];
        self.imgView = tmpImgView;
        [self addSubview:tmpImgView];
        SAFERELEASE(tmpImgView)
        
        UILabel *tmpContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 15, 90, 20)];
        tmpContentLabel.backgroundColor = [UIColor clearColor];
        tmpContentLabel.textColor = [UIColor blackColor];
        tmpContentLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        self.contentLabel = tmpContentLabel;
        [self addSubview:tmpContentLabel];
        SAFERELEASE(tmpContentLabel)
        
        UILabel *tmpAlarmLabel = [[UILabel alloc]initWithFrame:CGRectMake(210, 15, 60, 20)];
        tmpAlarmLabel.backgroundColor = [UIColor clearColor];
        tmpAlarmLabel.textColor = [UIColor blueColor];
        tmpAlarmLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        tmpAlarmLabel.hidden = NO;
        self.alarmLabel = tmpAlarmLabel;
        [self addSubview:tmpAlarmLabel];
        SAFERELEASE(tmpAlarmLabel)
        
    
        LinkLabel *tmpPhoneNumberLabel = [[LinkLabel alloc]initWithFrame:CGRectMake(180, 15, 150, 20)];
        tmpPhoneNumberLabel.tag = self.tag;
        tmpPhoneNumberLabel.delegate = self;
        tmpPhoneNumberLabel.backgroundColor = [UIColor clearColor];
        tmpPhoneNumberLabel.textColor = [UIColor blueColor];
        tmpPhoneNumberLabel.font = [UIFont systemFontOfSize:15.0f];
        tmpPhoneNumberLabel.hidden = NO;
        self.phoneNumLabel = tmpPhoneNumberLabel;
        [self addSubview:tmpPhoneNumberLabel];
        SAFERELEASE(tmpPhoneNumberLabel)
    }
    return self;
}
#pragma mark - linkLabel Delegate
-(void)linkLabelTouche:(LinkLabel *)label touchesWtihTag:(NSInteger)tag
{
   //
    if (celldelegate && [celldelegate respondsToSelector:@selector(sOSCellAction:)])
    {
        [celldelegate sOSCellAction:self.tag];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)dealloc
{
    SAFERELEASE(imgView)
    SAFERELEASE(alarmLabel)
    SAFERELEASE(phoneNumLabel)
    [super dealloc];
}
@end
