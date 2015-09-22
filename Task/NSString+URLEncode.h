//
//  NSString+URLEncode.h
//  Task
//
//  Created by Niu Changming on 28/8/15.
//  Copyright (c) 2015 Ekoo Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncode)

- (NSString *)URLEncode;
- (NSString *)URLEncodeUsingEncoding:(NSStringEncoding)encoding;

- (NSString *)URLDecode;
- (NSString *)URLDecodeUsingEncoding:(NSStringEncoding)encoding;

@end
