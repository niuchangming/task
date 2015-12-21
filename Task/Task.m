//
//  Task.m
//  Task
//
//  Created by Niu Changming on 17/8/15.
//  Copyright (c) 2015 Ekoo Lab. All rights reserved.
//

#import "Task.h"
#import "Product.h"
#import "Image.h"

@implementation Task

@synthesize entityId;
@synthesize desc;
@synthesize endDate;
@synthesize startDate;
@synthesize title;
@synthesize images;
@synthesize product;
@synthesize reward;
@synthesize tags;
@synthesize company;


-(id) initWithJson:(NSDictionary*) dic{
    self = [super init];
    
    if(self) {
        self.entityId = [[dic valueForKey:@"entityId"] intValue];
        self.desc = [dic valueForKey:@"description"];
        self.endDate = [NSDate dateWithTimeIntervalSince1970:[[dic valueForKey:@"endDate"] longValue] / 1000];
        self.startDate = [NSDate dateWithTimeIntervalSince1970:[[dic valueForKey:@"startDate"] longValue] / 1000];
        self.title = [dic valueForKey:@"title"];
        
        self.product = [[Product alloc] initWithJson: [[dic valueForKey:@"products"] objectAtIndex:0]];
        self.reward = [[Reward alloc] initWithJson: [[dic valueForKey:@"rewards"] objectAtIndex:0]];
        self.company = [[Company alloc] initWithJson:[dic valueForKey:@"company"]];
        
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
