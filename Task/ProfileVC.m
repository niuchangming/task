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
#import "SDWebImage/UIImageView+WebCache.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "ConstantValues.h"
#import "MozTopAlertView.h"
#import "NSString+URLEncode.h"
#import "User.h"
#import <QuartzCore/QuartzCore.h>

@interface ProfileVC (){
    bool isLogin;
    UILabel *emailLbl;
    UILabel *phoneLbl;
    UILabel *addressLbl;
    UILabel *companyLbl;
    UIButton *editNameBtn;
}

@end

@implementation ProfileVC

@synthesize signBtn;
@synthesize avatarBgView;
@synthesize avatarBlurView;
@synthesize user;
@synthesize avatarIV;
@synthesize nameLbl;
@synthesize scrollView;
@synthesize roleIV;
@synthesize loadingBar;

- (void)viewDidLoad {
    [super viewDidLoad];

    avatarBlurView.blurRadius = 30;
    
    signBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 8, self.view.frame.size.width, 44)];
    [signBtn setBackgroundColor:[CommonUtils colorFromHexString:@"FF4444"]];
    [signBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signBtn addTarget:self action:@selector(signBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:signBtn];
    [self setupViews];
    [self getUserInfo];
}

-(void) viewWillAppear:(BOOL)animated{
    isLogin = [CommonUtils IsEmpty:[CommonUtils accessToken]];
    [self resetSignBtn];
}

-(void) getUserInfo{
    NSString *accessToken = [CommonUtils accessToken];
    
    if([CommonUtils IsEmpty:accessToken]){
        [MozTopAlertView showWithType:MozAlertTypeError text:@"Please login first." doText:nil doBlock:nil parentView:self.view];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@ProfileController/userInfo", baseUrl];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: accessToken forKey: @"accessToken"];
    
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
            
            if(![CommonUtils IsEmpty:errMsg]) {
                [MozTopAlertView showWithType:MozAlertTypeError text:errMsg doText:nil doBlock:nil parentView:self.view];
            }else{
                user = [[User alloc] initWithJson:obj];
                if(![CommonUtils IsEmpty:user]){
                    [self updateViews];
                }else{
                    [MozTopAlertView showWithType:MozAlertTypeError text:@"Parsing failed." doText:nil doBlock:nil parentView:self.view];
                }
            }
        } else {
           [MozTopAlertView showWithType:MozAlertTypeError text:@"Data type error." doText:nil doBlock:nil parentView:self.view];
        }
        [loadingBar stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MozTopAlertView showWithType:MozAlertTypeError text:[error localizedDescription] doText:nil doBlock:nil parentView:self.view];
        [loadingBar stopAnimating];
    }];
    
    [loadingBar startAnimating];
}

