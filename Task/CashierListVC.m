//
//  CashierListVC.m
//  Task
//
//  Created by Niu Changming on 14/12/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import "CashierListVC.h"
#import "CommonUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+MDQRCode.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "SDWebImage/UIImageView+WebCache.h"
#import "ConstantValues.h"
#import "MozTopAlertView.h"
#import "User.h"

@interface CashierListVC ()

@end

@implementation CashierListVC

@synthesize cashisers;
@synthesize cashierTb;
@synthesize loadingBar;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    if ([cashierTb respondsToSelector:@selector(setLayoutMargins:)]) {
        [cashierTb setLayoutMargins:UIEdgeInsetsZero];
    }
    cashierTb.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    
    [self loadCashiers];
}

-(void) loadCashiers{
    if([CommonUtils IsEmpty:[CommonUtils accessToken]]) {
        [MozTopAlertView showWithType:MozAlertTypeError text:@"Login first." doText:nil doBlock:nil parentView:self.view];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@", baseUrl, @"ProfileController/cashiers"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[CommonUtils accessToken] forKey:@"accessToken"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] == YES){
            NSDictionary *obj = (NSDictionary *)responseObject;
            NSString *errMsg = [obj valueForKey:@"error"];
            [MozTopAlertView showWithType:MozAlertTypeError text:errMsg doText:nil doBlock:nil parentView:self.view];
        }else if ([responseObject isKindOfClass:[NSArray class]] == YES){
            NSArray *array = (NSArray*) responseObject;
            cashisers = [[NSMutableArray alloc] init];
            for(NSDictionary *data in array){
                User *user = [[User alloc]initWithJson:data];
                [cashisers addObject:user];
            }
            [cashierTb reloadData];
        }
        [loadingBar stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MozTopAlertView showWithType:MozAlertTypeError text:[error localizedDescription] doText:nil doBlock:nil parentView:self.view];
        [loadingBar stopAnimating];
    }];
    
    [loadingBar startAnimating];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [cashisers count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cashierCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    User *cashier = [cashisers objectAtIndex:indexPath.row];
    
    UIImageView *avatarIv = (UIImageView *)[cell viewWithTag:1];
    avatarIv.layer.cornerRadius = 32;
    avatarIv.layer.masksToBounds = YES;
    [avatarIv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@ProfileController/showAvatarById?id=%i",[baseUrl stringByReplacingOccurrencesOfString:@"api/" withString:@""], cashier.avatar.entityId]] placeholderImage:[UIImage imageNamed:@"default_avatar.jpg"]];
    
    
    
    
    UILabel *nameLbl = (UILabel *)[cell viewWithTag:2];
    if([CommonUtils IsEmpty:cashier.profile.lastName] && [CommonUtils IsEmpty:cashier.profile.firstName]){
        nameLbl.text = cashier.email;
    }else{
        nameLbl.text = [NSString stringWithFormat:@"%@ %@", cashier.profile.firstName, cashier.profile.lastName];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteCashier:[cashisers objectAtIndex:indexPath.row]];
        [cashisers removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void) deleteCashier:(User*) cashier{
    if([CommonUtils IsEmpty:[CommonUtils accessToken]]) {
        [MozTopAlertView showWithType:MozAlertTypeError text:@"Login first." doText:nil doBlock:nil parentView:self.view];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@", baseUrl, @"ProfileController/removeCashier"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInt:cashier.entityId] forKey:@"entityId"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] == YES){
            NSDictionary *obj = (NSDictionary *)responseObject;
            NSString *errMsg = [obj valueForKey:@"error"];
            NSString *successMsg = [obj valueForKey:@"success"];
            if(![CommonUtils IsEmpty:errMsg]){
                [MozTopAlertView showWithType:MozAlertTypeError text:errMsg doText:nil doBlock:nil parentView:self.view];
            }
            
            if(![CommonUtils IsEmpty:successMsg]){
                [MozTopAlertView showWithType:MozAlertTypeSuccess text:successMsg doText:nil doBlock:nil parentView:self.view];
                
                if(delegate != nil && [delegate respondsToSelector:@selector(updateCashiers:)]) {
                    [delegate updateCashiers:cashier];
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MozTopAlertView showWithType:MozAlertTypeError text:[error localizedDescription] doText:nil doBlock:nil parentView:self.view];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
