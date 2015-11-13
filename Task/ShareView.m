//
//  ShareView.m
//  Task
//
//  Created by Niu Changming on 6/11/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import "ShareView.h"

@implementation ShareView

@synthesize cancelBtn;
@synthesize job;
@synthesize delegate;

-(id) init{
    self = [super self];
    if(self){
        
    }
    return self;
}

- (IBAction)facebookBtnClicked:(id)sender {
    [delegate facebookShare];
}

- (IBAction)wechatBtnClicked:(id)sender {
    [delegate wechatFriendShare];
}

- (IBAction)momentsBtnClicked:(id)sender {
    [delegate wechatMomentShare];
}

- (IBAction)twitterBtnClicked:(id)sender {
    [delegate twitterShare];
}

- (IBAction)mailBtnClicked:(id)sender {
    [delegate mailShare];
}

- (IBAction)copyLinkBtnClicked:(id)sender {
    [delegate copyLink];
}

- (IBAction)cancelBtnClicked:(id)sender {
    [delegate cancelShareContainer];
}
@end