-(void) setupViews{
    avatarIV.layer.cornerRadius = 54;
    avatarIV.layer.masksToBounds = YES;
    
    CGRect emailFrame = CGRectMake(0, avatarBlurView.frame.origin.y + avatarBlurView.frame.size.height + 36, self.view.frame.size.width, 44);
    
    UIView *emailView = [self getRowViewWithKey:@"Email" AndValue:@"" AndFrame: emailFrame];
    UITapGestureRecognizer *emailTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emailRowClicked)];
    emailTap.numberOfTapsRequired = 1;
    [emailView addGestureRecognizer:emailTap];
    emailLbl = (UILabel *) [emailView viewWithTag:1];
    
    NSLayoutConstraint *bottomSpaceConstraint = [NSLayoutConstraint constraintWithItem:[emailLbl superview]
                                                                             attribute:NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:avatarBlurView
                                                                             attribute:NSLayoutAttributeTop
                                                                            multiplier:1.0
                                                                              constant:8.0];
    
    [scrollView addConstraint:bottomSpaceConstraint];
    
    
    CGRect phoneFrame = CGRectMake(0, emailFrame.origin.y + emailFrame.size.height + 8, self.view.frame.size.width, 44);
    UIView *phoneView = [self getRowViewWithKey:@"Phone" AndValue:@"" AndFrame:phoneFrame];
    UITapGestureRecognizer *phoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneRowClicked)];
    phoneTap.numberOfTapsRequired = 1;
    [phoneView addGestureRecognizer:phoneTap];
    phoneLbl = (UILabel*)[phoneView viewWithTag:1];
    
    CGRect addressFrame = CGRectMake(0, phoneFrame.origin.y + phoneFrame.size.height + 8, self.view.frame.size.width, 44);
    UIView *addressView = [self getRowViewWithKey:@"Address" AndValue:@"" AndFrame:addressFrame];
    UITapGestureRecognizer *addressTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressRowClicked)];
    addressTap.numberOfTapsRequired = 1;
    [addressView addGestureRecognizer:addressTap];
    addressLbl = (UILabel*)[addressView viewWithTag:1];
    
    CGRect companyFrame = CGRectMake(0, addressFrame.origin.y + addressFrame.size.height + 8, self.view.frame.size.width, 44);
    UIView *companyView = [self getRowViewWithKey:@"Company" AndValue:user.company.name AndFrame:companyFrame];
    UITapGestureRecognizer *companyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(companyRowClicked)];
    companyTap.numberOfTapsRequired = 1;
    [companyView addGestureRecognizer:companyTap];
    companyLbl = (UILabel*)[companyView viewWithTag:1];
    
    signBtn.frame = CGRectMake(0, companyFrame.origin.y + companyFrame.size.height + 8, self.view.frame.size.width, 44);
}

-(void) updateViews{
    [avatarBgView sd_setImageWithURL:[NSURL URLWithString:user.avatar.thumbnailPath] placeholderImage: [UIImage imageNamed:@"avatar_placeholder"]];
    
    [avatarIV sd_setImageWithURL:[NSURL URLWithString:user.avatar.thumbnailPath] placeholderImage: [UIImage imageNamed:@"avatar_placeholder"]];
    
    nameLbl.text = [NSString stringWithFormat:@"%@ %@", user.profile.firstName, user.profile.lastName];
    [nameLbl sizeToFit];
    nameLbl.center = CGPointMake(self.view.frame.size.width / 2, nameLbl.center.y);
    
    if([user.role isEqualToString:@"NORMAL"]){
        [roleIV setImage:[UIImage imageNamed:@"role_user"]];
    }else if([user.role isEqualToString:@"MERCHANT"]){
        [roleIV setImage:[UIImage imageNamed:@"role_merchant"]];
    }else if([user.role isEqualToString:@"ADMIN"]){
        [roleIV setImage:[UIImage imageNamed:@"role_user"]];
    }
    
    if(editNameBtn == nil) {
        editNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        editNameBtn.backgroundColor = [UIColor clearColor];
        UIImage *buttonImageNormal = [UIImage imageNamed:@"edit.png"];
        [editNameBtn setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
        
        [editNameBtn addTarget:self action:@selector(editUsername) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:editNameBtn];
    }
    
    if(editNameBtn.hidden){
        editNameBtn.hidden = NO;
    }
    
    editNameBtn.frame = CGRectMake(nameLbl.frame.origin.x + nameLbl.frame.size.width + 4, nameLbl.frame.origin.y + 2, 20, 20);
    
    emailLbl.text = user.email;
    phoneLbl.text = user.profile.phone;
    
    NSString *addressStr = @"";
    if(user.profile.address.block != 0) {
        [addressStr stringByAppendingString:[NSString stringWithFormat:@"Blk %i", user.profile.address.block]];
    }
    
    if(![CommonUtils IsEmpty:user.profile.address.street]){
        [addressStr stringByAppendingFormat:@" %@", user.profile.address.street];
    }
    
    if (![CommonUtils IsEmpty:user.profile.address.unit]) {
        [addressStr stringByAppendingFormat:@" %@", user.profile.address.unit];
    }
    
    addressLbl.text = addressStr;
    
    if(![CommonUtils IsEmpty:user.company]){
        if(companyLbl == nil) {
            CGRect companyFrame = CGRectMake(0, [addressLbl superview].frame.origin.y + [addressLbl superview].frame.size.height + 8, self.view.frame.size.width, 44);
            UIView *companyView = [self getRowViewWithKey:@"Company" AndValue:user.company.name AndFrame:companyFrame];
            UITapGestureRecognizer *companyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(companyRowClicked)];
            companyTap.numberOfTapsRequired = 1;
            [companyView addGestureRecognizer:companyTap];
            companyLbl = (UILabel*)[companyView viewWithTag:1];
        }
        companyLbl.text = user.company.name;
        signBtn.frame = CGRectMake(0, [companyLbl superview].frame.origin.y + [companyLbl superview].frame.size.height + 8, self.view.frame.size.width, 44);
    }else{
        UIView *companyRow = [companyLbl superview];
        companyLbl = nil;
        [companyRow removeFromSuperview];
        companyRow = nil;
        signBtn.frame = CGRectMake(0, [addressLbl superview].frame.origin.y + [addressLbl superview].frame.size.height + 8, self.view.frame.size.width, 44);
    }
    
}

