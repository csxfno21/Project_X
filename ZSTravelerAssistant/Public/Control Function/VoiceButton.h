//
//  VoiceButton.h
//  Tourism
//
//  Created by csxfno21 on 13-4-13.
//  Copyright (c) 2013年 szmap. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum 
{
    OPEN = 0,
    END,
    CLOSE
}VoiceState;
@protocol VoiceButtonDelegate <NSObject>

- (void)voiceButtonClick:(VoiceState)voiceState;

@end
@interface VoiceButton : UIButton
{
    UIImageView  *animView;
    id<VoiceButtonDelegate> delegate;
}
@property(nonatomic,readonly)VoiceState state;
@property(nonatomic,assign)id<VoiceButtonDelegate> delegate;
- (void)switchVoiceButton;
- (BOOL)isOpen;
@end
