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
#import <AFURLSessionManager.h>
#include "ConstantValues.h"
#import "UserQRCodeVC.h"

@interface ProfileVC (){
    bool isLogin;
    UILabel *qrcodeLbl;
    UILabel *emailLbl;
    UILabel *phoneLbl;
    UILabel *addressLbl;
    UILabel *companyLbl;
    UILabel *cashierLbl;
    UILabel *taskLbl;
    UIButton *editNameBtn;
    UIActionSheet *avatarOptSheet;
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
    [self updateContentHeight];
    [self getUserInfo];
}

-(void) viewWillAppear:(BOOL)animated{
    if(self.tabBarController.navigationItem.rightBarButtonItem != nil){
        self.tabBarController.navigationItem.rightBarButtonItem = nil;
    }
    
    if(self.tabBarController.navigationItem.titleView != nil){
        self.tabBarController.navigationItem.titleView = nil;
    }
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
    [params setObject:accessToken forKey: @"accessToken"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] == YES){
            NSDictionary *obj = (NSDictionary *)responseObject;
            
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
    [avatarIV setUserInteractionEnabled:YES];
    UITapGestureRecognizer *avatarIvTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAvatarOptSheet:)];
    avatarIvTap.numberOfTapsRequired = 1;
    [avatarIV addGestureRecognizer:avatarIvTap];
    
    [avatarIV setImage:[UIImage imageNamed:@"default_avatar.jpg"]];
    [avatarBgView setImage:[UIImage imageNamed:@"default_avatar.jpg"]];
    
    CGRect qrcodeFrame;
    if(IS_IPHONE_6){
        qrcodeFrame = CGRectMake(0, avatarBlurView.frame.origin.y + avatarBlurView.frame.size.height + 36, self.view.frame.size.width, 44);
    }else if(IS_IPHONE_6_PLUS){
        qrcodeFrame = CGRectMake(0, avatarBlurView.frame.origin.y + avatarBlurView.frame.size.height + 54, self.view.frame.size.width, 44);
    }else{
        qrcodeFrame = CGRectMake(0, avatarBlurView.frame.origin.y + avatarBlurView.frame.size.height + 8, self.view.frame.size.width, 44);
    }
    
    UIView *qrcodeView = [self getRowViewWithKey:@"QR Code" AndValue:@"qrcode" AndFrame: qrcodeFrame];
    qrcodeLbl = (UILabel *) [qrcodeView viewWithTag:1];
    UITapGestureRecognizer *qrcodeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qrcodeRowClicked)];
    qrcodeTap.numberOfTapsRequired = 1;
    [qrcodeView addGestureRecognizer:qrcodeTap];
    
    
    CGRect emailFrame = CGRectMake(0, qrcodeFrame.origin.y + qrcodeFrame.size.height + 8, self.view.frame.size.width, 44);
    UIView *emailView = [self getRowViewWithKey:@"Email" AndValue:@"" AndFrame:emailFrame];
    emailLbl = (UILabel*)[emailView viewWithTag:1];
    
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
    
    CGRect cashierFrame = CGRectMake(0, companyFrame.origin.y + companyFrame.size.height + 8, self.view.frame.size.width, 44);
    UIView *cashierView = [self getRowViewWithKey:@"Cashiers" AndValue:[NSString stringWithFormat:@"%lu", (unsigned long)user.cashiers.count] AndFrame:cashierFrame];
    UITapGestureRecognizer *cashierTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cashierRowClicked)];
    cashierTap.numberOfTapsRequired = 1;
    [cashierView addGestureRecognizer:cashierTap];
    cashierLbl = (UILabel*)[cashierView viewWithTag:1];
    
    CGRect taskFrame = CGRectMake(0, cashierFrame.origin.y + cashierFrame.size.height + 8, self.view.frame.size.width, 44);
    UIView *taskView = [self getRowViewWithKey:@"Tasks" AndValue:@"" AndFrame:taskFrame];
    UITapGestureRecognizer *taskTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taskRowClicked)];
    taskTap.numberOfTapsRequired = 1;
    [taskView addGestureRecognizer:taskTap];
    taskLbl = (UILabel*)[taskView viewWithTag:1];
    
    signBtn.frame = CGRectMake(0, taskFrame.origin.y + taskFrame.size.height + 8, self.view.frame.size.width, 44);
}

