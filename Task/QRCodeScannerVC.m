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

@interface QRCodeScannerVC (){
    AVCaptureDevice * device;
    AVCaptureDeviceInput * input;
    AVCaptureMetadataOutput * output;
    AVCaptureSession * session;
    AVCaptureVideoPreviewLayer * preview;
    QRView *qrView;
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
    NSString *stringValue;
    if ([metadataObjects count] >0){
        [session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    if([CommonUtils IsEmpty:stringValue]){
        [self syncWithServer:stringValue];
    }
}

-(void) syncWithServer:(NSString*) encryptStr{
    NSString *url = [NSString stringWithFormat:@"%@%@", baseUrl, @"JobController/scanReciever"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: [CommonUtils accessToken] forKey: @"accessToken"];
    [params setObject:[encryptStr URLEncode] forKey:@"qrcode"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MozTopAlertView showWithType:MozAlertTypeError text:[error localizedDescription] doText:nil doBlock:nil parentView:self.view];
        
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
