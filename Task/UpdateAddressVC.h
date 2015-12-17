//
//  UpdateAddressVC.h
//  Task
//
//  Created by Niu Changming on 1/12/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol UpdateAddressDelegate <NSObject>

@optional
-(void) updateBlk:(int)blk andStreet:(NSString *) street andUnit:(NSString*) unit andPost:(NSString*) post;

@end

@interface UpdateAddressVC : UIViewController

@property (nonatomic, strong) User *user;
@property (weak, nonatomic) IBOutlet UITextField *blkTf;
@property (weak, nonatomic) IBOutlet UITextField *streetTf;
@property (weak, nonatomic) IBOutlet UITextField *unitTf;
@property (weak, nonatomic) IBOutlet UITextField *postTf;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) id<UpdateAddressDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingBar;

- (IBAction)saveBtnClicked:(id)sender;

@end
