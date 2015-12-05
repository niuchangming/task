//
//  UpdatePhoneVC.m
//  Task
//
//  Created by Niu Changming on 27/11/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import "UpdatePhoneVC.h"
#import "CommonUtils.h"
#import "ConstantValues.h"
#import "MozTopAlertView.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@interface UpdatePhoneVC ()

@end

@implementation UpdatePhoneVC

@synthesize phoneTf;
@synthesize savebtn;
@synthesize user;
@synthesize loadingBar;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [phoneTf.layer setCornerRadius:2.0f];
    [savebtn.layer setCornerRadius:2.0f];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, phoneTf.frame.size.height)];
    phoneTf.leftView = paddingView;
    phoneTf.leftViewMode = UITextFieldViewModeAlways;
    
    if(![CommonUtils IsEmpty:user.profile.phone]){
        phoneTf.text = user.profile.phone;
    }
}

- (IBAction)saveBtnClicked:(id)sender {
    [self submit];
}

-(void) submit{
    if([CommonUtils IsEmpty:[CommonUtils accessToken]]) {
        [MozTopAlertView showWithType:MozAlertTypeError text:@"Login first." doText:nil doBlock:nil parentView:self.view];
        return;
    }
    
    if([CommonUtils IsEmpty:phoneTf.text]){
        [MozTopAlertView showWithType:MozAlertTypeError text:@"Phone cannot be empty." doText:nil doBlock:nil parentView:self.view];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@", baseUrl, @"ProfileController/updatePhone"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: [CommonUtils accessToken] forKey: @"accessToken"];
    [params setObject:phoneTf.text forKey:@"phone"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([operation.responseString rangeOfString:@"Success"].location != NSNotFound) {
            [MozTopAlertView showWithType:MozAlertTypeSuccess text:@"Update successfully." doText:nil doBlock:nil parentView:self.view];
            if(delegate != nil && [delegate respondsToSelector:@selector(updatePhone:)]) {
                [delegate updatePhone:phoneTf.text];
            }
            [self.navigationController popViewControllerAnimated:YES]; 
        }else{
            [MozTopAlertView showWithType:MozAlertTypeError text:@"Unknown error." doText:nil doBlock:nil parentView:self.view];
        }
        [loadingBar stopAnimating];
        [savebtn setEnabled:true];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MozTopAlertView showWithType:MozAlertTypeError text:[error localizedDescription] doText:nil doBlock:nil parentView:self.view];
        [loadingBar stopAnimating];
        [savebtn setEnabled:true];
    }];
    
    [loadingBar startAnimating];
    [savebtn setEnabled:false];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end










