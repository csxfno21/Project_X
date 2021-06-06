//
//  gatherCalloutView.h
//  MapViewDemo
//
//  Created by 梁谢超 on 13-11-14.
//
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>

@protocol GatherTeamBtnDelegate <NSObject>
- (void) gatherTeamAtPoint:(AGSPoint*)location;
@end

@interface gatherTemplate : NSObject<AGSInfoTemplateDelegate>
{

}
@end


@interface GatherCalloutView : UIView
{
    id<GatherTeamBtnDelegate> delegate;
}
@property(nonatomic,retain)UILabel *title;
@property(nonatomic,retain)UIButton *btn;
@property(nonatomic,retain)AGSPoint *location;
@property(nonatomic,assign)id<GatherTeamBtnDelegate> delegate;
@end
