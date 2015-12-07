//
//  TaskDetailVC.m
//  Task
//
//  Created by Niu Changming on 28/8/15.
//  Copyright (c) 2015 Ekoo Lab. All rights reserved.
//

#import "TaskDetailVC.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "Image.h"
#import "TaskDetailInfoView.h"
#import "ConstantValues.h"
#import "MozTopAlertView.h"
#import "FBSDKShareLinkContent.h"
#import "FBSDKShareDialog.h"
#import "Product.h"
#import <Social/Social.h>
#import "WXApiRequestHandler.h"
#import <TwitterKit/TwitterKit.h>
#import "NSString+URLEncode.h"

@interface TaskDetailVC () <UIScrollViewDelegate, FBSDKSharingDelegate>

@end

@implementation TaskDetailVC

@synthesize task;
@synthesize imageViews;
@synthesize imageScroller;
@synthesize transparentScroller;
@synthesize contentScrollView;
@synthesize contentView;
@synthesize pageControl;
@synthesize shareContainer;
@synthesize shareBtn;
@synthesize job;

static CGFloat WindowHeight = 248.0;
static CGFloat ImageHeight  = 248.0;
static CGFloat PageControlHeight = 20.0f;

-(void) viewDidLoad{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
    setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self setupViews];
    
    [self checkUserHasJob];
}

-(void) checkUserHasJob{
    contentView.addJobBtn.hidden = YES;
    [self hideShareBtn];
    [contentView.addLoadingBar startAnimating];
    
    if([CommonUtils IsEmpty:[CommonUtils accessToken]]) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@", baseUrl, @"JobController/getJobByTaskAndAccessToken"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: [NSNumber numberWithFloat:task.entityId] forKey: @"taskId"];
    [params setObject: [CommonUtils accessToken] forKey: @"accessToken"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        id object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&error];
        
        if(error != nil){
            [MozTopAlertView showWithType:MozAlertTypeError text:@"Error" doText:nil doBlock:nil parentView:self.view];
            return;
        }
        
        if ([object isKindOfClass:[NSDictionary class]] == YES){
            NSDictionary *obj = (NSDictionary *)object;
            NSString *errMsg = [obj valueForKey:@"error"];
            if(![CommonUtils IsEmpty:errMsg]){
                [self hideShareBtn];
                contentView.addJobBtn.hidden = NO;
            }else{
                job = [[Job alloc] initWithJson:obj];
                if(job != nil) {
                    [self showShareBtn];
                    shareContainer.job = job;
                    contentView.addJobBtn.hidden = YES;
                }else{
                    [self hideShareBtn];
                    contentView.addJobBtn.hidden = NO;
                }
            }
            [contentView.addLoadingBar stopAnimating];
        }else{
            [MozTopAlertView showWithType:MozAlertTypeError text:@"The format is incorrect for returned data." doText:nil doBlock:nil parentView:self.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MozTopAlertView showWithType:MozAlertTypeError text:[error localizedDescription] doText:nil doBlock:nil parentView:self.view];
    }];
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
    contentView.delegate = self;
    contentView.infoWebView.delegate = contentView;
    contentView.frame = contentScrollView.frame;
    contentView.taskTitleLbl.text =  [task.title uppercaseString];
    contentView.companyNameLbl.text = @"Company name";
    contentView.task = task;
    [contentView.infoWebView loadHTMLString:[NSString stringWithFormat:@"<div style='text-align:justify;'>%@</div>", task.desc] baseURL:nil];
    [contentView.contentSegment setSelectedSegmentIndex:0];
    
    shareContainer = [[[NSBundle mainBundle] loadNibNamed:@"ShareView" owner:self options:nil] objectAtIndex:0];
    shareContainer.delegate = self;
    shareContainer.cancelBtn.layer.cornerRadius = 4;
    shareContainer.cancelBtn.clipsToBounds = YES;
    [shareContainer updateAsynchronously:YES completion:^{
        self.shareContainer.frame = CGRectMake(0, self.view.frame.origin.y + self.view.frame.size.height, self.view.frame.size.width, 0);
    }];
    
    [contentScrollView addSubview:contentView];
    [contentScrollView addSubview:pageControl];
    [self.view addSubview:imageScroller];
    [self.view addSubview:contentScrollView];
    [self.view addSubview:transparentScroller];
    [self.view addSubview:shareContainer];
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

