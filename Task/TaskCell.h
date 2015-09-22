//
//  TaskCell.h
//  Task
//
//  Created by Niu Changming on 22/8/15.
//  Copyright (c) 2015 Ekoo Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@protocol TaskCellDelegate <NSObject>

@required
- (void) addJobBtnClicked:(Task *) task;

@end

@interface TaskCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarIV;
@property (weak, nonatomic) IBOutlet UILabel *taskNameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *taskIV;

@property (weak, nonatomic) IBOutlet UILabel *rewardLbl;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (strong, nonatomic) id<TaskCellDelegate> delegate;

@property (strong, nonatomic) Task *task;

- (IBAction)addBtnClicked:(id)sender;


@end
