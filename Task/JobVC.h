//
//  JobVCViewController.h
//  Task
//
//  Created by Niu Changming on 13/11/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobCell.h"

@interface JobVC : UIViewController<UITableViewDataSource, UITableViewDelegate, JobCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *jobTb;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingJobBar;


@property (strong, nonatomic) NSMutableArray *jobs;

@end
