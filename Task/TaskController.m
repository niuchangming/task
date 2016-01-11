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
#import "Tag.h"

@interface TaskController (){
    UIBarButtonItem *rightButton;
    Tag *selectedTag;
}

@end

@implementation TaskController

@synthesize tasks;
@synthesize taskTV;
@synthesize tags;
@synthesize selectedTagLbl;
@synthesize menuView;
@synthesize loadingBar;
@synthesize refresh;

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
    
    tasks = [[NSMutableArray alloc] init];
    
    tags = [[NSMutableArray alloc] init];
    Tag *tag = [[Tag alloc] init];
    tag.name = @"All";
    tag.entityId = 0;
    selectedTag = tag;
    [tags addObject:tag];
    
    refresh=[[DJRefresh alloc] initWithScrollView:taskTV delegate:self];
    refresh.topEnabled=FALSE;
    refresh.bottomEnabled=YES;
    
    [self initNavigationBar];
    [self getAllTags];
    [self loadTasksByTag:tag];
}

-(void) initNavigationBar{
    self.selectedTagLbl.text = [tags.firstObject name];
    
    menuView = [[PFNavigationDropdownMenu alloc] initWithFrame:CGRectMake(0, 0, 300, 44) title:[tags.firstObject name] items:tags containerView:self.view];
    
    menuView.cellHeight = 44;
    menuView.cellBackgroundColor = self.navigationController.navigationBar.barTintColor;
    menuView.cellSelectionColor = [CommonUtils colorFromHexString:@"#03A9F4"];
    menuView.cellTextLabelColor = [UIColor whiteColor];
    menuView.arrowPadding = 15;
    menuView.animationDuration = 0.5f;
    menuView.delegate = self;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([[CommonUtils role] isEqualToString:@"MERCHANT"] || [[CommonUtils role] isEqualToString:@"CASHIER"]){
        [self setupQRCodeBtn];
    }else{
        self.tabBarController.navigationItem.rightBarButtonItem = nil;
    }
    
    if(self.tabBarController.navigationItem.titleView == nil){
        self.tabBarController.navigationItem.titleView = menuView;
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

-(void) getAllTags{
    NSString *url = [NSString stringWithFormat:@"%@%@", baseUrl, @"TaskController/getAllTags"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]] == YES){
            NSArray *array = (NSArray*) responseObject;
            for(NSDictionary *data in array){
                Tag *tag = [[Tag alloc] initWithJson:data];
                [tags addObject:tag];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MozTopAlertView showWithType:MozAlertTypeError text:[error localizedDescription] doText:nil doBlock:nil parentView:self.view];
    }];
}

-(void) loadTasksByTag:(Tag*) tag{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: [NSNumber numberWithInt:(tasks == nil ? 0 : (int)[tasks count])] forKey: @"from"];
    [params setObject: [NSNumber numberWithInt:20] forKey: @"max"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", baseUrl, @"TaskController/tasks"];
    if(tag.entityId > 0){
        url = [NSString stringWithFormat:@"%@%@", baseUrl, @"TaskController/tasksByTag"];
        [params setObject:[NSNumber numberWithInt:tag.entityId] forKey:@"tagId"];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] == YES){
            NSDictionary *obj = (NSDictionary *)responseObject;
            NSString *errMsg = [obj valueForKey:@"error"];
            [MozTopAlertView showWithType:MozAlertTypeError text:errMsg doText:nil doBlock:nil parentView:self.view];
        }else if ([responseObject isKindOfClass:[NSArray class]] == YES){
            NSArray *array = (NSArray*) responseObject;
            for(NSDictionary *data in array){
                Task *task = [[Task alloc]initWithJson:data];
                [tasks addObject:task];
            }
            [taskTV reloadData];
        }
        [refresh finishRefreshingDirection:DJRefreshDirectionBottom animation:YES];
        [loadingBar stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MozTopAlertView showWithType:MozAlertTypeError text:[error localizedDescription] doText:nil doBlock:nil parentView:self.view];
        [refresh finishRefreshingDirection:DJRefreshDirectionBottom animation:YES];
        [loadingBar stopAnimating];
    }];
    
    [loadingBar startAnimating];
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

- (void)refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection) direction{
    if(DJRefreshDirectionBottom){
        [self loadTasksByTag:selectedTag];
    }
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

-(void) didDropdownMenuSelected:(NSUInteger)index{
    self.selectedTagLbl.text = [self.tags[index] name];
    selectedTag = self.tags[index];
    
    [tasks removeAllObjects];
    [taskTV reloadData];
    
    [self loadTasksByTag:self.tags[index]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end






















