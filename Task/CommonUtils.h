//
//  CommonUtils.h
//  KinTub
//
//  Created by Niu Changming on 3/3/15.
//  Copyright (c) 2015 ekoo lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface CommonUtils : NSObject
+ (BOOL)hasNetwork;

+ (BOOL)validateCamera;

+ (UIColor *)colorFromHexString:(NSString *)hexString;

+ (NSString *) stringWithCurrentDateBy:(NSString*) format;

+ (BOOL) IsEmpty:(id)thing;

+ (void)displayError:(NSString *)displayText;

+ (BOOL) isInt: (NSString*) str;

+ (BOOL)isValidEmail:(NSString *) emailStr;

+ (NSString*) accessToken;

+ (NSString*) role;

+ (CGRect)screenBounds;

+ (NSString*) convertDate2String: (NSDate*) date;

+ (AVCaptureVideoOrientation) videoOrientationFromCurrentDeviceOrientation;

@end
