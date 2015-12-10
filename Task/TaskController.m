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
@synthesize taskCV;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
    setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.navigationController.navigationBar.translucent = NO;
    [self loadTasks];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([[CommonUtils role] isEqualToString:@"MERCHANT"]){
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
            [taskCV reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MozTopAlertView showWithType:MozAlertTypeError text:[error localizedDescription] doText:nil doBlock:nil parentView:self.view];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return tasks.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"task_cell";
    
    TaskCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    Task *task = [tasks objectAtIndex:indexPath.row];
    cell.task = task;
    cell.delegate = self;
    
    cell.avatarIV.layer.cornerRadius = 12;
    cell.avatarIV.clipsToBounds = YES;
    [cell.avatarIV sd_setImageWithURL:[NSURL URLWithString:task.company.logo.thumbnailPath] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    
    [cell.taskIV sd_setImageWithURL:[NSURL URLWithString:[[[task images] objectAtIndex:0] thumbnailPath]]];
    
    cell.taskNameLbl.text = task.title;
    cell.rewardLbl.text = task.reward.title;
    
    return cell;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TaskCell *cell = (TaskCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"taskdetail_fr_home" sender:cell.task];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
    
    CGSize size = flowLayout.itemSize;
    
    size.width = self.view.frame.size.width / 2 - 12;
    size.height = size.width * 214 / 148;
    
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 8;
}

-(void) addJobBtnClicked:(Task *)task{
    if([CommonUtils IsEmpty:[CommonUtils accessToken]]) {
        [self performSegueWithIdentifier:@"login_fr_home" sender:self];
        return;
    }
    
    [self addJobByTaskId:task.entityId];
}

- (void) addJobByTaskId:(int) taskId{
    NSString *url = [NSString stringWithFormat:@"%@%@", baseUrl, @"JobController/addJob"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: [NSNumber numberWithInt:taskId] forKey: @"taskId"];
    [params setObject: [CommonUtils accessToken] forKey: @"accessToken"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] == YES){
            NSDictionary *obj = (NSDictionary *)responseObject;
            NSString *errMsg = [obj valueForKey:@"error"];
            if(![CommonUtils IsEmpty:errMsg]){
                [MozTopAlertView showWithType:MozAlertTypeError text:errMsg doText:nil doBlock:nil parentView:self.view];
            }else{
                [MozTopAlertView showWithType:MozAlertTypeSuccess text:@"Successfully Added !" doText:nil doBlock:nil parentView:self.view];
            }
        }else{
           [MozTopAlertView showWithType:MozAlertTypeError text:@"The format is incorrect for returned data." doText:nil doBlock:nil parentView:self.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MozTopAlertView showWithType:MozAlertTypeError text:[error localizedDescription] doText:nil doBlock:nil parentView:self.view];
    }];
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






















