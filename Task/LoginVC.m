//
//  LoginVC.m
//  Task
//
//  Created by Niu Changming on 23/8/15.
//  Copyright (c) 2015 Ekoo Lab. All rights reserved.
//

#import "LoginVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "CommonUtils.h"
#import "MozTopAlertView.h"
#import "ConstantValues.h"
#import "User.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@implementation LoginVC

@synthesize accountTF;
@synthesize passwordTF;
@synthesize loginBtn;
@synthesize loginLoadingBar;
@synthesize fbLoadingBar;
@synthesize fbLoginBtn;
@synthesize delegate;
@synthesize signupPopView;

-(void)viewDidLoad{    
    accountTF.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *userIcon = [[UIView alloc] init];
    [userIcon setFrame:CGRectMake(0.0f, 0.0f, 32.0f, 24.0f)];
    [userIcon setBackgroundColor:[UIColor clearColor]];

    UIImageView *userImg = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, 24, 24)];
    [userImg setImage:[UIImage imageNamed:@"user.png"]];
    [userIcon addSubview:userImg];
    accountTF.leftView = userIcon;
    
    passwordTF.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *passwordIcon = [[UIView alloc] init];
    [passwordIcon setFrame:CGRectMake(0.0f, 0.0f, 32.0f, 24.0f)];
    [passwordIcon setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *pwdImg = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, 24, 24)];
    [pwdImg setImage:[UIImage imageNamed:@"unlock.png"]];
    [passwordIcon addSubview:pwdImg];
    passwordTF.leftView = passwordIcon;
    
    [accountTF.layer setCornerRadius:2.0f];
    [passwordTF.layer setCornerRadius:2.0f];
    [loginBtn.layer setCornerRadius:2.0f];
    
    fbLoginBtn.readPermissions = @[@"public_profile", @"email"];
    fbLoginBtn.delegate = self;
}

- (IBAction)signupBtnClicked:(id)sender {
    if(signupPopView == nil){
        SignupView *signupView = [[SignupView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
        signupView.delegate = self;
        signupPopView = [[JCAlertView alloc] initWithCustomView:signupView dismissWhenTouchedBackground:NO];
    }
    
    [signupPopView show];
}

- (IBAction)forgotBtnClicked:(id)sender {
    
}

- (IBAction)loginBtnClicked:(id)sender {
    [loginLoadingBar startAnimating];
    [loginBtn setEnabled:false];
    
    if(![CommonUtils hasNetwork]) {
        [MozTopAlertView showWithType:MozAlertTypeError text:@"Network connection error." doText:nil doBlock:nil parentView:self.view];
        return;
    }
    
    if([CommonUtils IsEmpty:accountTF.text] || ![CommonUtils isValidEmail:accountTF.text]) {
        [MozTopAlertView showWithType:MozAlertTypeError text:@"Email format is incorrect." doText:nil doBlock:nil parentView:self.view];
        return;
    }
    
    if([CommonUtils IsEmpty:passwordTF.text]) {
        [MozTopAlertView showWithType:MozAlertTypeError text:@"Password cannot be empty." doText:nil doBlock:nil parentView:self.view];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@", baseUrl, @"SessionController/login"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: accountTF.text forKey: @"email"];
    [params setObject: passwordTF.text forKey: @"password"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self parseUser:responseObject];
        [loginLoadingBar stopAnimating];
        [loginBtn setEnabled:true];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MozTopAlertView showWithType:MozAlertTypeError text:[error localizedDescription] doText:nil doBlock:nil parentView:self.view];
        [loginLoadingBar stopAnimating];
        [loginBtn setEnabled:true];
    }];
}

- (void) loginButton: (FBSDKLoginButton *)loginButton didCompleteWithResult: (FBSDKLoginManagerLoginResult *)result error: (NSError *)error{
    if(error){
        [MozTopAlertView showWithType:MozAlertTypeError text:[error localizedDescription] doText:nil doBlock:nil parentView:self.view];
        return;
    }
    
    [self syncFbIdWithServer:result.token.userID];
}

-(void) syncFbIdWithServer: (NSString*) userId{
    
    if([CommonUtils IsEmpty:userId]){
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@", baseUrl, @"SessionController/loginWithFB"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: userId forKey: @"fbId"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self parseUser:responseObject];
        [fbLoadingBar stopAnimating];
        [fbLoginBtn setEnabled:true];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MozTopAlertView showWithType:MozAlertTypeError text:[error localizedDescription] doText:nil doBlock:nil parentView:self.view];
        [fbLoadingBar stopAnimating];
        [fbLoginBtn setEnabled:true];
    }];
    
    [fbLoadingBar startAnimating];
    [fbLoginBtn setEnabled:false];

}

-(void) signupCompletedWithResponseData:(id)resp withError:(NSString *)err{
    if(![CommonUtils IsEmpty:err]){
        [MozTopAlertView showWithType:MozAlertTypeError text:err doText:nil doBlock:nil parentView:self.view];
        [signupPopView dismissWithCompletion:nil];
        return;
    }
    
    [self parseUser:resp];
    [signupPopView dismissWithCompletion:nil];
}

-(void) parseUser:(id) responseObject{
    if([responseObject isKindOfClass:[NSDictionary class]]){
        NSDictionary *obj = (NSDictionary *)responseObject;
        NSString *errMsg = [obj valueForKey:@"error"];
        
        if(![CommonUtils IsEmpty:errMsg]) {
            [MozTopAlertView showWithType:MozAlertTypeError text:errMsg doText:nil doBlock:nil parentView:self.view];
        }else{
            User *user = [[User alloc] initWithJson:obj];
            [self storeUserInfo:user];
            [self cancelbtnClicked:nil];
        }
    }else{
        [MozTopAlertView showWithType:MozAlertTypeError text:@"Unknown error." doText:nil doBlock:nil parentView:self.view];
    }
}

- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{}

-(void) storeUserInfo: (User *) user{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:user.accessToken forKey:@"access_token"];
    [defaults setBool:user.isActive forKey:@"is_active"];
    [defaults setInteger:user.entityId forKey:@"entity_id"];
    [defaults setObject:user.role forKey:@"role"];
    [defaults synchronize];
}

- (IBAction)cancelbtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) viewWillDisappear:(BOOL)animated{
    if (delegate != nil && [delegate respondsToSelector:@selector(loginCompleted)]) {
        [delegate loginCompleted];
    }
}
@end












