//
//  CompanyVC.m
//  Task
//
//  Created by Niu Changming on 10/1/16.
//  Copyright © 2016 Ekoo Lab. All rights reserved.
//

#import "CompanyVC.h"
#import "MozTopAlertView.h"
#import "ConstantValues.h"
#import "UIImage+MDQRCode.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "SDWebImage/UIImageView+WebCache.h"
#import "Company.h"
#import "CommonUtils.h"

@interface CompanyVC ()

@end

@implementation CompanyVC

@synthesize logoIv;
@synthesize companyName;
@synthesize companyIntrTv;
@synthesize companys;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadCompany];
}

-(void)loadCompany{
    if([CommonUtils IsEmpty:[CommonUtils accessToken]]) {
        [MozTopAlertView showWithType:MozAlertTypeError text:@"Login first." doText:nil doBlock:nil parentView:self.view];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@", baseUrl, @"ProfileController/getCompanyInfo"];
    
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
            companys = [[NSMutableArray alloc] init];
            for(NSDictionary *data in array){
                Company *company = [[Company alloc]initWithJson:data];
                [companys addObject:company];
            }
            [self setupViews];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MozTopAlertView showWithType:MozAlertTypeError text:[error localizedDescription] doText:nil doBlock:nil parentView:self.view];
    }];
}

-(void) setupViews{
    if(companys != nil && [companys count] > 0){
        [logoIv sd_setImageWithURL:[NSURL URLWithString:[[companys objectAtIndex:0] logo].thumbnailPath] placeholderImage:[UIImage imageNamed:@"default_avatar.jpg"]];
        
        companyName.text = [[companys objectAtIndex:0] name];
        companyIntrTv.text = [[companys objectAtIndex:0] descrption];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
