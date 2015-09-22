//
//  ProfileVC.h
//  Task
//
//  Created by Niu Changming on 27/8/15.
//  Copyright (c) 2015 Ekoo Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginVC.h"

@interface ProfileVC : UIViewController <UINavigationControllerDelegate, LoginDelegate>
@property (weak, nonatomic) IBOutlet UIButton *signBtn;

- (IBAction)signBtnClicked:(id)sender;

@end
