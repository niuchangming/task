//
//  ShareView.h
//  Task
//
//  Created by Niu Changming on 6/11/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"
#import "Job.h"

@protocol ShareViewDelegate <NSObject>

@required
-(void) facebookShare;
-(void) wechatMomentShare;
-(void) wechatFriendShare;
-(void) twitterShare;
-(void) mailShare;
-(void) copyLink;
-(void) cancelShareContainer;

@end

@interface ShareView : FXBlurView

@property (nonatomic, strong) Job *job;

- (IBAction)facebookBtnClicked:(id)sender;
- (IBAction)wechatBtnClicked:(id)sender;
- (IBAction)momentsBtnClicked:(id)sender;
- (IBAction)twitterBtnClicked:(id)sender;
- (IBAction)mailBtnClicked:(id)sender;
- (IBAction)copyLinkBtnClicked:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) id<ShareViewDelegate> delegate;

- (IBAction)cancelBtnClicked:(id)sender;

@end
