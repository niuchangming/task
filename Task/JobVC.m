//
//  JobVCViewController.m
//  Task
//
//  Created by Niu Changming on 13/11/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import "JobVC.h"
#import "JobCell.h"
#import "ConstantValues.h"
#import "CommonUtils.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "SDWebImage/UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "MozTopAlertView.h"
#import "Job.h"
#import "Image.h"
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "CommonUtils.h"
#import "Reward.h"

@interface JobVC ()

@end

@implementation JobVC

@synthesize jobTb;
@synthesize loadingJobBar;
@synthesize jobs;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([jobTb respondsToSelector:@selector(setLayoutMargins:)]) {
        [jobTb setLayoutMargins:UIEdgeInsetsZero];
    }
    jobTb.allowsSelection = NO;
    [self loadMyJobs];
}

-(void) loadMyJobs{
    if([CommonUtils IsEmpty:[CommonUtils accessToken]]){
        [MozTopAlertView showWithType:MozAlertTypeError text:@"You have to login first." doText:nil doBlock:nil parentView:self.view];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@JobController/getJobsByUser", baseUrl];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: [CommonUtils accessToken] forKey: @"accessToken"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        id object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&error];
        
        if(error != nil){
            [MozTopAlertView showWithType:MozAlertTypeError text:@"Error" doText:nil doBlock:nil parentView:self.view];
            return;
        }
        
        if ([object isKindOfClass:[NSDictionary class]] == YES){
            NSDictionary *obj = (NSDictionary *)object;
            NSString *errMsg = [obj valueForKey:@"error"];
            if(![CommonUtils IsEmpty:errMsg]){
                [MozTopAlertView showWithType:MozAlertTypeError text:errMsg doText:nil doBlock:nil parentView:self.view];
            }
        }else if([object isKindOfClass:[NSArray class]] == YES){
            NSArray *array = (NSArray*) object;
            jobs = [[NSMutableArray alloc] init];
            for(NSDictionary *data in array){
                Job *job = [[Job alloc]initWithJson:data];
                [jobs addObject:job];
            }
            [jobTb reloadData];
        }else{
            [MozTopAlertView showWithType:MozAlertTypeError text:@"The format is incorrect for returned data." doText:nil doBlock:nil parentView:self.view];
        }
        [loadingJobBar stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MozTopAlertView showWithType:MozAlertTypeError text:[error localizedDescription] doText:nil doBlock:nil parentView:self.view];
        [loadingJobBar stopAnimating];
    }];
    
    [loadingJobBar startAnimating];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [jobs count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"JobCell";
    
    JobCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[JobCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    Job *job =[jobs objectAtIndex:indexPath.row];
    [cell.taskIV sd_setImageWithURL:[NSURL URLWithString:[[job.task.images objectAtIndex:0] thumbnailPath]]];
    cell.taskIV.layer.cornerRadius = 2;
    cell.taskIV.clipsToBounds = YES;
    
    [cell.taskNameLbl setText:job.task.title];
    cell.taskNameLbl.lineBreakMode = NSLineBreakByWordWrapping;
    cell.taskNameLbl.numberOfLines = 0;
    
    [cell.expiredLbl setText:[CommonUtils convertDate2String:job.task.endDate]];
    
    if([job.task.reward.rewardType isEqualToString:@"COMMISSION"]){
        cell.progressBar.hidden = YES;
        cell.comissionValueLbl.hidden = NO;
        cell.currencyLbl.hidden = NO;
        cell.comissionValueLbl.text = [NSString stringWithFormat:@"%i", (int)round(job.task.reward.value)];
    }else{
        cell.progressBar.hidden = NO;
        cell.comissionValueLbl.hidden = YES;
        cell.currencyLbl.hidden = YES;
        
        MDRadialProgressTheme *theme = [[MDRadialProgressTheme alloc] init];
        theme.completedColor = [CommonUtils colorFromHexString:@"#4CD964"];
        theme.incompletedColor = [CommonUtils colorFromHexString:@"#B9F6CA"];
        theme.thickness = 10;
        theme.centerColor = [UIColor clearColor];
        theme.sliceDividerHidden = YES;
        theme.labelColor = [CommonUtils colorFromHexString:@"#4A4A4A"];
        
        [cell.progressBar setTheme:theme];
        cell.progressBar.progressTotal = job.task.reward.minShares;
        cell.progressBar.progressCounter = job.accessCount;
        [((UILabel*)cell.progressBar.label) setFont:[UIFont systemFontOfSize:14]];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end



































