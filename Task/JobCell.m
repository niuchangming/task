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

@implementation JobCell

@synthesize taskIV;
@synthesize taskNameLbl;
@synthesize expiredLbl;
@synthesize progressBar;
@synthesize comissionValueLbl;
@synthesize currencyLbl;

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
