//
//  UpdateUsernameVC.h
//  Task
//
//  Created by Niu Changming on 29/11/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol UpdateUsernameDelegate <NSObject>

@optional
-(void) updateFirstname:(NSString*) firstName andLastName:(NSString *) lastName;

@end

@interface UpdateUsernameVC : UIViewController

@property (strong, nonatomic) User *user;
@property (weak, nonatomic) id<UpdateUsernameDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *firstNameTf;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTf;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingBar;

- (IBAction)saveBtnClicked:(id)sender;

@end