-(void) updateViews{
    [avatarBgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@ProfileController/showAvatarById?id=%i", [baseUrl stringByReplacingOccurrencesOfString:@"api/" withString:@""], [user.avatar entityId]]] placeholderImage:[UIImage imageNamed:@"default_avatar.jpg"]];
    [avatarIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@ProfileController/showAvatarById?id=%i", [baseUrl stringByReplacingOccurrencesOfString:@"api/" withString:@""], [user.avatar entityId]]] placeholderImage:[UIImage imageNamed:@"default_avatar.jpg"]];
    
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

    if(![CommonUtils IsEmpty:user.email]){
        emailLbl.text = user.email;
    }
    
    if(![CommonUtils IsEmpty:user.profile.phone]){
        phoneLbl.text = user.profile.phone;
    }
    
    NSMutableString *addressStr = [NSMutableString string];
    if(user.profile.address.block != 0) {
        [addressStr appendString:[NSString stringWithFormat:@"Blk %i", user.profile.address.block]];
    }
    
    if(![CommonUtils IsEmpty:user.profile.address.street]){
        [addressStr appendString:[NSString stringWithFormat:@" %@", user.profile.address.street]];
    }
    
    if (![CommonUtils IsEmpty:user.profile.address.unit]) {
        [addressStr appendString:[NSString stringWithFormat:@" %@", user.profile.address.unit]];
    }
    
    addressLbl.text = addressStr;
    
    if([user.role isEqualToString:@"MERCHANT"]){
        if(companyLbl == nil) {
            UIView *companyView = [self getRowViewWithKey:@"Company" AndValue:user.company.name AndFrame:CGRectMake(0, [addressLbl superview].frame.origin.y + [addressLbl superview].frame.size.height + 8, self.view.frame.size.width, 44)];
            UITapGestureRecognizer *companyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(companyRowClicked)];
            companyTap.numberOfTapsRequired = 1;
            [companyView addGestureRecognizer:companyTap];
            companyLbl = (UILabel*)[companyView viewWithTag:1];
        }
        
        if(cashierLbl == nil) {
            UIView *cashierView = [self getRowViewWithKey:@"Cashiers" AndValue:[NSString stringWithFormat:@"%lu", (unsigned long)user.cashiers.count] AndFrame:CGRectMake(0, [companyLbl superview].frame.origin.y + [companyLbl superview].frame.size.height + 8, self.view.frame.size.width, 44)];
            UITapGestureRecognizer *cashierTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cashierRowClicked)];
            cashierTap.numberOfTapsRequired = 1;
            [cashierView addGestureRecognizer:cashierTap];
            cashierLbl = (UILabel*)[cashierView viewWithTag:1];
        }
        
        if(taskLbl == nil){
            UIView *taskView = [self getRowViewWithKey:@"Tasks" AndValue:@"" AndFrame:CGRectMake(0, [cashierLbl superview].frame.origin.y + [cashierLbl superview].frame.size.height + 8, self.view.frame.size.width, 44)];
            UITapGestureRecognizer *taskTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taskRowClicked)];
            taskTap.numberOfTapsRequired = 1;
            [taskView addGestureRecognizer:taskTap];
            taskLbl = (UILabel*)[taskView viewWithTag:1];
        }
        
        companyLbl.text = user.company.name;
        [cashierLbl setText:[NSString stringWithFormat:@"%lu", (unsigned long)user.cashiers.count]];
        signBtn.frame = CGRectMake(0, [taskLbl superview].frame.origin.y + [taskLbl superview].frame.size.height + 8, self.view.frame.size.width, 44);
    }else{
        UIView *companyRow = [companyLbl superview];
        companyLbl = nil;
        [companyRow removeFromSuperview];
        companyRow = nil;
        
        UIView *cashierRow = [cashierLbl superview];
        cashierLbl = nil;
        [cashierRow removeFromSuperview];
        cashierRow = nil;
        
        UIView *taskRow = [taskLbl superview];
        taskLbl = nil;
        [taskRow removeFromSuperview];
        taskRow = nil;
        
        signBtn.frame = CGRectMake(0, [addressLbl superview].frame.origin.y + [addressLbl superview].frame.size.height + 8, self.view.frame.size.width, 44);
    }
    
    [self updateContentHeight];
}

