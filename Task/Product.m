//
//  Product.m
//  Task
//
//  Created by Niu Changming on 21/8/15.
//  Copyright (c) 2015 Ekoo Lab. All rights reserved.
//

#import "Product.h"

@implementation Product

@synthesize entityId;
@synthesize desc;
@synthesize merchantLink;
@synthesize price;
@synthesize productName;

-(id) initWithJson:(NSDictionary*) dic{
    self = [super init];
    
    if(self){
        self.entityId = [[dic valueForKey:@"entityId"] intValue];
        self.desc = [dic valueForKey:@"description"];
        self.merchantLink = [dic valueForKey:@"merchantLink"];
        self.price = [[dic valueForKey: @"price"] doubleValue];
        self.productName = [dic valueForKey:@"productName"];
    }
    
    return self;
}

@end
