//
//  CollectRewardMapVC.h
//  Task
//
//  Created by Niu Changming on 7/12/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Job.h"
@import GoogleMaps;

@interface CollectRewardMapVC : UIViewController

@property (nonatomic, strong) GMSMapView *mapView;
@property (nonatomic, strong) Job *job;

@end
