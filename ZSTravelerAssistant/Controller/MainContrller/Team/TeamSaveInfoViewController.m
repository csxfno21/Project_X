//
//  TeamSaveInfoViewController.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-21.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "TeamSaveInfoViewController.h"

@interface TeamSaveInfoViewController ()

@end

@implementation TeamSaveInfoViewController

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
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismisskeyBoard:)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    [gesture release];
    [self.saveMyInfoBtn setBackgroundImage:[[UIImage imageNamed:@"Route-nav-pop-item-f.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10]forState:UIControlStateNormal];
    [self.lbName setPlaceholder:[Language stringWithName:MYNICK]];
    [self.lbWhere setPlaceholder:[Language stringWithName:WHEREFROM]];

    self.mScrollView.delegate = self;
    self.lbName.delegate = self;
    self.lbWhere.delegate = self;
    
    self.lbName.text = [Config getTeamSelfName];
    self.lbWhere.text = [Config getTeamSelfWhere];
    if ([[Config getTeamSelfSex] isEqualToString:@"GIRL"])
    {
        [self setSexisBoy:NO];
    }
    else
    {
        [self setSexisBoy:YES];
    }

}
- (IBAction)backAction:(id)sender
{
    [self dismisskeyBoard:sender];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dismisskeyBoard:(id)sender
{
    [self.lbName resignFirstResponder];
    [self.lbWhere resignFirstResponder];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView *touchView = touch.view;
    if([touchView isKindOfClass:[UIButton class]] || [touchView.superview isKindOfClass:[UITextField class]])
    {
        return NO;
    }
    return YES;
}

#pragma mark- UIScrollView delegate

#pragma mark- textfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGPoint newPoint = CGPointMake(0, 80);
    [self.mScrollView setContentOffset:newPoint animated:YES];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    CGPoint newPoint = CGPointMake(0, 0);
    [self.mScrollView setContentOffset:newPoint animated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.lbName)
    {
        [self.lbWhere becomeFirstResponder];
    }
    else if(textField == self.lbWhere)
    {
        [self dismisskeyBoard:nil];
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_topTitleImgView release];
    [_topTitleLabel release];
    [_backBtn release];
    [_backLabel release];
    [_saveMyInfoBtn release];
    [_imgCheckSexBoy release];
    [_imgCheckSexGirl release];
    [_lbName release];
    [_lbWhere release];
    [_mScrollView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTopTitleImgView:nil];
    [self setTopTitleLabel:nil];
    [self setBackBtn:nil];
    [self setBackLabel:nil];
    [self setSaveMyInfoBtn:nil];
    [self setImgCheckSexBoy:nil];
    [self setImgCheckSexGirl:nil];
    [self setLbName:nil];
    [self setLbWhere:nil];
    [self setMScrollView:nil];
    [super viewDidUnload];
}
- (IBAction)onChangeSexBoy:(id)sender
{
    [self setSexisBoy:YES];
}

- (IBAction)onChangeSexGirl:(id)sender
{
    [self setSexisBoy:NO];
}
-(void)setSexisBoy:(BOOL)isBoy
{
    self.imgCheckSexBoy.hidden = !isBoy;
    self.imgCheckSexGirl.hidden = isBoy;
}
- (IBAction)onSaveInfo:(id)sender
{
    [Config setTeamSelfName:self.lbName.text];
    [Config setTeamSelfWhere:self.lbWhere.text];
    NSString* sex = nil;
    if (self.imgCheckSexBoy.hidden == YES)
    {
        [Config setTeamSelfSex:@"1"];
        sex = @"1";
    }
    else
    {
        [Config setTeamSelfSex:@"0"];
        sex = @"0";
    }
    [[TeamManager sharedInstanced] teamRequestModifyInfo:self.lbName.text withSex:sex withWhere:self.lbWhere.text];
    [self dismisskeyBoard:sender];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
