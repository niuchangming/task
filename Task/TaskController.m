//
//  ViewController.m
//  Task
//
//  Created by Niu Changming on 16/8/15.
//  Copyright (c) 2015 Ekoo Lab. All rights reserved.
//

#import "TaskController.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "ConstantValues.h"
#import "MozTopAlertView.h"
#import "Task.h"
#import <QuartzCore/QuartzCore.h>
#import "SDWebImage/UIImageView+WebCache.h"
#import "Image.h"
#import "TaskCell.h"
#import "Task.h"
#import "CommonUtils.h"
#import "LoginVC.h"
#import "TaskDetailVC.h"

@interface TaskController (){
    UIBarButtonItem *rightButton;
}

@end

@implementation TaskController

@synthesize tasks;
@synthesize taskTV;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
    setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.navigationController.navigationBar.translucent = NO;
    
    if ([taskTV respondsToSelector:@selector(setLayoutMargins:)]) {
        [taskTV setLayoutMargins:UIEdgeInsetsZero];
    }
    taskTV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self loadTasks];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([[CommonUtils role] isEqualToString:@"MERCHANT"] || [[CommonUtils role] isEqualToString:@"CASHIER"]){
        [self setupQRCodeBtn];
    }else{
        self.tabBarController.navigationItem.rightBarButtonItem = nil;
    }
}

-(void) setupQRCodeBtn{
    if(rightButton == nil){
        UIButton *qrcodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        qrcodeBtn.bounds = CGRectMake(0, 0, 30, 30);
        [qrcodeBtn addTarget:self action:@selector(qrScanner) forControlEvents:UIControlEventTouchUpInside];
        [qrcodeBtn setImage:[UIImage imageNamed:@"qrcode"] forState:UIControlStateNormal];
        [qrcodeBtn setImage:[UIImage imageNamed:@"qrcode_fill"] forState:UIControlStateHighlighted];
        
        rightButton = [[UIBarButtonItem alloc] initWithCustomView:qrcodeBtn];
    }
    self.tabBarController.navigationItem.rightBarButtonItem = rightButton;
}

-(void) loadTasks {
    NSString *url = [NSString stringWithFormat:@"%@%@", baseUrl, @"TaskController/tasks"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: [NSNumber numberWithInt:0] forKey: @"from"];
    [params setObject: [NSNumber numberWithInt:20] forKey: @"max"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] == YES){
            NSDictionary *obj = (NSDictionary *)responseObject;
            NSString *errMsg = [obj valueForKey:@"error"];
            [MozTopAlertView showWithType:MozAlertTypeError text:errMsg doText:nil doBlock:nil parentView:self.view];
        }else if ([responseObject isKindOfClass:[NSArray class]] == YES){
            NSArray *array = (NSArray*) responseObject;
            tasks = [[NSMutableArray alloc] init];
            for(NSDictionary *data in array){
                Task *task = [[Task alloc]initWithJson:data];
                [tasks addObject:task];
            }
            [taskTV reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MozTopAlertView showWithType:MozAlertTypeError text:[error localizedDescription] doText:nil doBlock:nil parentView:self.view];
    }];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [tasks count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"TaskCell";
    
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[TaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    Task *task = [tasks objectAtIndex:indexPath.row];
    cell.task = task;
    
    cell.bgView.layer.cornerRadius = 2;
    cell.bgView.clipsToBounds = YES;
    
    [cell.taskIV sd_setImageWithURL:[NSURL URLWithString:[[task.images objectAtIndex:0] thumbnailPath]]];
    cell.taskIV.layer.cornerRadius = 2;
    cell.taskIV.clipsToBounds = YES;
    
    [cell.companyLogoIV sd_setImageWithURL:[NSURL URLWithString:[task.company.logo thumbnailPath]] placeholderImage:[UIImage imageNamed:@"default_avatar.jpg"]];
    cell.companyLogoIV.layer.cornerRadius = 12;
    cell.companyLogoIV.clipsToBounds = YES;
    
    cell.companyNameLbl.text = task.company.name;
    
    cell.taskNameLbl.text = task.title;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }

    cell.bgView.layer.masksToBounds = NO;
    cell.bgView.layer.shadowOffset = CGSizeMake(0, 0.5);
    cell.bgView.layer.shadowRadius = 0.5;
    cell.bgView.layer.shadowOpacity = 0.6;
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"taskdetail_fr_home" sender:cell.task];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat aspectRatio = 264.0f/320;
    return aspectRatio * [UIScreen mainScreen].bounds.size.width;
}

-(void) qrScanner{
    if ([CommonUtils validateCamera]) {
        [self performSegueWithIdentifier:@"qrscan_fr_home" sender:nil];
    } else {
        [CommonUtils displayError:@"There is no camera available."];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"taskdetail_fr_home"]){
        TaskDetailVC *detailVc = [segue destinationViewController];
        detailVc.task = (Task*)sender;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end






















