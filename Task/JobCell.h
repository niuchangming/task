//
//  JobCell.h
//  Task
//
//  Created by Niu Changming on 13/11/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDRadialProgressView.h"
#import "Job.h"

@protocol JobCellDelegate <NSObject>

@required
-(void) getBtnClickedWithJob: (Job *)job;

@end

@interface JobCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *taskIV;
@property (weak, nonatomic) IBOutlet UILabel *taskNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *expiredLbl;
@property (weak, nonatomic) IBOutlet UILabel *progressLbl;
@property (weak, nonatomic) IBOutlet UIButton *getBtn;
@property (weak, nonatomic) id<JobCellDelegate> delegate;

@property (strong, nonatomic) Job *job;

- (IBAction)getBtnClicked:(id)sender;


@end