-(void) updateContentHeight{
    int contentHeight = MAX(signBtn.frame.origin.y + signBtn.frame.size.height, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height);

    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, contentHeight);
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
    
    if([value isEqualToString:@"qrcode"]){
        UIImageView *qrcodeIcon = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 48, 14, 16, 16)];
        [qrcodeIcon setImage:[UIImage imageNamed:@"qrode_black.png"]];
        [row addSubview:qrcodeIcon];
        
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"forward.png"]];
        arrow.frame = CGRectMake(self.view.frame.size.width - 24, 14, 16, 16);
        [row addSubview:arrow];
    }else{
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
    }
    
    [scrollView addSubview:row];
    
    return row;
}

- (void)showAvatarOptSheet:(id)sender {
    if(avatarOptSheet == nil){
        avatarOptSheet = [[UIActionSheet alloc] initWithTitle:@"Choose photo by"
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:@"Taking from camera", @"Picking from gallery",nil];
    }
    [avatarOptSheet showInView:self.view];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    if(buttonIndex == 0){
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else if(buttonIndex == 1){
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info valueForKey: UIImagePickerControllerOriginalImage];
    if(image != nil){
        UIImage *image = [info valueForKey: UIImagePickerControllerOriginalImage];
        if(image != nil){
            PECropViewController *controller = [[PECropViewController alloc] init];
            controller.delegate = self;
            controller.image = image;
            controller.keepingCropAspectRatio = YES;
            CGFloat width = image.size.width;
            CGFloat height = image.size.height;
            CGFloat length = MIN(width, height);
            controller.imageCropRect = CGRectMake((width - length) / 2,
                                                  (height - length) / 2,
                                                  length,
                                                  length);
            
            [[self navigationController] pushViewController:controller animated:YES];
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void) cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage{
    avatarIV.image = croppedImage;
    avatarBgView.image = croppedImage;
    
    if (croppedImage != nil){
        [self uploadAvatar:croppedImage];
    }
    
    [[self navigationController] popViewControllerAnimated:YES];
}

-(void) cropViewControllerDidCancel:(PECropViewController *)controller{
    [[self navigationController] popViewControllerAnimated:YES];
}

-(void) uploadAvatar:(UIImage*) image{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@ProfileController/uploadAvatar", baseUrl];
    [params setValue:[CommonUtils accessToken] forKey:@"accessToken"];

    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 1.0f) name:@"image" fileName:[NSString stringWithFormat:@"avatar_%f", [[NSDate date] timeIntervalSince1970]*1000] mimeType:@"image/jpeg"];
        
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSProgress *progress = nil;
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            [MozTopAlertView showWithType:MozAlertTypeError text:[error localizedDescription] doText:nil doBlock:nil parentView:self.view];
        } else {
            if([responseObject isKindOfClass:[NSDictionary class]]){
                NSDictionary *dic = (NSDictionary*) responseObject;
                NSString *err = [dic valueForKey:@"error"];
                if(![CommonUtils IsEmpty:err]) {
                    [MozTopAlertView showWithType:MozAlertTypeError text:err doText:nil doBlock:nil parentView:self.view];
                }else{
                    user.avatar.entityId = [[dic valueForKey:@"entityId"] intValue];
                    [MozTopAlertView showWithType:MozAlertTypeSuccess text:@"Successfully changed." doText:nil doBlock:nil parentView:self.view];
                }
            }else{
                [MozTopAlertView showWithType:MozAlertTypeError text:@"Unknown error." doText:nil doBlock:nil parentView:self.view];
            }
        }
    }];
    
    [uploadTask resume];
}

