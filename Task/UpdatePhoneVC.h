//
//  UpdatePhoneVC.h
//  Task
//
//  Created by Niu Changming on 27/11/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol UpdatePhoneDelegate <NSObject>

@optional
-(void) updatePhone:(NSString*) phone;

@end

@interface UpdatePhoneVC : UIViewController

@property (strong, nonatomic) User *user;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UIButton *savebtn;
@property (weak, nonatomic) id<UpdatePhoneDelegate> delegate;

- (IBAction)saveBtnClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingBar;

@end
