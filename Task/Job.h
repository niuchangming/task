//
//  Job.h
//  Task
//
//  Created by Niu Changming on 6/11/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"
#import "Deal.h"

@interface Job : NSObject

@property int entityId;
@property (nonatomic, strong) NSDate *takenDatetime;
@property (nonatomic, strong) NSString *token;
@property BOOL isDelete;
@property int accessCount;
@property (nonatomic, strong) Task *task;
@property (nonatomic, strong) NSMutableArray *deals;

-(id) initWithJson:(NSDictionary*) dic;

@end
