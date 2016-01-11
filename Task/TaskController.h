//
//  ViewController.h
//  Task
//
//  Created by Niu Changming on 16/8/15.
//  Copyright (c) 2015 Ekoo Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskCell.h"
#import "PFNavigationDropdownMenu.h"
#import "DJRefresh.h"

@interface TaskController : UIViewController<UITableViewDataSource, UITableViewDelegate, PFNavigationDropdownMenuDelegate, DJRefreshDelegate>

@property (nonatomic, strong) NSMutableArray *tasks;

@property (nonatomic, strong) NSMutableArray *tags;

@property (weak, nonatomic) IBOutlet UITableView *taskTV;
@property (weak, nonatomic) IBOutlet UILabel *selectedTagLbl;
@property (strong, nonatomic) PFNavigationDropdownMenu *menuView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingBar;
@property (strong, nonatomic) DJRefresh *refresh;


@end

