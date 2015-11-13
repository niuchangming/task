//
//  TaskDetailInfoView.h
//  Task
//
//  Created by Niu Changming on 30/8/15.
//  Copyright (c) 2015 Ekoo Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"


@protocol TaskDetailInfoDelegate <NSObject>

@required
-(void) addJobBtnClicked;

@end

@interface TaskDetailInfoView : UIView <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *taskTitleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *companyLogo;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLbl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *contentSegment;
@property (strong, nonatomic) Task *task;
@property (weak, nonatomic) IBOutlet UIButton *addJobBtn;
@property (weak, nonatomic) id<TaskDetailInfoDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIWebView *infoWebView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *addLoadingBar;

- (IBAction)segmentChanged:(id)sender;
- (IBAction)addJobBtnClicked:(id)sender;

-(void) fitSize;

@end
