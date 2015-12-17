//
//  Address.h
//  Task
//
//  Created by Niu Changming on 16/11/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Address : NSObject

@property int entityId;
@property int block;
@property (nonatomic, strong) NSString *postCode;
@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *unit;

-(id) initWithJson:(NSDictionary*) dic;

@end
