//
//  TaskDetailInfoView.h
//  Task
//
//  Created by Niu Changming on 30/8/15.
//  Copyright (c) 2015 Ekoo Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskDetailInfoView : UIView
@property (weak, nonatomic) IBOutlet UILabel *taskTitleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *companyLogo;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLbl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *contentSegment;

@end
