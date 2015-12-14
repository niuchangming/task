//
//  UserQRCodeVC.m
//  Task
//
//  Created by Niu Changming on 11/12/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import "UserQRCodeVC.h"
#import <QuartzCore/QuartzCore.h>
#import "SDWebImage/UIImageView+WebCache.h"
#import "UIImage+MDQRCode.h"
#import "CommonUtils.h"

@interface UserQRCodeVC ()

@end

@implementation UserQRCodeVC

@synthesize qrcodeBg;
@synthesize avatarIv;
@synthesize qrcodeIv;
@synthesize userNameLbl;
@synthesize user;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    qrcodeBg.layer.cornerRadius = 4.0;
    qrcodeBg.clipsToBounds = YES;
    
    if(![CommonUtils IsEmpty:user.profile.firstName] || ![CommonUtils IsEmpty:user.profile.lastName]) {
        userNameLbl.text = [NSString stringWithFormat:@"%@ %@", user.profile.firstName, user.profile.lastName];
    }
    
    [avatarIv sd_setImageWithURL:[NSURL URLWithString:user.avatar.thumbnailPath] placeholderImage:[UIImage imageNamed:@"default_avatar.jpg"]];
    
    qrcodeIv.image = [UIImage mdQRCodeForString:[NSString stringWithFormat:@"%@|cashier", [CommonUtils accessToken]] size:qrcodeIv.bounds.size.width fillColor:[UIColor blackColor]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
