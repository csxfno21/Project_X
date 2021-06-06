//
//  InfoLinestateCell.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-11-5.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoLinestateCell : UITableViewCell

@property (nonatomic, retain) UILabel *lineLabel;

-(void)setLineText:(NSString *)str;
@end
