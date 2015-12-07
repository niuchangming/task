//
//  RewardVC.m
//  Task
//
//  Created by Niu Changming on 5/12/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import "RewardVC.h"
#import "CommonUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+MDQRCode.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "SDWebImage/UIImageView+WebCache.h"
#import "ConstantValues.h"
#import "MozTopAlertView.h"
#import "Image.h"
#import <CircleProgressBar/CircleProgressBar.h>
#import "CollectRewardMapVC.h"

@interface RewardVC (){
    UIView *topViewBg;
    UIView *midViewBg;
    UILabel *valueLbl;
    UILabel *expLbl;
    UILabel *processLbl;
    UIButton *pinBtn;
    UIWebView *instructionWeb;
    NSMutableArray *imageViews;
    CircleProgressBar *circleProgressbar;
}

@end

@implementation RewardVC

@synthesize job;
@synthesize loadingBar;
@synthesize voucher;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    imageViews = [[NSMutableArray alloc] init];
    self.navigationItem.title = job.task.reward.title;
    
    [self loadVoucher];
}

-(void) loadVoucher{
    if([CommonUtils IsEmpty:[CommonUtils accessToken]]) {
        [MozTopAlertView showWithType:MozAlertTypeError text:@"Login first." doText:nil doBlock:nil parentView:self.view];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@", baseUrl, @"JobController/voucher"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[CommonUtils accessToken] forKey:@"accessToken"];
    [params setObject:[NSNumber numberWithInt:job.entityId] forKey: @"jobId"];
    if([job.task.reward.rewardType isEqualToString:@"COMMISSION"]){
        double commission = (double)round((job.task.product.price - job.task.product.coupon.value) * job.task.reward.value) * (double)job.deals.count;
        [params setObject: [NSNumber numberWithDouble:commission] forKey:@"value"];
    }else{
        [params setObject: [NSNumber numberWithDouble:job.task.reward.value] forKey:@"value"];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject isKindOfClass:[NSDictionary class]]) {
            voucher = [[Voucher alloc] initWithJson:responseObject];
            [self setupViews];
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

-(void) setupViews{
    // Top View
    topViewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    [topViewBg setBackgroundColor: [CommonUtils colorFromHexString:@"#FF4444"]];
    [self.view addSubview:topViewBg];
    
    // Value Label
    valueLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    valueLbl.center = CGPointMake(topViewBg.frame.size.width / 2, topViewBg.frame.size.height / 2);
    valueLbl.textAlignment = NSTextAlignmentCenter;
    valueLbl.textColor = [UIColor whiteColor];
    valueLbl.layer.shadowRadius = 1.0;
    valueLbl.layer.shadowOpacity = 0.6;
    valueLbl.layer.shadowColor = [[CommonUtils colorFromHexString:@"#4A4A4A"] CGColor];
    valueLbl.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    
    UIFont *arialFont = [UIFont fontWithName:@"Chalkboard SE" size:32.0];
    NSDictionary *arialDict = [NSDictionary dictionaryWithObject: arialFont forKey:NSFontAttributeName];
    NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:@"S$" attributes: arialDict];
    
    UIFont *VerdanaFont = [UIFont fontWithName:@"Chalkboard SE" size:64.0];
    NSDictionary *verdanaDict = [NSDictionary dictionaryWithObject:VerdanaFont forKey:NSFontAttributeName];
    NSMutableAttributedString *vAttrString = [[NSMutableAttributedString alloc]initWithString:@"917" attributes:verdanaDict];
    
    [aAttrString appendAttributedString:vAttrString];
    
    valueLbl.attributedText = aAttrString;
    [topViewBg addSubview:valueLbl];
    
    // Expired date label
    UILabel *expTitleLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, topViewBg.frame.origin.y + topViewBg.frame.size.height - 28, 32, 20)];
    [expTitleLbl setBackgroundColor:[UIColor whiteColor]];
    [expTitleLbl setFont:[UIFont systemFontOfSize:12]];
    expTitleLbl.textAlignment = NSTextAlignmentCenter;
    expTitleLbl.text = @"Exp:";
    expTitleLbl.clipsToBounds = YES;
    expTitleLbl.textColor = [CommonUtils colorFromHexString:@"#FF4444"];
    CGRect bounds = expTitleLbl.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft)
                                                         cornerRadii:CGSizeMake(4.0, 4.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    expTitleLbl.layer.mask = maskLayer;
    [topViewBg addSubview:expTitleLbl];
    
    // Expired date value label
    expLbl = [[UILabel alloc]initWithFrame:CGRectMake(expTitleLbl.frame.origin.x + expTitleLbl.frame.size.width - 4, topViewBg.frame.origin.y + topViewBg.frame.size.height - 28, 96, 20)];
    [expLbl setFont:[UIFont systemFontOfSize:12]];
    expLbl.text = @"09-Dec-2015";
    expLbl.textColor = [UIColor whiteColor];
    expLbl.textAlignment = NSTextAlignmentCenter;
    expLbl.layer.cornerRadius = 4;
    expLbl.layer.borderColor = [UIColor whiteColor].CGColor;
    expLbl.layer.borderWidth = 1.0;
    [topViewBg addSubview:expLbl];
    
    midViewBg = [[UIView alloc] initWithFrame:CGRectMake(0, topViewBg.frame.size.height + 10, self.view.frame.size.width, 144)];
    [self.view addSubview:midViewBg];
    
    UIImageView *QRImageView = [[UIImageView alloc] initWithFrame:CGRectMake(midViewBg.frame.size.width / 2 - 72, 0, 144, 144)];
    QRImageView.image = [UIImage mdQRCodeForString:job.token size:QRImageView.bounds.size.width fillColor:[UIColor blackColor]];
    [midViewBg addSubview:QRImageView];
    
    // Circle Progress
    circleProgressbar = [[CircleProgressBar alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 144) / 4 - 36, 36, 72, 72)];
    [circleProgressbar setProgress:1.0f animated:NO];
    [circleProgressbar setProgressBarWidth:2];
    [circleProgressbar setProgressBarProgressColor:[CommonUtils colorFromHexString:@"#FF9500"]];
    [circleProgressbar setProgressBarTrackColor:[CommonUtils colorFromHexString:@"#BDBEC2"]];
    [circleProgressbar setHintViewBackgroundColor:[UIColor clearColor]];
    [circleProgressbar setBackgroundColor:[UIColor clearColor]];
    [midViewBg addSubview:circleProgressbar];
    
    processLbl = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 144) / 4 - 18, 49, 36, 36)];
    processLbl.text = @"73";
    processLbl.textColor = [CommonUtils colorFromHexString:@"#FF9500"];
    processLbl.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:32.0];
    processLbl.textAlignment = NSTextAlignmentCenter;
    [midViewBg addSubview:processLbl];
    
    UILabel *unitLbl = [[UILabel alloc] initWithFrame:CGRectMake(processLbl.frame.origin.x, processLbl.frame.origin.y + processLbl.frame.size.height - 5, processLbl.frame.size.width, 12)];
    unitLbl.text = @"Deals";
    unitLbl.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:12.0];
    unitLbl.textAlignment = NSTextAlignmentCenter;
    unitLbl.textColor = [CommonUtils colorFromHexString:@"#4A4A4A"];
    [midViewBg addSubview:unitLbl];
    
    
    int y = midViewBg.frame.origin.y + midViewBg.frame.size.height + 10;
    // Reward images
    if(job.task.reward.images.count > 0) {
        UILabel *rewardInfoLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, y, self.view.frame.size.width, 32)];
        rewardInfoLbl.text = @"Reward Image";
        rewardInfoLbl.textColor = [CommonUtils colorFromHexString:@"#4A4A4A"];
        rewardInfoLbl.textAlignment = NSTextAlignmentCenter;
        rewardInfoLbl.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
        [self.view addSubview:rewardInfoLbl];
        
        y = rewardInfoLbl.frame.origin.y + rewardInfoLbl.frame.size.height + 10;
        
        for(Image *image in job.task.reward.images){
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.width * 2 / 3)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[image.thumbnailPath stringByReplacingOccurrencesOfString:@"thumbnails" withString:@"attachments"]]];
            [self.view addSubview:imageView];
            [imageViews addObject:imageView];
            
            y = imageView.frame.origin.y + imageView.frame.size.height + 10;
        }
    }
    
    pinBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - ((self.view.frame.size.width - 144) / 4 + 36), 36, 72, 72)];
    [pinBtn setBackgroundColor:[CommonUtils colorFromHexString:@"#2196F3"]];
    pinBtn.layer.cornerRadius = 36;
    pinBtn.layer.masksToBounds = YES;
    pinBtn.layer.shadowOffset = CGSizeMake(1, 1);
    pinBtn.layer.shadowColor = [CommonUtils colorFromHexString:@"#4A4A4A"].CGColor;
    pinBtn.layer.shadowRadius = 1;
    pinBtn.layer.shadowOpacity = 1.0;
    [pinBtn setImage:[UIImage imageNamed:@"pin.png"] forState:UIControlStateNormal];
    [pinBtn setImageEdgeInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    [pinBtn addTarget:self action:@selector(pinBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [midViewBg addSubview:pinBtn];
    
    // Instruction WebView
    instructionWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, y, self.view.frame.size.width, 0)];
    instructionWeb.delegate = self;
    instructionWeb.scrollView.scrollEnabled = NO;
    instructionWeb.scrollView.bounces = NO;
    
    NSString *htmlString = [NSString stringWithFormat:@"<div style='font-family: HelveticaNeue-Thin; color:#4A4A4A; text-align:justify;'><p style='font-size: 18px; text-align: center;'><b>Terms & Conditions</b></p>%@</div>", job.task.reward.instruction];
    [instructionWeb loadHTMLString:htmlString baseURL:nil];
    
    [self.view addSubview:instructionWeb];
}

-(void) webViewDidFinishLoad:(UIWebView *)webView{
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    
    [self updateViewHeight];
}

-(void) pinBtnClicked:(id) sender{
    [self performSegueWithIdentifier:@"crm_fr_reward" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"crm_fr_reward"]){
        CollectRewardMapVC *vc = [segue destinationViewController];
        vc.job = self.job;
    }
}

-(void) updateViewHeight{
    int contentHeight = instructionWeb.frame.origin.y + instructionWeb.frame.size.height;
    ((UIScrollView *)self.view).contentSize = CGSizeMake(self.view.frame.size.width, contentHeight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
