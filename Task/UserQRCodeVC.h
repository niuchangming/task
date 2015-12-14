//
//  UserQRCodeVC.h
//  Task
//
//  Created by Niu Changming on 11/12/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface UserQRCodeVC : UIViewController

@property (nonatomic, strong) User *user;
@property (weak, nonatomic) IBOutlet UIView *qrcodeBg;
@property (weak, nonatomic) IBOutlet UIImageView *avatarIv;
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeIv;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;

@end
