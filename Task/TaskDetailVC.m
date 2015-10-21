//
//  TaskDetailVC.m
//  Task
//
//  Created by Niu Changming on 28/8/15.
//  Copyright (c) 2015 Ekoo Lab. All rights reserved.
//

#import "TaskDetailVC.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "Image.h"
#import "TaskDetailInfoView.h"

@interface TaskDetailVC () <UIScrollViewDelegate>

@end

@implementation TaskDetailVC

@synthesize task;
@synthesize imageViews;
@synthesize imageScroller;
@synthesize transparentScroller;
@synthesize contentScrollView;
@synthesize contentView;
@synthesize pageControl;

static CGFloat WindowHeight = 248.0;
static CGFloat ImageHeight  = 248.0;
static CGFloat PageControlHeight = 20.0f;

-(void) viewDidLoad{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
    setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self setupViews];
}

- (void)setupViews{
    imageScroller  = [[UIScrollView alloc] initWithFrame:CGRectZero];
    imageScroller.backgroundColor = [UIColor clearColor];
    imageScroller.showsHorizontalScrollIndicator = NO;
    imageScroller.showsVerticalScrollIndicator = NO;
    imageScroller.pagingEnabled = YES;
        
    imageViews = [NSMutableArray arrayWithCapacity:[task.images count]];
    [self addImages:task.images];
        
    transparentScroller = [[UIScrollView alloc] initWithFrame:CGRectZero];
    transparentScroller.backgroundColor = [UIColor clearColor];
    transparentScroller.delegate = self;
    transparentScroller.bounces = NO;
    transparentScroller.pagingEnabled = YES;
    transparentScroller.showsVerticalScrollIndicator = NO;
    transparentScroller.showsHorizontalScrollIndicator = NO;
    
    contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    contentScrollView.backgroundColor = [UIColor clearColor];
    contentScrollView.delegate = self;
    contentScrollView.showsVerticalScrollIndicator = YES;
        
    pageControl = [[UIPageControl alloc] init];
    pageControl.currentPage = 0;
    [pageControl setHidesForSinglePage:YES];
    
    contentView = [[[NSBundle mainBundle] loadNibNamed:@"TaskDetailInfoView" owner:self options:nil] objectAtIndex:0];
    contentView.infoWebView.delegate = contentView;
    contentView.frame = contentScrollView.frame;
    contentView.taskTitleLbl.text =  [task.title uppercaseString];
    contentView.companyNameLbl.text = @"Company name";
    contentView.task = task;
    [contentView.infoWebView loadHTMLString:task.desc baseURL:nil];
    [contentView.contentSegment setSelectedSegmentIndex:0];
    
    [contentScrollView addSubview:contentView];
    [contentScrollView addSubview:pageControl];
    [self.view addSubview:imageScroller];
    [self.view addSubview:transparentScroller];
    [self.view addSubview:contentScrollView];
}

- (void)addImage:(Image*)image atIndex:(int)index{
    UIImageView *imageView  = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[image.thumbnailPath stringByReplacingOccurrencesOfString:@"thumbnails" withString:@"attachments"]]];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setClipsToBounds:YES];
    [imageScroller addSubview:imageView];
    [imageViews insertObject:imageView atIndex:index];
    [pageControl setNumberOfPages:pageControl.numberOfPages + 1];
    [self layoutImages];
}

-(void)addImages:(NSArray *)moreImages{
    for (id image in moreImages) {
        [self addImage:image atIndex:(int)[imageViews count]];
    }
    [pageControl setNumberOfPages:[imageViews count]];
    [self layoutImages];
}

#pragma mark - Parallax effects
- (void)updateOffsets {
    CGFloat yOffset = contentScrollView.contentOffset.y;
    CGFloat xOffset = transparentScroller.contentOffset.x;
    
    CGFloat yscroll = 0;
    if (yOffset < 0) {
        yscroll = yOffset;
    } else {
        yscroll = floorf(yOffset / 2.0);
    }
    imageScroller.contentOffset = CGPointMake(xOffset, yscroll);
    
    CGFloat transpScrHeigth = WindowHeight - fabs(yscroll);
    CGRect transpScrFrame = self.transparentScroller.frame;
    
    if (transpScrHeigth > 0) {
        transpScrFrame.size.height = transpScrHeigth;
    } else {
        transpScrFrame.size.height = 0;
    }
    
    self.transparentScroller.frame = transpScrFrame;
}

- (void)layoutContent{
    if (self.contentView) {
        contentScrollView.frame = self.view.bounds;
        
        CGFloat yOffset = WindowHeight;
        CGFloat xOffset = 0.0;
        
        CGSize contentSize = contentView.frame.size;
        contentSize.height += yOffset;
        
        contentView.frame = (CGRect){.origin = CGPointMake(xOffset, yOffset), .size = contentView.frame.size};
        contentScrollView.contentSize	= contentSize;
    }
}

#pragma mark - View Layouts
- (void)layoutImages {
    CGFloat imageWidth = imageScroller.frame.size.width;
    
    CGFloat imageYOffset = floorf((WindowHeight  - ImageHeight) / 2.0);
    
    CGFloat imageXOffset = 0.0;
    
    for (UIImageView *imageView in imageViews) {
        imageView.frame = CGRectMake(imageXOffset, imageYOffset, imageWidth, ImageHeight);
        imageXOffset += imageWidth;
    }
    
    imageScroller.contentSize = CGSizeMake([imageViews count]*imageWidth, self.view.bounds.size.height);
    imageScroller.contentOffset = CGPointMake(0.0, 0.0);
    
    transparentScroller.contentSize = CGSizeMake([imageViews count]*imageWidth, WindowHeight);
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGRect bounds = self.view.bounds;
    
    imageScroller.frame = CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height);
    transparentScroller.frame = CGRectMake(0.0, 0.0, bounds.size.width, WindowHeight);
    
    if (self.contentView) {
        contentScrollView.frame = bounds;
    }
    
    [contentScrollView setExclusiveTouch:NO];
    [self layoutImages];
    [self layoutContent];
    [self updateOffsets];
    
    CGFloat pageControlY = WindowHeight - PageControlHeight;
    
    pageControl.frame = CGRectMake(0.0, pageControlY, bounds.size.width, PageControlHeight);
    pageControl.numberOfPages  = [imageViews count];
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [pageControl setCurrentPage:floor(transparentScroller.contentOffset.x/imageScroller.frame.size.width)];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateOffsets];
}

@end
