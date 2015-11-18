//
//  Profile.h
//  Task
//
//  Created by Niu Changming on 16/11/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Address.h"

@interface Profile : NSObject

@property int entityId;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) Address *address;

-(id) initWithJson:(NSDictionary*) dic;

@end