-(UIView *) getRowViewWithKey: (NSString *) key AndValue:(NSString*) value AndFrame: (CGRect)frame{
    UIView *row = [[UIView alloc] initWithFrame:frame];
    [row setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *keyLbl = [[UILabel alloc]initWithFrame:CGRectMake(8, 12, 68, 20)];
    keyLbl.text = key;
    [keyLbl setTag:0];
    keyLbl.textColor = [CommonUtils colorFromHexString:@"#4A4A4A"];
    keyLbl.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.0f];
    [row addSubview:keyLbl];
    
    UILabel *valueLbl = [[UILabel alloc]initWithFrame:CGRectMake(78, 12, self.view.frame.size.width - 106, 20)];
    valueLbl.text = value;
    [valueLbl setTag:1];
    valueLbl.textColor = [CommonUtils colorFromHexString:@"#4A4A4A"];
    valueLbl.textAlignment = NSTextAlignmentRight;
    valueLbl.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.0f];
    [row addSubview:valueLbl];
    
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"forward.png"]];
    arrow.frame = CGRectMake(valueLbl.frame.origin.x + valueLbl.frame.size.width + 4, 14, 16, 16);
    [row addSubview:arrow];
    
    [scrollView addSubview:row];
    
    return row;
}

-(void) emailRowClicked{
    
}

-(void) phoneRowClicked{
    [self performSegueWithIdentifier:@"updatephone_fr_userinfo" sender:self];
}

-(void) addressRowClicked{

}

-(void) companyRowClicked{

}

-(void) editUsername{
    [self performSegueWithIdentifier:@"updateusername_fr_userinfo" sender:self];
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

- (void)signBtnClicked:(id)sender {
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
    
    nameLbl.text = @"";
    emailLbl.text = @"";
    phoneLbl.text = @"";
    addressLbl.text = @"";
    if(companyLbl != nil){
        companyLbl.text = @"";
    }
    editNameBtn.hidden = YES;
    [avatarBgView setImage:[UIImage imageNamed:@"default_avatar"]];
    [avatarIV setImage:[UIImage imageNamed:@"default_avatar"]];
}

-(void) loginCompleted{
    [self resetSignBtn];
    [self getUserInfo];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"login_fr_profile"]){
        LoginVC *vc = [segue destinationViewController];
        vc.delegate = self;
    }else if ([[segue identifier] isEqualToString:@"updatephone_fr_userinfo"]){
        UpdatePhoneVC * updatePhoneVC = [segue destinationViewController];
        updatePhoneVC.delegate = self;
        updatePhoneVC.user = user;
    }else if([[segue identifier] isEqualToString:@"updateusername_fr_userinfo"]){
        UpdateUsernameVC *updateNameVC = [segue destinationViewController];
        updateNameVC.delegate = self;
        updateNameVC.user = user;
    }
}

-(void) updatePhone:(NSString *)phone{
    phoneLbl.text = phone;
}

-(void) clearStore{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

-(void) viewDidDisappear:(BOOL)animated{
    
}

@end






























