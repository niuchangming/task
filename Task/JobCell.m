//
//  JobCell.m
//  Task
//
//  Created by Niu Changming on 13/11/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import "JobCell.h"
#import "MDRadialProgressTheme.h"
#import "CommonUtils.h"
#import <QuartzCore/QuartzCore.h>

@implementation JobCell

@synthesize taskIV;
@synthesize taskNameLbl;
@synthesize expiredLbl;
@synthesize progressLbl;
@synthesize getBtn;
@synthesize job;
@synthesize delegate;

- (void)awakeFromNib {
    getBtn.layer.cornerRadius = 18.0;
    getBtn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)getBtnClicked:(id)sender {
    [delegate getBtnClickedWithJob: job];
}
@end
