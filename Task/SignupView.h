
//
//  SignupView.h
//  Task
//
//  Created by Niu Changming on 12/11/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsetTextField.h"
#import "User.h"

@protocol SignupViewDelegate <NSObject>

@required
-(void) signupCompletedWithResponseData:(id)resp withError:(NSString*) err;

@end

@interface SignupView : UIView
@property (weak, nonatomic) IBOutlet InsetTextField *emailTV;
@property (weak, nonatomic) IBOutlet InsetTextField *passwordTV;
@property (weak, nonatomic) IBOutlet UIButton *signupBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingBar;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) id<SignupViewDelegate> delegate;
- (IBAction)signupBtnClicked:(id)sender;
- (IBAction)cancelBrnClicked:(id)sender;

@end
