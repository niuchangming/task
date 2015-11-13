//
//  JobCell.h
//  Task
//
//  Created by Niu Changming on 13/11/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *taskIV;
@property (weak, nonatomic) IBOutlet UIProgressView *jobProgressBar;
@property (weak, nonatomic) IBOutlet UILabel *taskNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *rewardLbl;
@property (weak, nonatomic) IBOutlet UILabel *expiredLbl;
@property (weak, nonatomic) IBOutlet UILabel *progressValue;

@end
