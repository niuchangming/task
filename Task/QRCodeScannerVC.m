//
//  QRCodeScannerVC.m
//  Task
//
//  Created by Niu Changming on 21/10/15.
//  Copyright © 2015 Ekoo Lab. All rights reserved.
//

#import "QRCodeScannerVC.h"
#import "CommonUtils.h"
#import "ConstantValues.h"
#import "NSString+URLEncode.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "MozTopAlertView.h"
#import <HHAlertView/HHAlertView.h>
#import "Deal.h"

@interface QRCodeScannerVC ()<HHAlertViewDelegate>{
    AVCaptureDevice * device;
    AVCaptureDeviceInput * input;
    AVCaptureMetadataOutput * output;
    AVCaptureSession * session;
    AVCaptureVideoPreviewLayer * preview;
    QRView *qrView;
    NSString *stringValue;
}

@end

@implementation QRCodeScannerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCamera];
    [self updateLayout];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![session isRunning]) {
        [self setupCamera];
    }
}

- (void)setupCamera{
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    output = [[AVCaptureMetadataOutput alloc]init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];

    session = [[AVCaptureSession alloc]init];
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([session canAddInput:input]){
        [session addInput:input];
    }
    if ([session canAddOutput:output]){
        [session addOutput:output];
    }
    
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    preview =[AVCaptureVideoPreviewLayer layerWithSession:session];
    preview.videoGravity =AVLayerVideoGravityResize;
    preview.frame =[CommonUtils screenBounds];
    [self.view.layer insertSublayer:preview atIndex:0];

    [session startRunning];
}

- (void)updateLayout {
    qrView.center = CGPointMake([CommonUtils screenBounds].size.width / 2, [CommonUtils screenBounds].size.height / 2);
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat screenWidth = self.view.frame.size.width;
    CGRect cropRect = CGRectMake((screenWidth - self.qrView.transparentArea.width) / 2,
                                 (screenHeight - self.qrView.transparentArea.height) / 2,
                                 self.qrView.transparentArea.width,
                                 self.qrView.transparentArea.height);
    
    [output setRectOfInterest:CGRectMake(cropRect.origin.y / screenHeight,
                                          cropRect.origin.x / screenWidth,
                                          cropRect.size.height / screenHeight,
                                          cropRect.size.width / screenWidth)];
    [self.view addSubview:self.qrView];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if ([metadataObjects count] > 0){
        [session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }else{
        [MozTopAlertView showWithType:MozAlertTypeError text:@"Scan error" doText:nil doBlock:nil parentView:self.view];
    }
    
    if(![CommonUtils IsEmpty:stringValue]){
        HHAlertView *alertview = [[HHAlertView alloc] initWithTitle:@"Redeem" detailText:@"Please click 'Redeem' button to redeem." cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Redeem"]];
        [alertview setEnterMode:HHAlertEnterModeFadeIn];
        [alertview setLeaveMode:HHAlertLeaveModeFadeOut];
        [alertview setMode:HHAlertViewModeWarning];
        [alertview setDelegate:self];
        [alertview show];
    }
}

-(void) HHAlertView:(HHAlertView *)alertview didClickButtonAnIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [alertview hide];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self syncWithServer:alertview];
    }
}

-(void) syncWithServer:(HHAlertView*) alertview{
    NSString *url = [NSString stringWithFormat:@"%@JobController/scanReciever?accessToken=%@&qrcode=%@", baseUrl, [[CommonUtils accessToken] URLEncode], [stringValue URLEncode]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        id object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&error];
        
        if(error != nil){
            [alertview setMode:HHAlertViewModeError];
            [alertview setDetailText:[error localizedDescription]];
            return;
        }
        
        if ([object isKindOfClass:[NSDictionary class]] == YES){
            NSString *errMsg = [object valueForKey:@"error"];
            if(![CommonUtils IsEmpty:errMsg]) {
                [alertview setMode:HHAlertViewModeError];
                [alertview setDetailText:errMsg];
            }else{
                [alertview setMode:HHAlertViewModeError];
                [alertview setDetailText:@"The data format is incorrect."];
            }
        }else if ([object isKindOfClass:[NSArray class]] == YES){
            NSArray *array = (NSArray*) object;
            NSMutableArray *deals = [[NSMutableArray alloc] init];
            for(NSDictionary *data in array){
                Deal *deal = [[Deal alloc]initWithJson:data];
                [deals addObject:deal];
            }
            
            if([deals count] > 0){
                [alertview setMode:HHAlertViewModeSuccess];
                [alertview setDetailText:[NSString stringWithFormat:@"Your have redeemed this voucher successfully, and You have sold %lu deal from us.", (unsigned long)[deals count]]];
            }else{
                [alertview setMode:HHAlertViewModeError];
                [alertview setDetailText:@"The parsing object is not Deal."];
            }
        }
        [alertview setOtherButtonTitles:nil];
        [alertview updateAlertView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [alertview setMode:HHAlertViewModeError];
        [alertview setDetailText:[error localizedDescription]];
        [alertview setOtherButtonTitles:nil];
        [alertview updateAlertView];
    }];
}

-(QRView *)qrView {
    if (!qrView) {
        CGRect screenRect = [CommonUtils screenBounds];
        qrView = [[QRView alloc] initWithFrame:screenRect];
        qrView.transparentArea = CGSizeMake(280, 280);
        qrView.backgroundColor = [UIColor clearColor];
    }
    return qrView;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [preview removeFromSuperlayer];
    [session stopRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

