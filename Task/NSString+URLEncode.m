//
//  NSString+URLEncode.m
//  Task
//
//  Created by Niu Changming on 28/8/15.
//  Copyright (c) 2015 Ekoo Lab. All rights reserved.
//

#import "NSString+URLEncode.h"

@implementation NSString (URLEncode)

- (NSString *)URLEncode {
    return [self URLEncodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)URLEncodeUsingEncoding:(NSStringEncoding)encoding {
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (__bridge CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding));
}

- (NSString *)URLDecode {
    return [self URLDecodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)URLDecodeUsingEncoding:(NSStringEncoding)encoding {
    return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                 (__bridge CFStringRef)self,
                                                                                                 CFSTR(""),
                                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding));
}

@end
