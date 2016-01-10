//
//  MyTask.h
//  Task
//
//  Created by Niu Changming on 10/1/16.
//  Copyright © 2016 Ekoo Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Job.h"

@interface MyTask : NSObject

@property int entityId;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *jobs;

-(id) initWithJson:(NSDictionary*) dic;

@end
