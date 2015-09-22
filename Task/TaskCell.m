//
//  TaskCell.m
//  Task
//
//  Created by Niu Changming on 22/8/15.
//  Copyright (c) 2015 Ekoo Lab. All rights reserved.
//

#import "TaskCell.h"

@implementation TaskCell

@synthesize delegate;
@synthesize task;

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.contentView.translatesAutoresizingMaskIntoConstraints = YES;
}

- (IBAction)addBtnClicked:(id)sender {
    [delegate addJobBtnClicked:task];
}

@end