-(void) qrcodeRowClicked{
    [self performSegueWithIdentifier:@"userqr_fr_userinfo" sender:self];
}

-(void) phoneRowClicked{
    [self performSegueWithIdentifier:@"updatephone_fr_userinfo" sender:self];
}

-(void) addressRowClicked{
    [self performSegueWithIdentifier:@"updateaddress_fr_userinfo" sender:self];
}

-(void) companyRowClicked{
    [self performSegueWithIdentifier:@"company_fr_userinfo" sender:self];
}

-(void) cashierRowClicked{
    [self performSegueWithIdentifier:@"allcashiers_fr_userinfo" sender:self];
}

-(void) taskRowClicked{
    [self performSegueWithIdentifier:@"tasks_fr_userinfo" sender:self];
}

-(void) editUsername{
    [self performSegueWithIdentifier:@"updatename_fr_userinfo" sender:self];
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
    }else if([[segue identifier] isEqualToString:@"updatename_fr_userinfo"]){
        UpdateUsernameVC *updateNameVC = [segue destinationViewController];
        updateNameVC.delegate = self;
        updateNameVC.user = user;
    }else if([[segue identifier] isEqualToString:@"updateaddress_fr_userinfo"]){
        UpdateAddressVC *updateAddressVC = [segue destinationViewController];
        updateAddressVC.delegate = self;
        updateAddressVC.user = user;
    }else if([[segue identifier] isEqualToString:@"userqr_fr_userinfo"]){
        UserQRCodeVC *userQRCodeVC = [segue destinationViewController];
        userQRCodeVC.user = user;
    }else if ([[segue identifier] isEqualToString:@"allcashiers_fr_userinfo"]){
        CashierListVC *cashierVc = [segue destinationViewController];
        cashierVc.delegate = self;
    }
}

-(void) updatePhone:(NSString *)phone{
    phoneLbl.text = phone;
    user.profile.phone = phone;
}

-(void) updateFirstname:(NSString *)firstName andLastName:(NSString *)lastName{
    nameLbl.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    [nameLbl sizeToFit];
    nameLbl.center = CGPointMake(self.view.frame.size.width / 2, nameLbl.center.y);
    
    editNameBtn.frame = CGRectMake(nameLbl.frame.origin.x + nameLbl.frame.size.width + 4, nameLbl.frame.origin.y + 2, 20, 20);
    
    user.profile.firstName = firstName;
    user.profile.lastName = lastName;
}

-(void) updateBlk:(int)blk andStreet:(NSString *)street andUnit:(NSString *)unit andPost:(NSString*)post{
    if(user.profile.address == nil){
        user.profile.address = [[Address alloc] init];
    }
    user.profile.address.block = blk;
    user.profile.address.street = street;
    user.profile.address.unit = unit;
    user.profile.address.postCode = post;
    
    NSMutableString *addressStr = [NSMutableString string];
    if(user.profile.address.block != 0) {
        [addressStr appendString:[NSString stringWithFormat:@"Blk %i", user.profile.address.block]];
    }
    
    if(![CommonUtils IsEmpty:user.profile.address.street]){
        [addressStr appendString:[NSString stringWithFormat:@" %@", user.profile.address.street]];
    }
    
    if (![CommonUtils IsEmpty:user.profile.address.unit]) {
        [addressStr appendString:[NSString stringWithFormat:@" %@", user.profile.address.unit]];
    }
    
    addressLbl.text = addressStr;
}

-(void) updateCashiers:(User *)cashier{
    for (int i = 0; i < user.cashiers.count; i++) {
        if([[user.cashiers objectAtIndex:i] entityId] == cashier.entityId){
            [user.cashiers removeObjectAtIndex:i];
        }
    }
    [cashierLbl setText:[NSString stringWithFormat:@"%lu", (unsigned long)user.cashiers.count]];
}

-(void) clearStore{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

-(void) viewDidDisappear:(BOOL)animated{
    
}

@end






























