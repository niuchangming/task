//
//  LoginVC.h
//  Task
//
//  Created by Niu Changming on 23/8/15.
//  Copyright (c) 2015 Ekoo Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsetTextField.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@protocol LoginDelegate <NSObject>

@optional
- (void) loginCompleted;

@end

@interface LoginVC : UIViewController <FBSDKLoginButtonDelegate>

@property (weak, nonatomic) IBOutlet InsetTextField *accountTF;

@property (weak, nonatomic) IBOutlet InsetTextField *passwordTF;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *fbLoginBtn;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginLoadingBar;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *fbLoadingBar;

@property (strong, nonatomic) id<LoginDelegate> delegate;

- (IBAction)loginBtnClicked:(id)sender;

- (IBAction)cancelbtnClicked:(id)sender;

@end
