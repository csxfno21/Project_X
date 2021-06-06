//
//  InfoLineViewController.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-7-30.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "InfoLineViewController.h"

#define CELLHIGHT 30

@interface InfoLineViewController ()

@end

@implementation InfoLineViewController
@synthesize startptnLabel,endptnLabel,goAndBackImgView;

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
    // Do any additional setup after loading the view from its nib.
    
    NSArray *array = [self.entity.TrafficDetail componentsSeparatedByString:@"-"];
    if(array.count > 1)
    {
        startptnLabel.text = [array objectAtIndex:0];
        endptnLabel.text = [array lastObject];
    }
        
    CGSize sizeStart = [startptnLabel.text sizeWithFont:self.startptnLabel.font constrainedToSize:CGSizeMake(200, 25) lineBreakMode:NSLineBreakByWordWrapping];
    self.startptnLabel.frame = CGRectMake(self.startptnLabel.frame.origin.x , self.startptnLabel.frame.origin.y,sizeStart.width, 25);
    self.goAndBackImgView.frame = CGRectMake(self.startptnLabel.frame.size.width + self.startptnLabel.frame.origin.x + 3, self.goAndBackImgView.frame.origin.y, 20, 20);
    self.endptnLabel.numberOfLines = 0;
    CGSize sizeEnd = [endptnLabel.text sizeWithFont:self.startptnLabel.font constrainedToSize:CGSizeMake(200, 25) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize sizeLength = CGSizeMake(274 - sizeStart.width, 25);
    if (sizeEnd.width >= sizeLength.width)
    {
        self.endptnLabel.frame = CGRectMake(self.startptnLabel.frame.size.width + self.startptnLabel.frame.origin.x + 26, self.startptnLabel.frame.origin.y - 10, 274 - sizeStart.width, 50);
    }else
    {
        self.endptnLabel.frame = CGRectMake(self.startptnLabel.frame.size.width + self.startptnLabel.frame.origin.x + 26, self.startptnLabel.frame.origin.y, 274 - sizeStart.width, 25);
    }
    
    self.lineLabel.text = self.entity.TrafficName;
    self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",self.entity.TrafficStartTime,self.entity.TrafficEndTime];
    self.moneyLabel.text = self.entity.TrafficPrice;
    _lineContent.backgroundColor = [UIColor clearColor];
    
    explaBg = [[UIImageView alloc] init];
    explaContentLabel = [[UILabel alloc] init];
    explaContentLabel.font = [UIFont systemFontOfSize:13.0f];
    explaContentLabel.textColor = [UIColor blackColor];
    NSString *str;
    if ([self.entity.TrafficRemark isEqualToString:@"null"])
    {
        str = [Language stringWithName:NO_SPECIAL_TO_EXPLAIN];
    }
    else
    {
        str = self.entity.TrafficRemark;
    }
//    NSString *str = !ISEXISTSTR(self.entity.TrafficRemark) ? [Language stringWithName:NO_SPECIAL_TO_EXPLAIN]:self.entity.TrafficRemark;
    CGSize size = [str sizeWithFont:explaContentLabel.font constrainedToSize:CGSizeMake(280, 200) lineBreakMode:NSLineBreakByWordWrapping];
    explaBg.frame = CGRectMake(3, 180, 315, size.height + 20);
    [explaBg setImage:[UIImage imageNamed:@"info-cell-bg.png"]];
    explaBg.backgroundColor = [UIColor clearColor];
    explaContentLabel.frame = CGRectMake(50, 10, size.width , size.height);
    explaContentLabel.text = str;
    explaContentLabel.numberOfLines = 0;
    explaLabel = [[UILabel alloc]init];
    explaLabel.textColor = [UIColor blackColor];
    explaLabel.font = [UIFont systemFontOfSize:13.0f];
    explaLabel.frame = CGRectMake(10, 10, 30, size.height);
    explaLabel.text = [Language stringWithName:STATE];
    [explaBg addSubview:explaContentLabel];
    [explaBg addSubview:explaLabel];
    [self.view addSubview:explaBg];
    
    lineMarkLabel = [[UILabel alloc]init];
    lineExplaLabel = [[UILabel alloc]init];
    NSString *data = self.entity.TrafficDetail;
    arrayFromString = [[NSMutableArray alloc] init];
    [arrayFromString addObjectsFromArray:[data componentsSeparatedByString:@"-"]];
    lineExplaLabel.text = [Language stringWithName:STATE];
    lineMarkLabel.textColor = [UIColor blackColor];
    lineMarkLabel.font = [UIFont systemFontOfSize:13.0f];
    lineMarkLabel.text = [Language stringWithName:LINE_STATE];
    lineMarkLabel.backgroundColor = [UIColor clearColor];
    
    //下面路线说明用UIScrollView + tableView 组合显示
    m_InfoLinestateTableView.showsVerticalScrollIndicator = NO;
    lineExplaLabel.frame = CGRectMake(10, 215, 50, 40);
    lineMarkLabel.frame = CGRectMake(60, 215, 200, 40);
    [self.view addSubview:lineExplaLabel];
    [self.view addSubview:lineMarkLabel];
    [self.topTitle setText:[Language stringWithName:ROOT_PAGE_ONE_TITLE]];
    [self.backLabel setText:[Language stringWithName:BACK]];
}

#pragma mark- tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    m_InfoLinestateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return arrayFromString.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELLHIGHT;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    InfoLinestateCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[[InfoLinestateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setLineText:[NSString stringWithFormat:@"%d %@",indexPath.row + 1,[arrayFromString objectAtIndex:indexPath.row]]];
    
    return cell;
}


#pragma mark- updateLanguage
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
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    SAFERELEASE(arrayFromString)
    [_topImgView release];
    [_topTitle release];
    [_backBtn release];
    [_backLabel release];
    [_lineContent release];
    [_lineLabel release];
    [_timeLabel release];
    [startptnLabel release];
    [endptnLabel release];
    [_ticketLabel release];
    [_moneyLabel release];
    [_runtimeLabel release];
    [goAndBackImgView release];
    SAFERELEASE(explaContentLabel)
    SAFERELEASE(explaLabel)
    SAFERELEASE(explaBg)
    SAFERELEASE(lineMarkLabel)
    SAFERELEASE(lineExplaLabel)
    [m_ScrollView release];
    [m_InfoLinestateTableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTopImgView:nil];
    [self setTopTitle:nil];
    [self setBackBtn:nil];
    [self setBackLabel:nil];
    [self setLineContent:nil];
    [self setLineLabel:nil];
    [self setTimeLabel:nil];
    [self setStartptnLabel:nil];
    [self setEndptnLabel:nil];
    [self setTicketLabel:nil];
    [self setMoneyLabel:nil];
    [self setRuntimeLabel:nil];
    [self setGoAndBackImgView:nil];
    [m_ScrollView release];
    m_ScrollView = nil;
    [m_InfoLinestateTableView release];
    m_InfoLinestateTableView = nil;
    [super viewDidUnload];
}
@end
