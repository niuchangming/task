//
//  UpdateUsernameVC.m
//  Task
//
//  Created by Niu Changming on 29/11/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import "UpdateUsernameVC.h"
#import "CommonUtils.h"
#import "ConstantValues.h"
#import "MozTopAlertView.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@interface UpdateUsernameVC ()

@end

@implementation UpdateUsernameVC

@synthesize firstNameTf;
@synthesize lastNameTf;
@synthesize saveBtn;
@synthesize loadingBar;
@synthesize delegate;
@synthesize user;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [firstNameTf.layer setCornerRadius:2.0f];
    [lastNameTf.layer setCornerRadius:2.0f];
    [saveBtn.layer setCornerRadius:2.0f];
    
    UIView *firstNamePadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, firstNameTf.frame.size.height)];
    firstNameTf.leftView = firstNamePadding;
    firstNameTf.leftViewMode = UITextFieldViewModeAlways;
    UIView *lastNamePadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, firstNameTf.frame.size.height)];
    lastNameTf.leftView = lastNamePadding;
    lastNameTf.leftViewMode = UITextFieldViewModeAlways;
    
    [firstNameTf setText:user.profile.firstName];
    [lastNameTf setText:user.profile.lastName];
}

- (IBAction)saveBtnClicked:(id)sender {
    [self submit];
}

-(void) submit{
    if([CommonUtils IsEmpty:[CommonUtils accessToken]]) {
        [MozTopAlertView showWithType:MozAlertTypeError text:@"Login first." doText:nil doBlock:nil parentView:self.view];
        return;
    }
    
    if([CommonUtils IsEmpty:firstNameTf.text]){
        [MozTopAlertView showWithType:MozAlertTypeError text:@"First name cannot be empty." doText:nil doBlock:nil parentView:self.view];
        return;
    }
    
    if([CommonUtils IsEmpty:lastNameTf.text]){
        [MozTopAlertView showWithType:MozAlertTypeError text:@"Last name cannot be empty." doText:nil doBlock:nil parentView:self.view];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@", baseUrl, @"ProfileController/updateUsername"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: [CommonUtils accessToken] forKey: @"accessToken"];
    [params setObject:firstNameTf.text forKey:@"firstName"];
    [params setObject:lastNameTf.text forKey:@"lastName"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] == YES){
            NSDictionary *result = (NSDictionary*)responseObject;
            NSString *firstName = [result valueForKey:@"firstName"];
            NSString *lastName = [result valueForKey:@"lastName"];
            if(delegate != nil && [delegate respondsToSelector:@selector(updateFirstname:andLastName:)]) {
                [delegate updateFirstname:firstName andLastName:lastName];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
           [MozTopAlertView showWithType:MozAlertTypeError text:@"Unknown error." doText:nil doBlock:nil parentView:self.view];
        }
        [loadingBar stopAnimating];
        [saveBtn setEnabled:true];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MozTopAlertView showWithType:MozAlertTypeError text:[error localizedDescription] doText:nil doBlock:nil parentView:self.view];
        [loadingBar stopAnimating];
        [saveBtn setEnabled:true];
    }];
    
    [loadingBar startAnimating];
    [saveBtn setEnabled:false];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
