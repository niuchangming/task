//
//  JobCell.m
//  Task
//
//  Created by Niu Changming on 13/11/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import "JobCell.h"

@implementation JobCell

@synthesize taskIV;
@synthesize jobProgressBar;
@synthesize taskNameLbl;
@synthesize rewardLbl;
@synthesize expiredLbl;
@synthesize progressValue;

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
