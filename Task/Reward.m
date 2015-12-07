//
//  Reward.m
//  Task
//
//  Created by Niu Changming on 21/8/15.
//  Copyright (c) 2015 Ekoo Lab. All rights reserved.
//

#import "Reward.h"
#import "Image.h"

@implementation Reward

@synthesize entityId;
@synthesize collectAddress;
@synthesize collectPostCode;
@synthesize collectUnit;
@synthesize expireDate;
@synthesize instruction;
@synthesize minShares;
@synthesize rewardType;
@synthesize title;
@synthesize value;
@synthesize images;

-(id) initWithJson:(NSDictionary*) dic{
    self = [super init];
    
    if(self) {
        self.entityId = [[dic valueForKey:@"entityId"] intValue];
        self.collectAddress = [dic valueForKey:@"collectAddress"];
        self.collectPostCode = [dic valueForKey:@"collectPostCode"];
        self.collectUnit = [dic valueForKey:@"collectUnit"];
        self.expireDate = [NSDate dateWithTimeIntervalSince1970:[[dic valueForKey:@"expireDate"] intValue] / 1000];
        self.instruction = [dic valueForKey:@"instruction"];
        self.minShares = [[dic valueForKey:@"minShares"] intValue];
        self.rewardType = [dic valueForKey:@"rewardType"];
        self.title = [dic valueForKey:@"title"];
        self.value = [[dic valueForKey:@"value"] doubleValue];
        
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
