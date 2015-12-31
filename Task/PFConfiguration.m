//
//  PFConfiguration.m
//  PFNavigationDropdownMenu
//
//  Created by Cee on 02/08/2015.
//  Copyright (c) 2015 Cee. All rights reserved.
//

#import "PFConfiguration.h"

@implementation PFConfiguration
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setDefaultValue];
    }
    return self;
}

- (void)setDefaultValue
{    
    self.cellHeight = 44;
    self.cellBackgroundColor = [UIColor clearColor];
    self.cellTextLabelColor = [UIColor whiteColor];
    self.cellTextLabelFont = [UIFont fontWithName:@"HelveticaNeue" size:17];
    self.cellSelectionColor = [UIColor lightGrayColor];
    self.checkMarkImage = [UIImage imageNamed:@"checkmark.png"];
    self.animationDuration = 0.5;
    self.arrowImage = [UIImage imageNamed:@"arrow_down.png"];
    self.arrowPadding = 15;
    self.maskBackgroundColor = [UIColor blackColor];
    self.maskBackgroundOpacity = 0.3;
}
@end
