//
//  Image.m
//  Task
//
//  Created by Niu Changming on 21/8/15.
//  Copyright (c) 2015 Ekoo Lab. All rights reserved.
//

#import "Image.h"

@implementation Image

@synthesize entityId;
@synthesize caption;

-(id) initWithJson:(NSDictionary*) dic{
    self = [super init];
    
    if(self){
        self.entityId = [[dic valueForKey:@"entityId"] intValue];
        self.caption = [dic valueForKey:@"caption"];
    }
    
    return self;
}

@end
