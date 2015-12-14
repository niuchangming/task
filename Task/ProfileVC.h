//
//  ProfileVC.h
//  Task
//
//  Created by Niu Changming on 27/8/15.
//  Copyright (c) 2015 Ekoo Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginVC.h"
#import "FXBlurView/FXBlurView.h"
#import "UpdatePhoneVC.h"
#import "UpdateUsernameVC.h"
#import "PECropViewController.h"
#import "UpdateAddressVC.h"
#import "CashierListVC.h"

@interface ProfileVC : UIViewController <UINavigationControllerDelegate, LoginDelegate, UpdatePhoneDelegate, UpdateUsernameDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, PECropViewControllerDelegate, UpdateAddressDelegate, CashierListDelegate>
@property (strong, nonatomic) UIButton *signBtn;
@property (weak, nonatomic) IBOutlet UIImageView *avatarBgView;
@property (weak, nonatomic) IBOutlet UIImageView *roleIV;
@property (weak, nonatomic) IBOutlet FXBlurView *avatarBlurView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingBar;

@property (strong, nonatomic) User *user;


@end
