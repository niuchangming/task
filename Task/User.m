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

-(id) initWithJson:(NSDictionary*) dic{
    self = [super init];
    
    if(self){
        self.entityId = [[dic valueForKey:@"entityId"] intValue];
        self.email = [dic valueForKey:@"email"];
        self.isActive = [[dic valueForKey:@"isActive"] boolValue];
        self.accessToken = [dic valueForKey:@"accessToken"];
        self.role = [dic valueForKey:@"role"];
        
        NSArray *companyDic = [dic valueForKey:@"companys"];
        if(![CommonUtils IsEmpty:companyDic]) {
            self.company = [[Company alloc] initWithJson: [companyDic objectAtIndex:0]];
        }
        
        NSArray *profileDic = [dic valueForKey:@"profiles"];
        if(![CommonUtils IsEmpty:profileDic]) {
            self.profile = [[Profile alloc] initWithJson: [profileDic objectAtIndex:0]];
        }
        
        NSArray *imageArray = [dic valueForKey:@"avatars"];
        if(![imageArray isKindOfClass:[NSNull class]] && imageArray.count > 0){
            self.avatar = [[Image alloc] initWithJson:[imageArray objectAtIndex:(imageArray.count - 1)]];
        }
        
    }
    
    return self;
}

@end
