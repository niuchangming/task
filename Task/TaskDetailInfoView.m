//
//  TaskDetailInfoView.m
//  Task
//
//  Created by Niu Changming on 30/8/15.
//  Copyright (c) 2015 Ekoo Lab. All rights reserved.
//

#import "TaskDetailInfoView.h"

@implementation TaskDetailInfoView

@synthesize companyLogo;
@synthesize companyNameLbl;
@synthesize taskTitleLbl;
@synthesize contentSegment;

-(id) init{
    self = [super self];
    if(self){
        self.companyLogo.layer.cornerRadius = 12;
        self.companyLogo.clipsToBounds = YES;
    }
    return self;
}

@end
