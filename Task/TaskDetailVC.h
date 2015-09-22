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

@class TaskDetailVC;

@interface TaskDetailVC : UIViewController

@property (strong, nonatomic) Task *task;
@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong) UIScrollView *imageScroller;
@property (nonatomic, strong) UIScrollView *transparentScroller;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) TaskDetailInfoView *contentView;
@property (nonatomic, strong) UIPageControl *pageControl;

- (void)addImages:(NSArray*)moreImages;
- (void)addImage:(id)image atIndex:(int)index;

@end
