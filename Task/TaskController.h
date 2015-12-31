//
//  ViewController.h
//  Task
//
//  Created by Niu Changming on 16/8/15.
//  Copyright (c) 2015 Ekoo Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskCell.h"

@interface TaskController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *tasks;

@property (weak, nonatomic) IBOutlet UITableView *taskTV;


@end

