//
//  UpdateUsernameVC.m
//  Task
//
//  Created by Niu Changming on 29/11/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import "UpdateUsernameVC.h"

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
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, firstNameTf.frame.size.height)];
    firstNameTf.leftView = paddingView;
    firstNameTf.leftViewMode = UITextFieldViewModeAlways;
    lastNameTf.leftView = paddingView;
    lastNameTf.leftViewMode = UITextFieldViewModeAlways;
    
    [firstNameTf setText:user.profile.firstName];
    [lastNameTf setText:user.profile.lastName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


- (IBAction)saveBtnClicked:(id)sender {
}
@end
