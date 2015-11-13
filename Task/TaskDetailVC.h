//
//  TaskDetailVC.h
//  Task
//
//  Created by Niu Changming on 28/8/15.
//  Copyright (c) 2015 Ekoo Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "TaskDetailInfoView.h"
#import "ShareView.h"
#import "TaskDetailInfoView.h"
#import "Job.h"
#import "WXApi.h"
#import <MessageUI/MessageUI.h>

@class TaskDetailVC;

@interface TaskDetailVC : UIViewController<TaskDetailInfoDelegate, ShareViewDelegate, WXApiDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) Task *task;
@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong) UIScrollView *imageScroller;
@property (nonatomic, strong) UIScrollView *transparentScroller;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) TaskDetailInfoView *contentView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) Job *job;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareBtn;
@property (strong, nonatomic) ShareView *shareContainer;

- (IBAction)shareBtnClicked:(id)sender;

- (void)addImages:(NSArray*)moreImages;
- (void)addImage:(id)image atIndex:(int)index;

@end
