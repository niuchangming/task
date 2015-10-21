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
@synthesize task;
@synthesize infoWebView;

-(id) init{
    self = [super self];
    if(self){
        self.companyLogo.layer.cornerRadius = 12;
        self.companyLogo.clipsToBounds = YES;
    }
    return self;
}

- (IBAction)segmentChanged:(id)sender {
    NSString *htmlStr = @"";
    switch (self.contentSegment.selectedSegmentIndex) {
        case 0:
            htmlStr = task.desc;
            break;
        case 1:
            htmlStr = task.reward.instruction;
            break;
        case 2:
            htmlStr = task.product.desc;
            break;
        default:
            htmlStr = task.desc;
            break;
    }
    
    [infoWebView loadHTMLString:htmlStr baseURL:nil];
}

-(void) webViewDidFinishLoad:(UIWebView *)webView{
    [self fitSize];
}

-(void) fitSize{
    CGRect frame = infoWebView.frame;
    frame.size.height = infoWebView.scrollView.contentSize.height;
    infoWebView.frame = frame;
}

@end
