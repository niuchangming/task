//
//  InsetTextField.m
//  KinTub
//
//  Created by Niu Changming on 5/3/15.
//  Copyright (c) 2015 ekoo lab. All rights reserved.
//

#import "InsetTextField.h"

@implementation InsetTextField

- (CGRect)textRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds, 40.0f, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    return [self textRectForBounds:bounds];
}

@end
