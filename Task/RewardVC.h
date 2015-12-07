//
//  RewardVC.h
//  Task
//
//  Created by Niu Changming on 5/12/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Job.h"
#import "Voucher.h"

@interface RewardVC : UIViewController<UIWebViewDelegate>

@property (nonatomic, strong) Job *job;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingBar;
@property (strong, nonatomic) Voucher *voucher;

@end
