//
//  UpdateAddressVC.m
//  Task
//
//  Created by Niu Changming on 1/12/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import "UpdateAddressVC.h"
#import "ConstantValues.h"
#import "CommonUtils.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "MozTopAlertView.h"

@interface UpdateAddressVC ()

@end

@implementation UpdateAddressVC

@synthesize user;
@synthesize blkTf;
@synthesize streetTf;
@synthesize unitTf;
@synthesize postTf;
@synthesize saveBtn;
@synthesize delegate;
@synthesize loadingBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [blkTf.layer setCornerRadius:2.0f];
    [streetTf.layer setCornerRadius:2.0f];
    [unitTf.layer setCornerRadius:2.0f];
    [postTf.layer setCornerRadius:2.0f];
    [saveBtn.layer setCornerRadius:2.0f];
    
    UIView *blkPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, blkTf.frame.size.height)];
    blkTf.leftView = blkPadding;
    blkTf.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *streetPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, streetTf.frame.size.height)];
    streetTf.leftView = streetPadding;
    streetTf.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *unitPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, streetTf.frame.size.height)];
    unitTf.leftView = unitPadding;
    unitTf.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *postPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, streetTf.frame.size.height)];
    postTf.leftView = postPadding;
    postTf.leftViewMode = UITextFieldViewModeAlways;
    
    
    if(user.profile.address.block == 0) {
        blkTf.text = @"";
    }else{
        [blkTf setText:[NSString stringWithFormat:@"%d", user.profile.address.block]];
    }
    [streetTf setText:user.profile.address.street];
    [unitTf setText:user.profile.address.unit];
    if(user.profile.address.postCode == 0){
        postTf.text = @"";
    }else{
        [postTf setText:[NSString stringWithFormat:@"%d", user.profile.address.postCode]];
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
    
    if([CommonUtils IsEmpty:streetTf.text]){
        [MozTopAlertView showWithType:MozAlertTypeError text:@"Street cannot be empty." doText:nil doBlock:nil parentView:self.view];
        return;
    }
    
    if([CommonUtils IsEmpty:postTf.text]){
        [MozTopAlertView showWithType:MozAlertTypeError text:@"Post code cannot be empty." doText:nil doBlock:nil parentView:self.view];
        return;
    }
    
    if([CommonUtils IsEmpty:unitTf.text]){
        [MozTopAlertView showWithType:MozAlertTypeError text:@"Unit no cannot be empty." doText:nil doBlock:nil parentView:self.view];
        return;
    }
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@", baseUrl, @"ProfileController/updateAddress"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: [CommonUtils accessToken] forKey: @"accessToken"];
    [params setObject:blkTf.text forKey:@"block"];
    [params setObject:streetTf.text forKey:@"street"];
    [params setObject:unitTf.text forKey:@"unit"];
    [params setObject:postTf.text forKey:@"postCode"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] == YES){
            NSDictionary *result = (NSDictionary*)responseObject;
            int blkNo = [[result valueForKey:@"block"] intValue];
            NSString *unit = [result valueForKey:@"unit"];
            int postCode = [[result valueForKey:@"postCode"] intValue];
            NSString *street = [result valueForKey:@"street"];
            if(delegate != nil && [delegate respondsToSelector:@selector(updateBlk:andStreet:andUnit:andPost:)]) {
                [delegate updateBlk:blkNo andStreet:street andUnit:unit andPost:postCode];
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













