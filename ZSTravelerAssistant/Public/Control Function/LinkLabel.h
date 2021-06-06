//
//  LinkLabel.h
//  Showcase
//
//  Created by  on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LinkLabel;
@protocol LinkLabelDelegate <NSObject>
@required

- (void)linkLabelTouche:(LinkLabel *)label touchesWtihTag:(NSInteger)tag;

@end

@interface LinkLabel : UILabel
{
    id <LinkLabelDelegate> delegate;
}
@property (nonatomic, assign) id <LinkLabelDelegate> delegate;

@end
