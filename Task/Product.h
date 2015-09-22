//
//  Product.h
//  Task
//
//  Created by Niu Changming on 21/8/15.
//  Copyright (c) 2015 Ekoo Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property int entityId;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *merchantLink;
@property double price;
@property (nonatomic, strong) NSString *productName;

-(id) initWithJson:(NSDictionary*) dic;

@end
