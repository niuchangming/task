//
//  Company.h
//  Task
//
//  Created by Niu Changming on 16/11/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Image.h"

@interface Company : NSObject

@property int entityId;
@property (nonatomic, strong) NSString *contactNo;
@property (nonatomic, strong) NSString *descrption;
@property (nonatomic, strong) NSString *fax;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *verifyStatus;
@property (nonatomic, strong) NSMutableArray *addresses;
@property (nonatomic, strong) Image *logo;

-(id) initWithJson:(NSDictionary*) dic;

@end
