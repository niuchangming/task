//
//  TaskDetailInfoView.m
//  Task
//
//  Created by Niu Changming on 30/8/15.
//  Copyright (c) 2015 Ekoo Lab. All rights reserved.
//

#import "TaskDetailInfoView.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "ConstantValues.h"
#import "MozTopAlertView.h"

@implementation TaskDetailInfoView

@synthesize companyLogo;
@synthesize companyNameLbl;
@synthesize taskTitleLbl;
@synthesize contentSegment;
@synthesize task;
@synthesize infoWebView;
@synthesize addLoadingBar;
@synthesize delegate;
@synthesize addJobBtn;

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

- (IBAction)addJobBtnClicked:(id)sender {
    [delegate addJobBtnClicked];
}

-(void) webViewDidFinishLoad:(UIWebView *)webView{
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    
    [self fitSize];
}

-(void) fitSize{    
    UIScrollView *rootView = (UIScrollView *)[[infoWebView superview] superview];
    rootView.contentSize = CGSizeMake(rootView.frame.size.width, [infoWebView superview].frame.origin.y + infoWebView.frame.origin.y + infoWebView.frame.size.height);
}

@end
