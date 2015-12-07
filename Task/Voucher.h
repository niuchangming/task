//
//  Voucher.h
//  Task
//
//  Created by Niu Changming on 6/12/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reward.h"

@interface Voucher : NSObject

@property int entityId;
@property (strong, nonatomic) NSDate *exchangedDatetime;
@property (strong, nonatomic) NSDate *generateDatetime;
@property BOOL isValid;
@property double value;
@property Reward *reward;

-(id) initWithJson:(NSDictionary*) dic;

@end
