//
//  CashierListVC.h
//  Task
//
//  Created by Niu Changming on 14/12/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol CashierListDelegate <NSObject>

@optional
-(void) updateCashiers:(User*) cashier;

@end

@interface CashierListVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *cashisers;
@property (weak, nonatomic) IBOutlet UITableView *cashierTb;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingBar;
@property (weak, nonatomic) id<CashierListDelegate> delegate;

@end
