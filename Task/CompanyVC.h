//
//  CompanyVC.h
//  Task
//
//  Created by Niu Changming on 10/1/16.
//  Copyright © 2016 Ekoo Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *logoIv;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UITextView *companyIntrTv;
@property (strong, nonatomic) NSMutableArray *companys;

@end
