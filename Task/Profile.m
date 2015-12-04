//
//  Profile.m
//  Task
//
//  Created by Niu Changming on 16/11/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import "Profile.h"

@implementation Profile

@synthesize entityId;
@synthesize firstName;
@synthesize lastName;
@synthesize phone;
@synthesize address;

-(id) initWithJson:(NSDictionary*) dic{
    self = [super init];
    
    if(self) {
        self.entityId = [[dic valueForKey:@"entityId"] intValue];
        self.firstName = [dic valueForKey:@"firstName"];
        self.lastName = [dic valueForKey:@"lastName"];
        self.phone = [dic valueForKey:@"phone"];
        self.address = [[Address alloc] initWithJson: [[dic valueForKey:@"addresses"] objectAtIndex:0]];
    }
    
    return self;
}

@end
