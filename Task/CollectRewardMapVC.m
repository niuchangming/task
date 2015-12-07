//
//  CollectRewardMapVC.m
//  Task
//
//  Created by Niu Changming on 7/12/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import "CollectRewardMapVC.h"

@interface CollectRewardMapVC ()

@end

@implementation CollectRewardMapVC

@synthesize mapView;
@synthesize job;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:15];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    self.view = mapView;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = mapView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
