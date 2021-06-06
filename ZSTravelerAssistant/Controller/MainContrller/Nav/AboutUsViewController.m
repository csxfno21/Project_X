//
//  AboutUsViewController.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-10.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.topTitleLabel.text = [Language stringWithName:ABOUT];
    self.backLabel.text = [Language stringWithName:BACK];
    self.middleZSLabel.text = [Language stringWithName:ZSTRAVELERASSISTANT];
    self.bottomZSLabel.text = [Language stringWithName:ZSTRAVELERASSISTANT];
    self.IphoneVersionLabel.text = [NSString stringWithFormat:@"Iphone %@",[PublicUtils version]];
    self.connectLabel.text = [Language stringWithName:CONNECT_WAY];
    self.copiesRightLabel.text = [Language stringWithName:COPYRIGHT];
}
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
