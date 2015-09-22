//
//  MozTopAlertView.m
//  MoeLove
//
//  Created by LuLucius on 14/12/7.
//  Copyright (c) 2014年 MOZ. All rights reserved.
//

#import "MozTopAlertView.h"
#import "UIFont+FontAwesome.h"
#import "NSString+FontAwesome.h"

#define MOZ_TEXTSIZE(text, font) [text length] > 0 ? [text \
sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;

#define hsb(h,s,b) [UIColor colorWithHue:h/360.0f saturation:s/100.0f brightness:b/100.0f alpha:1.0]

#define FlatSkyBlue hsb(204, 76, 86)
#define FlatGreen hsb(145, 77, 80)
#define FlatOrange hsb(28, 85, 90)
#define FlatRed hsb(6, 74, 91)
#define FlatSkyBlueDark hsb(204, 78, 73)
#define FlatGreenDark hsb(145, 78, 68)
#define FlatOrangeDark hsb(24, 100, 83)
#define FlatRedDark hsb(6, 78, 75)

@interface MozTopAlertView (){
    UIImageView *leftIcon;
}

@property (nonatomic, copy) dispatch_block_t nextTopAlertBlock;

@end

@implementation MozTopAlertView

- (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (BOOL)hasViewWithParentView:(UIView*)parentView{
    if ([self viewWithParentView:parentView]) {
        return YES;
    }
    return NO;
}

+ (MozTopAlertView*)viewWithParentView:(UIView*)parentView{
    NSArray *array = [parentView subviews];
    for (UIView *view in array) {
        if ([view isKindOfClass:[MozTopAlertView class]]) {
            return (MozTopAlertView *)view;
        }
    }
    return nil;
}

+ (MozTopAlertView*)viewWithParentView:(UIView*)parentView cur:(UIView*)cur{
    NSArray *array = [parentView subviews];
    for (UIView *view in array) {
        if ([view isKindOfClass:[MozTopAlertView class]] && view!=cur) {
            return (MozTopAlertView *)view;
        }
    }
    return nil;
}

+ (void)hideViewWithParentView:(UIView*)parentView{
    NSArray *array = [parentView subviews];
    for (UIView *view in array) {
        if ([view isKindOfClass:[MozTopAlertView class]]) {
            MozTopAlertView *alert = (MozTopAlertView *)view;
            [alert hide];
        }
    }
}

+ (MozTopAlertView*)showWithType:(MozAlertType)type text:(NSString*)text parentView:(UIView*)parentView{
    MozTopAlertView *alertView = [[MozTopAlertView alloc]initWithType:type text:text doText:nil];
    [parentView addSubview:alertView];
    [alertView show];
    return alertView;
}

+ (MozTopAlertView*)showWithType:(MozAlertType)type text:(NSString*)text doText:(NSString*)doText doBlock:(dispatch_block_t)doBlock parentView:(UIView*)parentView{
    MozTopAlertView *alertView = [[MozTopAlertView alloc]initWithType:type text:text doText:doText];
    alertView.doBlock = doBlock;
    [parentView addSubview:alertView];
    [alertView show];
    return alertView;
}

- (instancetype)initWithType:(MozAlertType)type text:(NSString*)text doText:(NSString*)doText// parentView:(UIView*)parentView
{
    self = [super init];
    if (self) {
        [self setType:type text:text doText:doText];
    }
    return self;
}

- (void)setType:(MozAlertType)type text:(NSString*)text{
    [self setType:type text:text doText:nil];
}

- (void)setType:(MozAlertType)type text:(NSString*)text doText:(NSString*)doText{
    _autoHide = YES;
    _duration = 3;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    [self setFrame:CGRectMake(0, -60, width, 40)];
    
    leftIcon = [[UIImageView alloc]initWithFrame:CGRectMake(16, 5, 30, 30)];
    leftIcon.backgroundColor = [UIColor clearColor];
    [self addSubview:leftIcon];
    
    switch (type) {
        case MozAlertTypeInfo:{
            self.backgroundColor = FlatSkyBlue;
            [leftIcon setImage:[UIImage imageNamed:@"info.png"]];
        }
            break;
        case MozAlertTypeSuccess:
            self.backgroundColor = FlatGreen;
            [leftIcon setImage:[UIImage imageNamed:@"ok.png"]];
            break;
        case MozAlertTypeWarning:
            self.backgroundColor = FlatOrange;
            [leftIcon setImage:[UIImage imageNamed:@"warning.png"]];
            break;
        case MozAlertTypeError:
            self.backgroundColor = FlatRed;
            [leftIcon setImage:[UIImage imageNamed:@"cancel.png"]];
            break;
        default:
            break;
    }
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, CGRectGetHeight(self.frame))];
    textLabel.backgroundColor = [UIColor clearColor];
    [textLabel setTextColor:[UIColor whiteColor]];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont systemFontOfSize:16];
    textLabel.text = text;
    [self addSubview:textLabel];
    
    leftIcon.layer.opacity = 0;
}

- (void)rightBtnAction{
    if (_doBlock) {
        _doBlock();
        _doBlock = nil;
    }
}

- (void)show{
    dispatch_block_t showBlock = ^{
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
            self.layer.position = CGPointMake(self.layer.position.x, self.layer.position.y + 60);
        } completion:^(BOOL finished) {
            leftIcon.layer.opacity = 1;
            leftIcon.transform = CGAffineTransformMakeScale(0, 0);
            
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
                leftIcon.transform = CGAffineTransformMakeScale(1, 1);
            } completion:^(BOOL finished) {
            }];
        }];
        
        [self performSelector:@selector(hide) withObject:nil afterDelay:_duration];
    };
    
    MozTopAlertView *lastAlert = [MozTopAlertView viewWithParentView:self.superview cur:self];
    if (lastAlert) {
        lastAlert.nextTopAlertBlock = ^{
            showBlock();
        };
        [lastAlert hide];
    }else{
        showBlock();
    }
}

- (void)hide{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
    [UIView animateWithDuration:0.2 animations:^{
        self.layer.position = CGPointMake(self.layer.position.x, self.layer.position.y - 60);
    } completion:^(BOOL finished) {
        if (_nextTopAlertBlock) {
            _nextTopAlertBlock();
            _nextTopAlertBlock = nil;
        }
        [self removeFromSuperview];
    }];

    if (_dismissBlock) {
        _dismissBlock();
        _dismissBlock = nil;
    }
}

-(void)setDuration:(NSInteger)duration{
    _duration = duration;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
    [self performSelector:@selector(hide) withObject:nil afterDelay:_duration];
}

-(void)setAutoHide:(BOOL)autoHide{
    if (autoHide && !_autoHide) {
        [self performSelector:@selector(hide) withObject:nil afterDelay:_duration];
    }else{
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
    }
    _autoHide = autoHide;
}

-(void)dealloc{
    _doBlock = nil;
    _dismissBlock = nil;
    _nextTopAlertBlock = nil;
}

@end
