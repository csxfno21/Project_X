//
//  SetTableViewCell.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-9.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SetTableViewCellDelegate <NSObject>

- (void)setTableViewCellAction:(UITableViewCell*)cell withValue:(float)value;
- (void)setTableViewCellAction:(UITableViewCell*)cell withOpen:(BOOL)open;
@end
@interface SetTableViewCell : UITableViewCell
{
    UIImageView *picImageView;
    UILabel     *contentLabel;
    UISwitch    *onOffSwitch;
    UILabel     *numberLabel;
    UISlider    *slider;
    UIImageView *controlImageView;
    
    id<SetTableViewCellDelegate> delegate;
}
@property(nonatomic, assign)    id<SetTableViewCellDelegate> delegate;
@property(nonatomic, retain)    UIImageView *picImageView;
@property(nonatomic, retain)    UILabel     *contentLabel;
@property(nonatomic, retain)    UISwitch    *onOffSwitch;
@property(nonatomic, retain)    UILabel     *numberLabel;
@property(nonatomic, retain)    UISlider    *slider;
@property(nonatomic, retain)    UIImageView *controlImageView;


@end
