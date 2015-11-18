//
//  Address.m
//  Task
//
//  Created by Niu Changming on 16/11/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import "Address.h"

@implementation Address

@synthesize entityId;
@synthesize block;
@synthesize postCode;
@synthesize street;
@synthesize unit;

-(id) initWithJson:(NSDictionary*) dic{
    self = [super init];
    
    if(self){
        self.entityId = [[dic valueForKey:@"entityId"] intValue];
        self.block = [[dic valueForKey:@"contactNo"] intValue];
        self.postCode = [[dic valueForKey:@"postCode"] intValue];
        self.street = [dic valueForKey:@"street"];
        self.unit = [dic valueForKey:@"unit"];
    }
    
    return self;
    
}

@end
