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
@synthesize thumbnailPath;

-(id) initWithJson:(NSDictionary*) dic{
    self = [super init];
    
    if(self){
        self.entityId = [[dic valueForKey:@"entityId"] intValue];
        self.thumbnailPath = [dic valueForKey:@"thumbnailPath"];
    }
    
    return self;
}

@end
