//
//  InfoTrafficTableViewCell.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-7-24.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "InfoTrafficTableViewCell.h"

@implementation InfoTrafficTableViewCell
@synthesize cellTitle,cellTime,cellGoAndBackImgView,cellTrafficStart,cellTrafficEnd,cellContent;
@synthesize cellImgView,cellRigthArrow;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *tmpImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
        self.cellImgView = tmpImgView;
        [tmpImgView setImage:[UIImage imageNamed:@"info-cell-bg.png"]];
        [tmpImgView release];
        [self addSubview:tmpImgView];
        
        UILabel *tmpTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 15)];
        tmpTitle.textColor = [UIColor blueColor];
        tmpTitle.backgroundColor = [UIColor clearColor];
        tmpTitle.font = [UIFont boldSystemFontOfSize:14];
        self.cellTitle = tmpTitle;
        [self addSubview:tmpTitle];
        [tmpTitle release];
        
        UILabel *tmpTime = [[UILabel alloc]initWithFrame:CGRectMake(200, 10, 70, 15)];
        tmpTime.textColor = [UIColor orangeColor];
        tmpTime.backgroundColor = [UIColor clearColor];
        tmpTime.font = [UIFont systemFontOfSize:12];
        self.cellTime = tmpTime;
        [self addSubview:tmpTime];
        [tmpTime release];
        
        UIImageView *tmpGoAndBackImgView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 30, 20, 20)];
        [tmpGoAndBackImgView setImage:[UIImage imageNamed:@"info-cell_line.png"]];
        self.cellGoAndBackImgView = tmpGoAndBackImgView;
        [tmpGoAndBackImgView release];
        [self addSubview:tmpGoAndBackImgView];
        
        UILabel *tmpTrafficStart = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 90, 25)];
        tmpTrafficStart.textColor = [UIColor blackColor];
        tmpTrafficStart.backgroundColor = [UIColor clearColor];
        tmpTrafficStart.font = [UIFont boldSystemFontOfSize:15];
        self.cellTrafficStart = tmpTrafficStart;
        [self addSubview:tmpTrafficStart];
        [tmpTrafficStart release];
        
        UILabel *tmpTrafficEnd = [[UILabel alloc]initWithFrame:CGRectMake(120, 27, 60, 25)];
        tmpTrafficEnd.textColor = [UIColor blackColor];
        tmpTrafficEnd.numberOfLines = 0;
        tmpTrafficEnd.backgroundColor = [UIColor clearColor];
        tmpTrafficEnd.font = [UIFont boldSystemFontOfSize:15];
        self.cellTrafficEnd = tmpTrafficEnd;
        [self addSubview:tmpTrafficEnd];
        [tmpTrafficEnd release];
        
        UILabel *tmpContent = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 270, 30)];
        tmpContent.textColor = [UIColor blackColor];
        tmpContent.backgroundColor = [UIColor clearColor];
        tmpContent.font = [UIFont systemFontOfSize:10];
        tmpContent.numberOfLines = 0;
        self.cellContent = tmpContent;
        [self addSubview:tmpContent];
        [tmpContent release];
        
        UIImageView *tmpArrow = [[UIImageView alloc] initWithFrame:CGRectMake(275, 50, 18, 18)];
        [tmpArrow setImage:[UIImage imageNamed:@"info-cell-arr.png"]];
        self.cellRigthArrow = tmpArrow;
        [self addSubview:tmpArrow];
        SAFERELEASE(tmpArrow)

        
    }
    return self;
}

-(void)setTitle:(NSString *)title
{
    self.cellTitle.text = title;
}
-(void)setTime:(NSString *)time
{
    self.cellTime.text = time;
}
-(void)setTrafficStart:(NSString *)trafficStart withEnd:(NSString*)trafficStartEnd
{
    self.cellTrafficStart.text = trafficStart;
    self.cellTrafficEnd.text = trafficStartEnd;
    
    CGSize sizeStart = [trafficStart sizeWithFont:self.cellTrafficStart.font constrainedToSize:CGSizeMake(200, 25) lineBreakMode:NSLineBreakByWordWrapping];
    self.cellTrafficStart.frame = CGRectMake(self.cellTrafficStart.frame.origin.x, self.cellTrafficStart.frame.origin.y, sizeStart.width, sizeStart.height);
    
    self.cellGoAndBackImgView.frame = CGRectMake(self.cellTrafficStart.frame.size.width + self.cellTrafficStart.frame.origin.x + 3, self.cellGoAndBackImgView.frame.origin.y, 20, 20);
    self.cellTrafficEnd.frame = CGRectMake(self.cellTrafficStart.frame.size.width + self.cellTrafficStart.frame.origin.x + 26, self.cellTrafficEnd.frame.origin.y, 260 - sizeStart.width, 25);
}
-(void)setContent:(NSString *)content
{
    self.cellContent.text = content;
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc
{
    [cellImgView release];
    [cellTitle release];
    [cellTime release];
    [cellGoAndBackImgView release];
    [cellTrafficStart release];
    [cellTrafficEnd release];
    [cellContent release];
    [super dealloc];
}
@end
