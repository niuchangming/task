//
//  PFNavigationDropdownMenu.h
//  PFNavigationDropdownMenu
//
//  Created by Cee on 02/08/2015.
//  Copyright (c) 2015 Cee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFTableView.h"

@protocol PFNavigationDropdownMenuDelegate <NSObject>

@optional
-(void) didDropdownMenuSelected:(NSUInteger) index;

@end

@interface PFNavigationDropdownMenu : UIView<PFTableDelegate>
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) UIColor *cellBackgroundColor;
@property (nonatomic, strong) UIColor *cellTextLabelColor;
@property (nonatomic, strong) UIFont *cellTextLabelFont;
@property (nonatomic, strong) UIColor *cellSelectionColor;
@property (nonatomic, strong) UIImage *checkMarkImage;
@property (nonatomic, strong) UIImage *arrowImage;
@property (nonatomic, assign) CGFloat arrowPadding;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, strong) UIColor *maskBackgroundColor;
@property (nonatomic, assign) CGFloat maskBackgroundOpacity;
@property (nonatomic, weak) id<PFNavigationDropdownMenuDelegate> delegate;
@property (nonatomic, copy) void(^didSelectItemAtIndexHandler)(NSUInteger indexPath);


- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                        items:(NSArray *)items
                containerView:(UIView *)containerView;
@end
