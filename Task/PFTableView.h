//
//  PFTableView.h
//  PFNavigationDropdownMenu
//
//  Created by Cee on 02/08/2015.
//  Copyright (c) 2015 Cee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFConfiguration.h"

@protocol PFTableDelegate <NSObject>

@optional
-(void) didPFTableSelectedAtIndex:(NSInteger) index;

@end

@interface PFTableView : UITableView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PFConfiguration *configuration;
@property (nonatomic, copy) void(^selectRowAtIndexPathHandler)(NSUInteger indexPath);
@property (nonatomic, strong) id<PFTableDelegate> pfTableDelegate;

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items configuration:(PFConfiguration *)configuration;
@end
