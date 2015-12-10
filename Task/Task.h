//
//  Task.h
//  Task
//
//  Created by Niu Changming on 17/8/15.
//  Copyright (c) 2015 Ekoo Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"
#import "Reward.h"
#import "CommonUtils.h"
#import "Company.h"

@interface Task : NSObject

@property int entityId;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) Product *product;
@property (nonatomic, strong) Reward *reward;
@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, strong) Company *company;

-(id) initWithJson:(NSDictionary*) dic;

@end
