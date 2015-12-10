//
//  Voucher.m
//  Task
//
//  Created by Niu Changming on 6/12/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import "Voucher.h"
#import "CommonUtils.h"

@implementation Voucher

@synthesize entityId;
@synthesize exchangedDatetime;
@synthesize generateDatetime;
@synthesize isValid;
@synthesize value;
@synthesize reward;

-(id) initWithJson:(NSDictionary*) dic{
    self = [super init];
    
    if(self) {
        self.entityId = [[dic valueForKey:@"entityId"] intValue];
        if(![CommonUtils IsEmpty:[dic valueForKey:@"exchangedDatetime"]]){
            self.exchangedDatetime = [NSDate dateWithTimeIntervalSince1970:[[dic valueForKey:@"exchangedDatetime"] longValue] / 1000];
        }
        self.generateDatetime = [NSDate dateWithTimeIntervalSince1970:[[dic valueForKey:@"generateDatetime"] longValue] / 1000];
        self.isValid = [[dic valueForKey:@"isValid"] boolValue];
        self.value = [[dic valueForKey:@"value"] doubleValue];
        self.reward = [[Reward alloc] initWithJson: [dic valueForKey:@"reward"]];
    }
    
    return self;
}

@end
