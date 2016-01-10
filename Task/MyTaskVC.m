//
//  MyTaskVC.m
//  Task
//
//  Created by Niu Changming on 10/1/16.
//  Copyright © 2016 Ekoo Lab. All rights reserved.
//

#import "MyTaskVC.h"
#import "MozTopAlertView.h"
#import "ConstantValues.h"
#import "UIImage+MDQRCode.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "SDWebImage/UIImageView+WebCache.h"

@interface MyTaskVC ()

@end

@implementation MyTaskVC

@synthesize tasks;
@synthesize taskTb;
@synthesize loadingBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    if ([taskTb respondsToSelector:@selector(setLayoutMargins:)]) {
        [taskTb setLayoutMargins:UIEdgeInsetsZero];
    }
    taskTb.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
 
    [self loadMyTasks];
}

-(void) loadMyTasks{
    if([CommonUtils IsEmpty:[CommonUtils accessToken]]) {
        [MozTopAlertView showWithType:MozAlertTypeError text:@"Login first." doText:nil doBlock:nil parentView:self.view];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@", baseUrl, @"TaskController/getTasksByUser"];
    
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
            tasks = [[NSMutableArray alloc] init];
            for(NSDictionary *data in array){
                MyTask *user = [[MyTask alloc]initWithJson:data];
                [tasks addObject:user];
            }
            [taskTb reloadData];
        }
        [loadingBar stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MozTopAlertView showWithType:MozAlertTypeError text:[error localizedDescription] doText:nil doBlock:nil parentView:self.view];
        [loadingBar stopAnimating];
    }];
    
    [loadingBar startAnimating];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [tasks count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"mytaskCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    MyTask *task = [tasks objectAtIndex:indexPath.row];
    
    UIImageView *taskIv = (UIImageView*)[cell viewWithTag:1];
    [taskIv sd_setImageWithURL:[NSURL URLWithString:[[task.images objectAtIndex:0] thumbnailPath]]];
    
    UILabel *taskTitleLbl = (UILabel*)[cell viewWithTag:2];
    taskTitleLbl.text = task.title;
    
    UILabel *businessManCount = (UILabel*)[cell viewWithTag:3];
    businessManCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)[[task jobs] count]];
    
    UILabel *viewCountLbl = (UILabel*)[cell viewWithTag:4];
    int viewCount = 0;
    int dealCount = 0;
    for(Job *job in [task jobs]){
        viewCount += job.accessCount;
        dealCount += [job.deals count];
    }
    viewCountLbl.text = [NSString stringWithFormat:@"%d", viewCount];
    
    UILabel *dealCountLbl = (UILabel*) [cell viewWithTag:5];
    dealCountLbl.text = [NSString stringWithFormat:@"%d", dealCount];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }

    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
