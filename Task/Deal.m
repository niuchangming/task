
//
//  Deal.m
//  Task
//
//  Created by Niu Changming on 14/11/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import "Deal.h"

@implementation Deal

@synthesize entityId;
@synthesize receivedDatetime;
@synthesize qrcode;
@synthesize ip;

-(id) initWithJson:(NSDictionary*) dic{
    self = [super init];
    
    if(self){
        self.entityId = [[dic valueForKey:@"entityId"] intValue];
        self.receivedDatetime = [NSDate dateWithTimeIntervalSince1970:[[dic valueForKey:@"receivedDatetime"] intValue] / 1000];
        self.qrcode = [dic valueForKey:@"qrcode"];
        self.ip = [dic valueForKey:@"ip"];
    }
    
    return self;

}

@end
