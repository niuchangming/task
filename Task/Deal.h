//
//  Deal.h
//  Task
//
//  Created by Niu Changming on 14/11/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Deal : NSObject

@property int entityId;
@property (nonatomic, strong) NSDate *receivedDatetime;
@property (nonatomic, strong) NSString *qrcode;
@property (nonatomic, strong) NSString *ip;

-(id) initWithJson:(NSDictionary*) dic;

@end
