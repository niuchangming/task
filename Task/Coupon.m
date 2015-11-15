//
//  Coupon.m
//  Task
//
//  Created by Niu Changming on 15/11/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import "Coupon.h"
#import "CommonUtils.h"

@implementation Coupon

@synthesize entityId;
@synthesize instruction;
@synthesize value;
@synthesize expireDate;

-(id) initWithJson:(NSDictionary*) dic{
    self = [super init];
    
    if(self){
        self.entityId = [[dic valueForKey:@"entityId"] intValue];
        
        if(![CommonUtils IsEmpty:[dic valueForKey:@"expireDate"]]) {
            self.expireDate = [NSDate dateWithTimeIntervalSince1970:[[dic valueForKey:@"expireDate"] intValue] / 1000];
        }

        self.instruction = [dic valueForKey:@"instruction"];
        self.value = [[dic valueForKey:@"value"] doubleValue];
    }
    
    return self;
    
}

@end
