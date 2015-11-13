//
//  Job.m
//  Task
//
//  Created by Niu Changming on 6/11/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import "Job.h"

@implementation Job

@synthesize entityId;
@synthesize takenDatetime;
@synthesize jobToken;
@synthesize isDelete;
@synthesize accessCount;
@synthesize task;

-(id) initWithJson:(NSDictionary*) dic{
    self = [super init];
    
    if(self){
        self.entityId = [[dic valueForKey:@"entityId"] intValue];
        self.takenDatetime = [NSDate dateWithTimeIntervalSince1970:[[dic valueForKey:@"takenDatetime"] intValue] / 1000];
        self.jobToken = [dic valueForKey:@"jobToken"];
        self.isDelete = [[dic valueForKey:@"isActive"] boolValue];
        self.accessCount = [[dic valueForKey:@"accessCount"] intValue];
        self.task = [[Task alloc] initWithJson: [[dic valueForKey:@"task"] objectAtIndex:0]];
    }
    
    return self;
}

@end
