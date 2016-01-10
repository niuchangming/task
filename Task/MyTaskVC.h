//
//  MyTaskVC.h
//  Task
//
//  Created by Niu Changming on 10/1/16.
//  Copyright © 2016 Ekoo Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "MyTask.h"

@interface MyTaskVC : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) User *user;

@property (weak, nonatomic) IBOutlet UITableView *taskTb;

@property (strong, nonatomic) NSMutableArray *tasks;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingBar;

@end
