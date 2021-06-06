//
//  SetTableViewCell.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-9.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "SetTableViewCell.h"

@implementation SetTableViewCell
@synthesize delegate;
@synthesize picImageView,contentLabel,slider,numberLabel,onOffSwitch,controlImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UIImageView *tmpImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 30, 30)];
        tmpImgView.backgroundColor = [UIColor clearColor];
        self.picImageView = tmpImgView;
        [self addSubview:tmpImgView];
        SAFERELEASE(tmpImgView)
        
        UILabel *tmpContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 15, 90, 20)];
        tmpContentLabel.backgroundColor = [UIColor clearColor];
        tmpContentLabel.textColor = [UIColor blackColor];
        tmpContentLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        self.contentLabel = tmpContentLabel;
        [self addSubview:tmpContentLabel];
        SAFERELEASE(tmpContentLabel)
        
        UILabel *tmpNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 15, 30, 20)];
        tmpNumberLabel.textColor = [UIColor blackColor];
        tmpNumberLabel.font = [UIFont systemFontOfSize:13.0f];
        tmpNumberLabel.backgroundColor = [UIColor clearColor];
        self.numberLabel = tmpNumberLabel;
        [self addSubview:tmpNumberLabel];
        SAFERELEASE(tmpNumberLabel)

        
        UISwitch *tmpSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(220, 15, 70, 30)];
        tmpSwitch.backgroundColor = [UIColor clearColor];
        tmpSwitch.hidden = YES;
        tmpSwitch.enabled = NO;
        [tmpSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        self.onOffSwitch = tmpSwitch;
        [self addSubview:tmpSwitch];
        SAFERELEASE(tmpSwitch)
        
        UISlider *tmpSlider = [[UISlider alloc]initWithFrame:CGRectMake(180, 15, 120, 10)];
        tmpSlider.backgroundColor = [UIColor clearColor];
        tmpSlider.hidden = YES;
        tmpSlider.enabled = NO;
        [tmpSlider addTarget:self action:@selector(sliderActio:) forControlEvents:UIControlEventValueChanged];
        self.slider = tmpSlider;
        [self addSubview:tmpSlider];
        SAFERELEASE(tmpSlider)
        
        UIImageView *tmpControlImageView = [[UIImageView alloc]initWithFrame:CGRectMake(275, 12, 25, 25)];
        tmpControlImageView.backgroundColor = [UIColor clearColor];
        tmpControlImageView.hidden = YES;
        self.controlImageView = tmpControlImageView;
        [self addSubview:tmpControlImageView];
        SAFERELEASE(tmpControlImageView)
        
    }
    return self;
}

- (void)switchAction:(id)sender
{
    UISwitch *switchView = (UISwitch *)sender;
    if(delegate && [delegate respondsToSelector:@selector(setTableViewCellAction:withOpen:)])
    {
        [delegate setTableViewCellAction:self withOpen:switchView.isOn];
    }
}
- (void)sliderActio:(id)sender
{
    UISlider *sli = (UISlider*)sender;
    if(delegate && [delegate respondsToSelector:@selector(setTableViewCellAction:withValue:)])
    {
        [delegate setTableViewCellAction:self withValue:sli.value];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc
{
    delegate = nil;
    SAFERELEASE(onOffSwitch)
    SAFERELEASE(contentLabel)
    SAFERELEASE(picImageView)
    SAFERELEASE(slider)
    SAFERELEASE(numberLabel)
    SAFERELEASE(controlImageView)
    [super dealloc];
}
@end
