//
//  Reward.h
//  Task
//
//  Created by Niu Changming on 21/8/15.
//  Copyright (c) 2015 Ekoo Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reward : NSObject

@property int entityId;
@property (nonatomic, strong) NSString *collectAddress;
@property (nonatomic, strong) NSString *collectPostCode;
@property (nonatomic, strong) NSString *collectUnit;
@property (nonatomic, strong) NSDate *expireDate;
@property (nonatomic, strong) NSString *instruction;
@property int minShares;
@property (nonatomic, strong) NSString *rewardType;
@property (nonatomic, strong) NSString *title;
@property double value;
@property (nonatomic, strong) NSMutableArray *images;

-(id) initWithJson:(NSDictionary*) dic;

@end
