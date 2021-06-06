//
//  SetViewController.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-9.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "SetViewController.h"
#import "Config.h"
#import "MusicPlayManager.h"
#import <MediaPlayer/MediaPlayer.h>
#define CELLHIGHT 50.0f

@interface SetViewController ()

@end

@implementation SetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        dictionary = [[NSDictionary alloc]initWithObjects:
                      @[
                      @[[Language stringWithName:MAP_ROTATE],
                      [Language stringWithName:BACKGROUND_MUSIC],
                      [Language stringWithName:MEDIA_VOLUME],
                      [Language stringWithName:SCREEN_LUMINANCE]],
                      @[[Language stringWithName:ABOUT_US]]
                      ]
                                                  forKeys:
                      @[[Language stringWithName:QUICK_SET],
                      [Language stringWithName:SYSTEM_HELP]]];
        //,
        //[Language stringWithName:FUNCTION_HELP]  ,
        //[Language stringWithName:LANG_SWITCHER],
        //[Language stringWithName:VOICE_BROADCAST_SET]
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaValueChange:) name:NOTIFY_MEDIAVALUE_CHAGE object:nil];
    
    _topTitleLabel.text = [Language stringWithName:SET_AND_HELP];
    _backLabel.text = [Language stringWithName:BACK];
}
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dictionary.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELLHIGHT;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)]autorelease];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 20)];
    if (section == 0)
    {
        title.text = [Language stringWithName:QUICK_SET];
    }
    else if (section == 1)
    {
        title.text = [Language stringWithName:SYSTEM_HELP];
    }
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont boldSystemFontOfSize:15.0f];
    [view addSubview:title];
    [title autorelease];
    return view;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = @"";
    if (section == 0)
    {
        key = [Language stringWithName:QUICK_SET];
    }
    else if (section == 1)
    {
        key = [Language stringWithName:SYSTEM_HELP];
    }
    int number = [(NSArray*)[dictionary objectForKey:key] count];
    return number;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        AboutUsViewController *controller = [[AboutUsViewController alloc]initWithNibName:@"AboutUsViewController" bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
        SAFERELEASE(controller)
    }
    if (indexPath.section == 0 && indexPath.row == 4)
    {
        ;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    SetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    while (cell == nil)
    {
        cell = [[[SetTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.tag = indexPath.row;
    cell.delegate = self;
    NSString *key = @"";
    if (indexPath.section == 0)
    {
        key = [Language stringWithName:QUICK_SET];
        if (indexPath.row == 0 || indexPath.row == 1)
        {
            cell.onOffSwitch.hidden = NO;
            cell.onOffSwitch.enabled = YES;
            if(indexPath.row == 1)
            {
                if([Config isPlayBgmusic])
                {
                    cell.onOffSwitch.on = YES;
                }
                else
                {
                    cell.onOffSwitch.on = NO;
                }
            }
            else
            {
                if([Config isRotation])
                {
                    cell.onOffSwitch.on = YES;
                }
                else
                {
                    cell.onOffSwitch.on = NO;
                }
            }
        }
        if (indexPath.row == 4 || indexPath.row == 5)
        {
            cell.controlImageView.hidden = NO;
            cell.controlImageView.image = [UIImage imageNamed:@"right-arrow.png"];
        }
        if (indexPath.row == 2 || indexPath.row == 3)
        {
            if (indexPath.row == 2)
            {
                cell.slider.enabled = YES;
                MPMusicPlayerController *mpc = [MPMusicPlayerController applicationMusicPlayer];
                float value = [Config getMediaValue];
                if (value == -1)
                {
                    value = mpc.volume;
                }
                cell.slider.value = value;
                cell.numberLabel.text = [NSString stringWithFormat:@"%d",(int)(value * 100)];
            }
            else
            {
                if ([[PublicUtils systemVersion] floatValue] > 5.0)
                {
                    cell.slider.enabled = YES;
                    cell.slider.value = [Config getScreenLightValue];
                }
                else
                {
                    cell.slider.enabled = NO;
                    cell.slider.value = 0;
                }
                cell.numberLabel.text = [NSString stringWithFormat:@"%d",(int)([Config getScreenLightValue] * 100)];
                
            }
            cell.slider.hidden = NO;
        }
    }
    else if (indexPath.section == 1)
    {
        key = [Language stringWithName:SYSTEM_HELP];
        cell.controlImageView.hidden = NO;
        cell.controlImageView.image = [UIImage imageNamed:@"right-arrow.png"];
    }
    
    NSArray *array = [[NSArray alloc]initWithArray:[dictionary objectForKey:key]];
    cell.contentLabel.text = [array objectAtIndex:indexPath.row];
    if(indexPath.section == 0)
    {
        if (indexPath.row == 5)
        {
            cell.picImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"SetImg%d",indexPath.row]];
        }else
        {
            cell.picImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"SetImg%d",indexPath.row+1]];
        }
    }
    else if(indexPath.section == 1)
    {
        cell.picImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"SetImg%d",indexPath.row+6]];
    }
    [array release];
    return  cell;
}

#pragma mark - cell Delegate
- (void)setTableViewCellAction:(SetTableViewCell *)cell withOpen:(BOOL)open
{
    if(cell.tag == 0)
    {
        //地图
         [Config setRotation:open];
    }
    else if(cell.tag == 1)
    {
        //音乐
        [Config openBgMusic:open];
    }
}

- (void)setTableViewCellAction:(SetTableViewCell *)cell withValue:(float)value
{
    if (cell.tag == 2)
    {
        [Config setMediaValue:value];
        cell.numberLabel.text = [NSString stringWithFormat:@"%d",(int)(value * 100)];
        MPMusicPlayerController *mpc = [MPMusicPlayerController applicationMusicPlayer];
        mpc.volume = value; 
    }
    else if(cell.tag == 3)
    {
        [Config setScreenLightValue:value];
        cell.numberLabel.text = [NSString stringWithFormat:@"%d",(int)(value * 100)];
       [[UIScreen mainScreen] setBrightness:value];
    }
}

#pragma mark - mediaValueChange
- (void)mediaValueChange:(NSNotification*)noti
{
    SetTableViewCell *cell = (SetTableViewCell*)[self.mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    float value = [Config getMediaValue];
    cell.slider.value = value;
    cell.numberLabel.text = [NSString stringWithFormat:@"%d",(int)(value * 100)];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_MEDIAVALUE_CHAGE object:nil];
    [_topTitleImgView release];
    [_topTitleLabel release];
    [_backBtn release];
    [_backLabel release];
    [_mTableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTopTitleImgView:nil];
    [self setTopTitleLabel:nil];
    [self setBackBtn:nil];
    [self setBackLabel:nil];
    [self setMTableView:nil];
    [super viewDidUnload];
}
@end
