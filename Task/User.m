//
//  User.m
//  Task
//
//  Created by Niu Changming on 26/8/15.
//  Copyright (c) 2015 Ekoo Lab. All rights reserved.
//

#import "User.h"
#import "CommonUtils.h"

@implementation User

@synthesize entityId;
@synthesize avatar;
@synthesize email;
@synthesize isActive;
@synthesize accessToken;
@synthesize role;
@synthesize company;
@synthesize profile;
@synthesize cashiers;

-(id) initWithJson:(NSDictionary*) dic{
    self = [super init];
    
    if(self){
        self.entityId = [[dic valueForKey:@"entityId"] intValue];
        self.email = [dic valueForKey:@"email"];
        self.isActive = [[dic valueForKey:@"isActive"] boolValue];
        self.accessToken = [dic valueForKey:@"accessToken"];
        self.role = [dic valueForKey:@"role"];
        
        NSArray *companyArr = [dic valueForKey:@"companys"];
        if(companyArr != nil && companyArr.count > 0){
            self.company = [[Company alloc] initWithJson: [companyArr objectAtIndex:0]];
        }else{
            self.company = [[Company alloc] init];
        }

        NSArray *profileArr = [dic valueForKey:@"profiles"];
        if(profileArr != nil && profileArr.count > 0){
            self.profile = [[Profile alloc] initWithJson: [profileArr objectAtIndex:0]];
        }else{
            self.profile = [[Profile alloc] init];
        }
        
        NSArray *imageArray = [dic valueForKey:@"avatars"];
        if(![imageArray isKindOfClass:[NSNull class]] && imageArray.count > 0){
            self.avatar = [[Image alloc] initWithJson:[imageArray objectAtIndex:0]];
        }else{
            self.avatar = [[Image alloc] init];
        }
        
        NSArray *cashierArray = [dic valueForKey:@"cashiers"];
        self.cashiers = [[NSMutableArray alloc] init];
        if(![cashierArray isKindOfClass:[NSNull class]] && cashierArray.count > 0){
            for(NSDictionary *cashierDic in cashierArray) {
                [self.cashiers addObject: [[User alloc] initWithJson:cashierDic]];
            }
        }
        
    }
    
    return self;
}

@end
