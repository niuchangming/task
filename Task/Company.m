//
//  Company.m
//  Task
//
//  Created by Niu Changming on 16/11/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import "Company.h"
#import "Address.h"

@implementation Company

@synthesize entityId;
@synthesize contactNo;
@synthesize descrption;
@synthesize fax;
@synthesize name;
@synthesize verifyStatus;
@synthesize addresses;
@synthesize logo;

-(id) initWithJson:(NSDictionary*) dic{
    self = [super init];
    
    if(self){
        self.entityId = [[dic valueForKey:@"entityId"] intValue];
        self.contactNo = [dic valueForKey:@"contactNo"];
        self.descrption = [dic valueForKey:@"descrption"];
        self.fax = [dic valueForKey:@"fax"];
        self.name = [dic valueForKey:@"name"];
        self.verifyStatus = [dic valueForKey:@"verifyStatus"];
        
        NSArray *addressArray = [dic valueForKey:@"addresses"];
        self.addresses = [[NSMutableArray alloc] init];
        if(![addressArray isKindOfClass:[NSNull class]] && addressArray.count > 0){
            for(NSDictionary *addrDic in addressArray) {
                [self.addresses addObject: [[Address alloc] initWithJson:addrDic]];
            }
        }
        
        NSArray *logoArray = [dic valueForKey:@"logos"];
        if(![logoArray isKindOfClass:[NSNull class]] && logoArray.count > 0){
            self.logo = [[Image alloc] initWithJson:[logoArray objectAtIndex:0]];
        }else{
            self.logo = [[Image alloc] init];
        }
    }
    
    return self;
    
}

@end











