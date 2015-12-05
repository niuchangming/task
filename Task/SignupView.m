//
//  SignupView.m
//  Task
//
//  Created by Niu Changming on 12/11/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import "SignupView.h"
#import "CommonUtils.h"
#import "ConstantValues.h"
#import "MozTopAlertView.h"
#import "User.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <JCAlertView/JCAlertView.h>

@implementation SignupView

@synthesize emailTV;
@synthesize passwordTV;
@synthesize signupBtn;
@synthesize loadingBar;
@synthesize delegate;
@synthesize cancelBtn;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"SignupView" owner:self options:nil]objectAtIndex:0];
        emailTV.leftViewMode = UITextFieldViewModeAlways;
        
        UIView *userIcon = [[UIView alloc] init];
        [userIcon setFrame:CGRectMake(0.0f, 0.0f, 32.0f, 24.0f)];
        [userIcon setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *userImg = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, 24, 24)];
        [userImg setImage:[UIImage imageNamed:@"user.png"]];
        [userIcon addSubview:userImg];
        emailTV.leftView = userIcon;
        
        passwordTV.leftViewMode = UITextFieldViewModeAlways;
        
        UIView *passwordIcon = [[UIView alloc] init];
        [passwordIcon setFrame:CGRectMake(0.0f, 0.0f, 32.0f, 24.0f)];
        [passwordIcon setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *pwdImg = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, 24, 24)];
        [pwdImg setImage:[UIImage imageNamed:@"unlock.png"]];
        [passwordIcon addSubview:pwdImg];
        passwordTV.leftView = passwordIcon;
        
        [emailTV.layer setCornerRadius:2.0f];
        [passwordTV.layer setCornerRadius:2.0f];
        [signupBtn.layer setCornerRadius:2.0f];
    }
    return self;
}

- (IBAction)signupBtnClicked:(id)sender {
    if([CommonUtils IsEmpty:emailTV.text] || ![CommonUtils isValidEmail:emailTV.text]){
        [delegate signupCompletedWithResponseData:nil withError:@"Email format is incorrect."];
        return;
    }
    
    if([CommonUtils IsEmpty:passwordTV.text]) {
        [delegate signupCompletedWithResponseData:nil withError:@"Password cannot be empty."];
        return;
    }
    
    [loadingBar startAnimating];
    [signupBtn setEnabled:false];
    [cancelBtn setEnabled:false];
    
    NSString *url = [NSString stringWithFormat:@"%@SessionController/signup", baseUrl];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: emailTV.text forKey: @"email"];
    [params setObject: passwordTV.text forKey: @"password"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [delegate signupCompletedWithResponseData:responseObject withError:nil];
        [loadingBar stopAnimating];
        [signupBtn setEnabled:true];
        [cancelBtn setEnabled:true];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate signupCompletedWithResponseData:nil withError:[error localizedDescription]];
        [loadingBar stopAnimating];
        [signupBtn setEnabled:true];
        [cancelBtn setEnabled:true];
    }];
}

- (IBAction)cancelBrnClicked:(id)sender {
    [((JCAlertView*)self.superview) dismissWithCompletion:nil];
}

@end


















