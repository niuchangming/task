//
//  User.h
//  Task
//
//  Created by Niu Changming on 26/8/15.
//  Copyright (c) 2015 Ekoo Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Image.h"

@interface User : NSObject

@property int entityId;
@property (nonatomic, strong) Image *avatar;
@property (nonatomic, strong) NSString* email;
@property bool isActive;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *role;

-(id) initWithJson:(NSDictionary*) dic;

@end
