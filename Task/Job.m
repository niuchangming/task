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
@synthesize token;
@synthesize isDelete;
@synthesize accessCount;
@synthesize task;
@synthesize deals;

-(id) initWithJson:(NSDictionary*) dic{
    self = [super init];
    
    if(self){
        self.entityId = [[dic valueForKey:@"entityId"] intValue];
        self.takenDatetime = [NSDate dateWithTimeIntervalSince1970:[[dic valueForKey:@"takenDatetime"] longValue] / 1000];
        self.token = [dic valueForKey:@"token"];
        self.isDelete = [[dic valueForKey:@"isActive"] boolValue];
        self.accessCount = [[dic valueForKey:@"accessCount"] intValue];
        self.task = [[Task alloc] initWithJson: [dic valueForKey:@"task"]];
        
        NSArray *dealArray = [dic valueForKey:@"deals"];
        self.deals = [[NSMutableArray alloc] init];
        if(![dealArray isKindOfClass:[NSNull class]] && dealArray.count > 0){
            for(NSDictionary *dealDic in dealArray) {
                [self.deals addObject: [[Deal alloc] initWithJson:dealDic]];
            }
        }
    }
    
    return self;
}

@end
