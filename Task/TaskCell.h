//
//  TaskCell.h
//  Task
//
//  Created by Niu Changming on 22/8/15.
//  Copyright (c) 2015 Ekoo Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"


@interface TaskCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *companyLogoIV;
@property (weak, nonatomic) IBOutlet UILabel *taskNameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *taskIV;

@property (weak, nonatomic) IBOutlet UILabel *companyNameLbl;

@property (strong, nonatomic) Task *task;

@end