- (IBAction)shareBtnClicked:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        BOOL open = shareContainer.frame.size.height > 0;
        shareContainer.frame = CGRectMake(0, open? (self.view.frame.origin.y + self.view.frame.size.height) :self.view.frame.size.height - 246, self.view.frame.size.width, open? 0: 246);
    }];
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
    
    CGFloat transpScrHeigth = WindowHeight - fabs(yOffset);
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
        contentScrollView.contentSize = contentSize;
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

-(void) addJobBtnClicked{
    if([CommonUtils IsEmpty:[CommonUtils accessToken]]){
        [self performSegueWithIdentifier:@"login_fr_taskinfo" sender:self];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@%@", baseUrl, @"JobController/addJob"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: [NSNumber numberWithFloat:task.entityId] forKey: @"taskId"];
    [params setObject: [CommonUtils accessToken] forKey: @"accessToken"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        id object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&error];
        
        if(error != nil){
            [MozTopAlertView showWithType:MozAlertTypeError text:@"Error" doText:nil doBlock:nil parentView:self.view];
            return;
        }
        
        if ([object isKindOfClass:[NSDictionary class]] == YES){
            NSDictionary *obj = (NSDictionary *)object;
            NSString *errMsg = [obj valueForKey:@"error"];
            if(![CommonUtils IsEmpty:errMsg]){
                [MozTopAlertView showWithType:MozAlertTypeError text:errMsg doText:nil doBlock:nil parentView:self.view];
            }else{
                job = [[Job alloc] initWithJson:obj];
                if(job != nil) {
                    shareContainer.job = job;
                    contentView.addJobBtn.hidden = YES;
                    [self showShareBtn];
                    [MozTopAlertView showWithType:MozAlertTypeSuccess text:@"Successfully Added !" doText:nil doBlock:nil parentView:self.view];
                }else{
                    [MozTopAlertView showWithType:MozAlertTypeSuccess text:@"Server return an empty data." doText:nil doBlock:nil parentView:self.view];
                }
            }
        }else{
            [MozTopAlertView showWithType:MozAlertTypeError text:@"The format is incorrect for returned data." doText:nil doBlock:nil parentView:self.view];
        }
        [contentView.addLoadingBar stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MozTopAlertView showWithType:MozAlertTypeError text:[error localizedDescription] doText:nil doBlock:nil parentView:self.view];
        [contentView.addLoadingBar stopAnimating];
    }];
    
}

-(void) facebookShare{
    NSString *desc = [[[NSAttributedString alloc] initWithData:[task.product.desc dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil] string];
    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentTitle=task.product.productName;
    content.contentURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@JobController/viewProduct?jobToken=%@", baseUrl, [job.token URLEncode]]];
    content.contentDescription = desc;
    content.imageURL = [NSURL URLWithString:[[task.images objectAtIndex:0] thumbnailPath]];
    
    FBSDKShareDialog* dialog = [[FBSDKShareDialog alloc] init];
    dialog.mode = FBSDKShareDialogModeFeedWeb;
    dialog.shareContent = content;
    dialog.fromViewController = self;
    dialog.delegate = self;
    [dialog show];
    
    [self shareBtnClicked:nil];
}

-(void) wechatMomentShare{
    NSString *url = [NSString stringWithFormat:@"%@JobController/viewProduct?jobToken=%@", baseUrl, [job.token URLEncode]];

    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[task.images objectAtIndex:0] thumbnailPath]]];
    
    [WXApiRequestHandler sendLinkURL:url
                             TagName:@"WECHAT_TAG_JUMP_SHOWRANK"
                               Title:task.product.productName
                         Description:task.product.desc
                          ThumbImage:[UIImage imageWithData:imageData]
                             InScene:WXSceneTimeline];
    [self shareBtnClicked:nil];
}

