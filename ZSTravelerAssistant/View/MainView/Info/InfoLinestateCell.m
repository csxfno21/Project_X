//
//  InfoLinestateCell.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-11-5.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "InfoLinestateCell.h"

@implementation InfoLinestateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UILabel *tmpLabel = [[UILabel alloc] init];
        tmpLabel.textColor = [UIColor blackColor];
        tmpLabel.font = [UIFont systemFontOfSize:13.0f];
        self.lineLabel = tmpLabel;
        [self addSubview:tmpLabel];
        SAFERELEASE(tmpLabel)
    }
    return self;
}

-(void)setLineText:(NSString *)str
{
    CGSize size = [str sizeWithFont:self.lineLabel.font constrainedToSize:CGSizeMake(300, 20) lineBreakMode:NSLineBreakByCharWrapping];
    self.lineLabel.frame = CGRectMake(10, 5, size.width, size.height);
    self.lineLabel.text = str;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)dealloc
{
    [_lineLabel release];
    [super dealloc];
}
@end
