//
//  ShopDetialViewController.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-21.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "DetialViewController.h"

@interface DetialViewController ()

@end

@implementation DetialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationLabel.numberOfLines = 0;
    self.manageLabel.text = [Language stringWithName:BUSINESS];
    self.backLabel.text = [Language stringWithName:BACK];
    [self.backgroundImgview3 setImage:[[UIImage imageNamed:@"info-cell-bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    self.rangeLabel.numberOfLines = 0;
    if(self.entity)
    {
        self.topTitleLabel.text = self.entity.NavTitle;
        self.techanLabel.text = self.entity.NavTitle;
        self.smallTechanLabel.text = self.entity.NavRemark;
        self.locationLabel.text = self.entity.NavPosition;
        self.rangeLabel.text = self.entity.NavContent;
        UIImage *image = [[NetFileLoadManager sharedInstanced] loadImageByURL:[NSString stringWithFormat:@"%@/ImageFile/poi/%@.jpg",SERVER_IP,self.entity.NavIID] withDelegate:self withID:self.entity.ID withImgName:self.entity.NavIID withCmdcode:CC_DOWN_IMAGE_SPOT_SMALL];
        if (image)
        {
            self.techanImgView.image = image;
            
        }
    }
}
#pragma mark - callBack
- (void)callBackToUI:(HttpBaseResponse *)response
{
    switch (response.cc_cmd_code)
    {
        case CC_DOWN_IMAGE_SPOT_SMALL:
        {
            if(response.error_code == E_HTTPSUCCEES)
            {
                DwonImgResponse *res = (DwonImgResponse*)response;
                if(res.imgID == self.entity.ID)
                {
                UIImage *image = [[NetFileLoadManager sharedInstanced] loadImageByURL:[NSString stringWithFormat:@"%@/ImageFile/poi/%@.jpg",SERVER_IP,self.entity.NavIID] withDelegate:self withID:self.entity.ID withImgName:self.entity.NavIID withCmdcode:CC_DOWN_IMAGE_SPOT_SMALL];
                    if (image)
                    {
                        self.techanImgView.image = image;
                        
                    }
                }
            }
            break;
        }
        default:
            break;
    }
}
- (void)updateLanguage:(id)sender
{
    
}
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_topTitleImgView release];
    [_topTitleLabel release];
    [_backBtn release];
    [_backLabel release];
    [_techanImgView release];
    [_techanLabel release];
    [_smallTechanImgView release];
    [_smallTechanLabel release];
    [_separateLineImgViewOne release];
    [_separateLineImgViewTwo release];
    [_separateLineImgViewThree release];
    [_locationImgView release];
    [_locationLabel release];
    [_manageLabel release];
    [_rangeLabel release];
    [_backgroundImgview1 release];
    [_backgroundImgview2 release];
    [_backgroundImgview3 release];
    [super dealloc];
}
- (void)viewDidUnload
{
    [self setTopTitleImgView:nil];
    [self setTopTitleLabel:nil];
    [self setBackBtn:nil];
    [self setBackLabel:nil];
    [self setTechanImgView:nil];
    [self setTechanLabel:nil];
    [self setSmallTechanLabel:nil];
    [self setSmallTechanLabel:nil];
    [self setSeparateLineImgViewOne:nil];
    [self setSeparateLineImgViewTwo:nil];
    [self setSeparateLineImgViewThree:nil];
    [self setLocationImgView:nil];
    [self setLocationLabel:nil];
    [self setManageLabel:nil];
    [self setRangeLabel:nil];
    [self setBackgroundImgview1:nil];
    [self setBackgroundImgview2:nil];
    [self setBackgroundImgview3:nil];
    [super viewDidUnload];
}
@end