-(void) wechatFriendShare{
    NSString *url = [NSString stringWithFormat:@"%@JobController/viewProduct?jobToken=%@", baseUrl, [job.token URLEncode]];
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[task.images objectAtIndex:0] thumbnailPath]]];
    
    NSString *desc = [[[NSAttributedString alloc] initWithData:[task.product.desc dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil] string];
    
    [WXApiRequestHandler sendLinkURL:url
                             TagName:@"WECHAT_TAG_JUMP_SHOWRANK"
                               Title:task.product.productName
                         Description:desc
                          ThumbImage:[UIImage imageWithData:imageData]
                             InScene:WXSceneSession];
    [self shareBtnClicked:nil];
}

-(void) twitterShare{
    NSString *link = [NSString stringWithFormat:@"%@JobController/viewProduct?jobToken=%@", baseUrl, [job.token URLEncode]];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[task.images objectAtIndex:0] thumbnailPath]]];
    
    TWTRComposer *composer = [[TWTRComposer alloc] init];
    [composer setURL:[NSURL URLWithString:link]];
    [composer setText:task.product.productName];
    [composer setImage:[UIImage imageWithData:imageData]];
    [composer showWithCompletion:^(TWTRComposerResult result) {
        if (result == TWTRComposerResultCancelled) {
            [MozTopAlertView showWithType:MozAlertTypeWarning text:@"Canceled" doText:nil doBlock:nil parentView:self.view];
        }else {
            [MozTopAlertView showWithType:MozAlertTypeSuccess text:@"Successfully shared." doText:nil doBlock:nil parentView:self.view];
        }
    }];
    
    [self shareBtnClicked:nil];
}

-(void) mailShare{
    NSString *url = [NSString stringWithFormat:@"%@JobController/viewProduct?jobToken=%@", baseUrl, [job.token URLEncode]];
    
    NSString *emailTitle = task.product.productName;
    
    NSString *messageBody = [NSString stringWithFormat:@"I would like to share a link with you! \n\r%@", url];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];

    [self presentViewController:mc animated:YES completion:NULL];
    
    [self shareBtnClicked:nil];
}

-(void) copyLink{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@JobController/viewProduct?jobToken=%@", baseUrl, [job.token URLEncode]]];
    [MozTopAlertView showWithType:MozAlertTypeSuccess text:@"The link copied." doText:nil doBlock:nil parentView:self.view];
    [self shareBtnClicked:nil];
}

-(void) cancelShareContainer{
    [self shareBtnClicked:nil];
}

-(void) sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    [MozTopAlertView showWithType:MozAlertTypeSuccess text:@"Successfully shared." doText:nil doBlock:nil parentView:self.view];
}

-(void) sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
    [MozTopAlertView showWithType:MozAlertTypeError text:[error localizedDescription] doText:nil doBlock:nil parentView:self.view];
}

-(void) sharerDidCancel:(id<FBSDKSharing>)sharer{
    [MozTopAlertView showWithType:MozAlertTypeWarning text:@"Canceled." doText:nil doBlock:nil parentView:self.view];
}

-(void) onResp:(BaseResp *)resp{
   // Wechat share callback method, but don't know never being called.
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result){
        case MFMailComposeResultCancelled:
            [MozTopAlertView showWithType:MozAlertTypeWarning text:@"Mail canceled." doText:nil doBlock:nil parentView:self.view];
            break;
        case MFMailComposeResultSaved:
            [MozTopAlertView showWithType:MozAlertTypeWarning text:@"Mail saved." doText:nil doBlock:nil parentView:self.view];
            break;
        case MFMailComposeResultSent:
            [MozTopAlertView showWithType:MozAlertTypeSuccess text:@"Mail sent." doText:nil doBlock:nil parentView:self.view];
            break;
        case MFMailComposeResultFailed:
           [MozTopAlertView showWithType:MozAlertTypeError text:@"Mail failed." doText:nil doBlock:nil parentView:self.view];
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)hideShareBtn{
    [self.shareBtn setEnabled:NO];
    [self.shareBtn setTintColor: [UIColor clearColor]];
}

-(void) showShareBtn{
    [self.shareBtn setEnabled:YES];
    [self.shareBtn setTintColor: [UIColor whiteColor]];
}

@end
