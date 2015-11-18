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
        if(![addressArray isKindOfClass:[NSNull class]] && addressArray.count > 0){
            self.addresses = [[NSMutableArray alloc] init];
            for(NSDictionary *addrDic in addressArray) {
                [self.addresses addObject: [[Address alloc] initWithJson:addrDic]];
            }
        }
    }
    
    return self;
    
}

@end











