//
//  Tag.m
//  Task
//
//  Created by Niu Changming on 31/12/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import "Tag.h"

@implementation Tag

@synthesize entityId;
@synthesize name;

-(id) initWithJson:(NSDictionary*) dic{
    self = [super init];
    
    if(self) {
        self.entityId = [[dic valueForKey:@"entityId"] intValue];
        self.name = [dic valueForKey:@"name"];
    }
    
    return self;
}

@end
