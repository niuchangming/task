//
//  Job.h
//  Task
//
//  Created by Niu Changming on 6/11/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"

@interface Job : NSObject

@property int entityId;
@property (nonatomic, strong) NSDate *takenDatetime;
@property (nonatomic, strong) NSString *jobToken;
@property BOOL isDelete;
@property int accessCount;
@property (nonatomic, strong) Task *task;

-(id) initWithJson:(NSDictionary*) dic;

@end
