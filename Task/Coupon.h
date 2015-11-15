//
//  Coupon.h
//  Task
//
//  Created by Niu Changming on 15/11/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Coupon : NSObject

@property int entityId;
@property (nonatomic, strong) NSString *instruction;
@property double value;
@property (strong, nonatomic) NSDate *expireDate;

-(id) initWithJson:(NSDictionary*) dic;

@end
