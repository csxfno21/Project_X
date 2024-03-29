//
//  TeamServiceViewController.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-12.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "BaseViewController.h"
#import "TeamSaveInfoViewController.h"
#import "TeamFriendShowViewController.h"
#import "TeamInfoCell.h"
#import "LoadingTableView.h"
#import "TeamManagerDelegate.h"

@interface TeamServiceViewController : BaseViewController<UIGestureRecognizerDelegate,UIScrollViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,
    UISearchBarDelegate,TeamInfoCellDelegate,TeamManagerDelegate>
{
    BOOL firstUIisHidden;
    BOOL displayTableHidden;
    BOOL currentTable;  //NO self.searchDisplayController.searchResultsTableView   YES self.mTeamDisplayTableView
    UITapGestureRecognizer *gesture;
    
    NSMutableArray        *data;
    NSMutableArray *filteredListContent;
    NSString       *savedSearchTerm;
    NSInteger      savedScopeButtonIndex;
    BOOL           searchWasActive;
    UIActivityIndicatorView *loadingView;
    int selectIndex;
    
}
@property (retain, nonatomic) IBOutlet UIImageView *topTitleImgView;
@property (retain, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (retain, nonatomic) IBOutlet UIButton *backBtn;
@property (retain, nonatomic) IBOutlet UILabel *backLabel;
@property (retain, nonatomic) IBOutlet UIImageView *teamServiceImgView;
@property (retain, nonatomic) IBOutlet UITextField *nameTextFiled;
@property (retain, nonatomic) IBOutlet UITextField *pwordTextFiled;
@property (retain, nonatomic) IBOutlet UIButton *createTeamBtn;
@property (retain, nonatomic) IBOutlet UIButton *joinTeamBtn;
@property (retain, nonatomic) IBOutlet UIScrollView *mScrollerView;

@property (retain, nonatomic) IBOutlet UIButton *animationBtn;
@property (retain, nonatomic) IBOutlet UISearchBar *mSearchBar;
@property (retain, nonatomic) IBOutlet UITableView *mTeamDisplayTableView;
@property (retain, nonatomic) IBOutlet UIButton *mRefresh;
@property (retain, nonatomic) NSMutableArray  *data;
@property (retain, nonatomic) NSMutableArray *filteredListContent;
@property (nonatomic, copy)   NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

@property (retain, nonatomic) IBOutlet UISearchDisplayController *mSearchDisplayController;
@end
