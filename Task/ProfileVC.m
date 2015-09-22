//
//  ProfileVC.m
//  Task
//
//  Created by Niu Changming on 27/8/15.
//  Copyright (c) 2015 Ekoo Lab. All rights reserved.
//

#import "ProfileVC.h"
#import "LoginVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "CommonUtils.h"

@interface ProfileVC (){
    bool isLogin;
}

@end

@implementation ProfileVC

@synthesize signBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated{
    isLogin = [CommonUtils IsEmpty:[CommonUtils accessToken]];
    [self resetSignBtn];
}

-(void) resetSignBtn{
    if (isLogin) {
        [signBtn setBackgroundColor:[CommonUtils colorFromHexString:@"#4CD964"]];
        [signBtn setTitle:@"Log in" forState:UIControlStateNormal];
    }else{
        [signBtn setBackgroundColor:[CommonUtils colorFromHexString:@"#FF4444"]];
        [signBtn setTitle:@"Log out" forState:UIControlStateNormal];
    }
}

- (IBAction)signBtnClicked:(id)sender {
    if(isLogin){
        [self login];
    }else{
        [self logout];
    }
}

-(void) login {
    [self performSegueWithIdentifier:@"login_fr_profile" sender:nil];
}

-(void) logout{
    if ([FBSDKAccessToken currentAccessToken]) {
        [FBSDKAccessToken setCurrentAccessToken:nil];
        [FBSDKProfile setCurrentProfile:nil];
    }
    
    [self clearStore];
    
    [self login];
}

-(void) loginCompleted{
    [self resetSignBtn];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"login_fr_profile"]){
        LoginVC *vc = [segue destinationViewController];
        vc.delegate = self;
    }
}

-(void) clearStore{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

@end






























