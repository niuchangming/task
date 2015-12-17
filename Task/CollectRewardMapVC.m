//
//  CollectRewardMapVC.m
//  Task
//
//  Created by Niu Changming on 7/12/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import "CollectRewardMapVC.h"
#import "CommonUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+MDQRCode.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "SDWebImage/UIImageView+WebCache.h"
#import "ConstantValues.h"
#import "Address.h"
#import "MozTopAlertView.h"

@interface CollectRewardMapVC ()

@end

@implementation CollectRewardMapVC

@synthesize mapView;
@synthesize job;
@synthesize addresses;
@synthesize loadingBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:1.3 longitude:103.8 zoom:12];
    
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    self.view = mapView;
    [self loadAddresses];
}

-(void) loadAddresses{
    if([CommonUtils IsEmpty:[CommonUtils accessToken]]) {
        [MozTopAlertView showWithType:MozAlertTypeError text:@"Login first." doText:nil doBlock:nil parentView:self.view];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@", baseUrl, @"ProfileController/companyAddresses"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[CommonUtils accessToken] forKey:@"accessToken"];
    [params setObject:[NSNumber numberWithInt:job.task.entityId] forKey: @"taskId"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *obj = (NSDictionary *)responseObject;
            NSString *errMsg = [obj valueForKey:@"error"];
            
            if(![CommonUtils IsEmpty:errMsg]){
                [MozTopAlertView showWithType:MozAlertTypeError text:errMsg doText:nil doBlock:nil parentView:self.view];
            }
        }else if([responseObject isKindOfClass:[NSArray class]] == YES){
            NSArray *array = (NSArray*) responseObject;
            addresses = [[NSMutableArray alloc] init];
            for(NSDictionary *data in array){
                Address *address = [[Address alloc]initWithJson:data];
                [addresses addObject:address];
                
                [self setupMapView];
            }
        }else{
            [MozTopAlertView showWithType:MozAlertTypeError text:@"Unknown error." doText:nil doBlock:nil parentView:self.view];
        }
        [loadingBar stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MozTopAlertView showWithType:MozAlertTypeError text:[error localizedDescription] doText:nil doBlock:nil parentView:self.view];
        [loadingBar stopAnimating];
    }];
    
    [loadingBar startAnimating];
}

-(void) setupMapView{
    for(int i = 0; i < addresses.count; i++){
        CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
        [geoCoder geocodeAddressString:[[addresses objectAtIndex:i] postCode] completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            CLLocation *location = placemark.location;
            CLLocationCoordinate2D coordinate = location.coordinate;
            
            if(i == 0){
                GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude longitude:coordinate.longitude zoom:12];
                [mapView setCamera:camera];
            }
            
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
            marker.title = [[addresses objectAtIndex:i] street];
            marker.snippet = [[addresses objectAtIndex:i] postCode];
            marker.map = mapView;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
