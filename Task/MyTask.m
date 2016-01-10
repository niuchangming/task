//
//  MyTask.m
//  Task
//
//  Created by Niu Changming on 10/1/16.
//  Copyright © 2016 Ekoo Lab. All rights reserved.
//

#import "MyTask.h"

@implementation MyTask

@synthesize entityId;
@synthesize desc;
@synthesize endDate;
@synthesize startDate;
@synthesize title;
@synthesize images;
@synthesize jobs;

-(id) initWithJson:(NSDictionary*) dic{
    self = [super init];
    
    if(self) {
        self.entityId = [[dic valueForKey:@"entityId"] intValue];
        self.desc = [dic valueForKey:@"description"];
        self.endDate = [NSDate dateWithTimeIntervalSince1970:[[dic valueForKey:@"endDate"] longValue] / 1000];
        self.startDate = [NSDate dateWithTimeIntervalSince1970:[[dic valueForKey:@"startDate"] longValue] / 1000];
        self.title = [dic valueForKey:@"title"];
        
        NSArray *jobArray = [dic valueForKey:@"jobs"];
        self.jobs = [[NSMutableArray alloc] init];
        if(![jobArray isKindOfClass:[NSNull class]] && jobArray.count > 0){
            for(NSDictionary *jobDic in jobArray) {
                [self.jobs addObject: [[Job alloc] initWithJson:jobDic]];
            }
        }
        
        NSArray *imageArray = [dic valueForKey:@"images"];
        self.images = [[NSMutableArray alloc] init];
        if(![imageArray isKindOfClass:[NSNull class]] && imageArray.count > 0){
            for(NSDictionary *imgDic in imageArray) {
                [self.images addObject: [[Image alloc] initWithJson:imgDic]];
            }
        }
    }
    
    return self;
}

@end
