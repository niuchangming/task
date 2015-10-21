//
//  CommonUtils.m
//  KinTub
//
//  Created by Niu Changming on 3/3/15.
//  Copyright (c) 2015 ekoo lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUtils.h"
#import "ConstantValues.h"

@implementation CommonUtils

+ (BOOL) hasNetwork{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:@"http://www.google.com/"]];
    
    [request setHTTPMethod:@"HEAD"];
    
    NSHTTPURLResponse *response;
    
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&response error: NULL];
    
    return ([response statusCode] == 200) ? YES : NO;
}

+ (BOOL)validateCamera {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&
    [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (NSString *) stringWithCurrentDateBy:(NSString*) format{
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:format];
    return [DateFormatter stringFromDate:[NSDate date]];
}

+ (BOOL) IsEmpty:(id)thing {
    return thing == nil
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0)
    || [thing isEqual: [NSNull null]];
}

+ (void)displayError:(NSString *)displayText{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:displayText
                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

+ (NSString*) accessToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * accessToken = [defaults objectForKey:@"access_token"];
    return accessToken;
}

+ (BOOL)isValidEmail:(NSString *) emailStr{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

+ (BOOL) isInt: (NSString*) str{
    if ([str isEqualToString:@"0"])
        return YES;
    return (str.intValue != 0);
}

+ (CGRect)screenBounds {
    UIScreen *screen = [UIScreen mainScreen];
    CGRect screenRect;
    if (![screen respondsToSelector:@selector(fixedCoordinateSpace)] && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        screenRect = CGRectMake(0, 0, screen.bounds.size.height, screen.bounds.size.width);
    } else {
        screenRect = screen.bounds;
    }
    
    return screenRect;
    
}

+ (AVCaptureVideoOrientation) videoOrientationFromCurrentDeviceOrientation {
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait) {
        NSLog(@"UIInterfaceOrientationPortrait");
        return AVCaptureVideoOrientationPortrait;
        
    } else if (orientation == UIInterfaceOrientationLandscapeLeft) {
        NSLog(@"AVCaptureVideoOrientationLandscapeLeft");
        return AVCaptureVideoOrientationLandscapeLeft;
        
    } else if (orientation == UIInterfaceOrientationLandscapeRight){
        NSLog(@"UIInterfaceOrientationLandscapeRight");
        return AVCaptureVideoOrientationLandscapeRight;
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        NSLog(@"UIInterfaceOrientationPortraitUpsideDown");
        return AVCaptureVideoOrientationPortraitUpsideDown;
    }
    
    return AVCaptureVideoOrientationPortrait;
}

@end






