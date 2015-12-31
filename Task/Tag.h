//
//  Tag.h
//  Task
//
//  Created by Niu Changming on 31/12/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tag : NSObject

@property int entityId;
@property (nonatomic, strong) NSString *name;

-(id) initWithJson:(NSDictionary*) dic;

@end
