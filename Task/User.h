//
//  User.h
//  Task
//
//  Created by Niu Changming on 26/8/15.
//  Copyright (c) 2015 Ekoo Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Image.h"
#import "Company.h"
#import "Profile.h"

@interface User : NSObject

@property int entityId;
@property (nonatomic, strong) Image *avatar;
@property (nonatomic, strong) NSString* email;
@property bool isActive;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) Company *company;
@property (nonatomic, strong) Profile *profile;
@property (nonatomic, strong) NSMutableArray *cashiers;

-(id) initWithJson:(NSDictionary*) dic;

@end
