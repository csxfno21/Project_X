//
//  RevolvingLabel.h
//  Tourism
//
//  Created by csxfno21 on 13-4-29.
//  Copyright (c) 2013年 szmap. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RevolvingLabel : UILabel
{
    BOOL  animing;
}
@property(nonatomic,assign)CGRect  oldFrame;
- (void)startAnim;
- (void)stopAnim;
@end
