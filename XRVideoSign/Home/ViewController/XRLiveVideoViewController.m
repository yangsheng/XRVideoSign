//
//  XRLiveVideoViewController.m
//  XRVideoSign
//
//  Created by zhu yangsheng on 1/24/19.
//  Copyright © 2019 xrinfo. All rights reserved.
//

#import "XRLiveVideoViewController.h"
#import "XRFaceLiveFourRequest.h"
#import "CCNetworkHelper.h"
#import "uploadLiveFaceRequest.h"

#import "FFCircularProgressView.h"
#import "WRNavigationBar.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define ScreenWith     [UIScreen mainScreen].bounds.size.width
#define ScreenHeight   [UIScreen mainScreen].bounds.size.height

typedef void(^PropertyChangeBlock) (AVCaptureDevice * captureDevice);

@interface XRLiveVideoViewController ()<AVCaptureFileOutputRecordingDelegate>//视频文件输出代理

@property (nonatomic,strong) UILabel *codeLabel;
@property (nonatomic,strong) NSString *strCode;
//负责输入和输出设备之间的数据传输
@property (nonatomic, strong) AVCaptureSession * captureSession;
//负责从AVCaptureDevice获得输入数据
@property (nonatomic, strong) AVCaptureDeviceInput * captureDeviceInput;
//照片输出流
@property (nonatomic, strong) AVCaptureStillImageOutput * captureStillImageOutput;
//视频输出流
@property (nonatomic, strong) AVCaptureMovieFileOutput * captureMovieFileOutPut;
@property (assign,nonatomic) UIBackgroundTaskIdentifier backgroundTaskIdentifier;//后台任务标识

//相机拍摄预览图层
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * captureVideoPreviewLayer;
@property (nonatomic, strong) UIView * contentView;
//拍照按钮
@property (nonatomic, strong) UIButton * takeButton;
//视频录制按钮
@property (nonatomic, strong) UIButton * videoButton;
//自动闪光灯按钮
@property (nonatomic, strong) UIButton * flashAutoButton;
//打开闪光灯按钮
@property (nonatomic, strong) UIButton * flashOnButton;
//关闭闪光灯按钮
@property (nonatomic, strong) UIButton * flashOffButton;
//切换前后摄像头
@property (nonatomic, strong) UIButton * exchangeCamera;
//聚焦光标
@property (nonatomic, strong) UIImageView * focusCursor;

@end

@implementation XRLiveVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活体检测";
    [self setupNav];
    [self setupUI];
    
    [self initCamera];
    
    [self.captureSession startRunning];
    // Do any additional setup after loading the view from its nib.


    [self loadFaceLiveData];
}

- (void)loadFaceLiveData{
    XRFaceLiveFourRequest *clazzReq = [XRFaceLiveFourRequest requestWithSuccessBlock:^(NSInteger errCode, NSDictionary *responseDict, id model) {
        self.strCode = [[responseDict objectForKey:@"obj"] objectAtIndex:0];
        self.codeLabel.text = [NSString stringWithFormat:@"请对着镜头读出验证码:%@",self.strCode];
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error.localizedFailureReason);
    }];
    
    clazzReq.loginModel = self.loginModel;
    [clazzReq startRequest];
}

- (IBAction)submitResultClick:(id)sender
{
//    [self updateVideo];
}

//- (void)updateVideo{
//    uploadVideoRequest *req = [[uploadVideoRequest alloc] init];
//    [req startUploadTaskWithSuccess:^(NSInteger errCode, NSDictionary *responseDict, id model) {
//        DLog(@"errCode:%ld---dict:%@---model:%@", errCode, responseDict, model);
//        _circularPV.hidden = YES;
//        [SVProgressHUD showImage:[UIImage imageNamed:@"112.jpg"] status:@"图片上传成功"];
//    } failure:^(NSError *error) {
//        DLog(@"error:%@", error.localizedFailureReason);
//    } uploadProgress:^(NSProgress *progress) {
//        DLog(@"progress:%lld,%lld,%f", progress.totalUnitCount, progress.completedUnitCount, progress.fractionCompleted);
//          _circularPV.hidden = NO;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [_circularPV setProgress:progress.fractionCompleted];
//        });
//    }];
//    req.showHUD = YES;
//    req.loginModel = self.loginModel;
//    [req startRequest];
//}
- (void)setupNav{
    // 设置导航栏颜色
    [self wr_setNavBarBarTintColor:[UIColor blackColor]];
    //[self wr_setNavBarBarTintColor:ssRGBHex(0x495987)];
    // 设置导航栏按钮和标题颜色
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    // 设置导航栏标题默认颜色
    [self wr_setNavBarTitleColor:[UIColor whiteColor]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //设置图片
    UIImage *imageForButton = [UIImage imageNamed:@"icon_arrow_left"];
    [button setImage:imageForButton forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0 , 30, 30);
    [button addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftNavItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftNavItem;
}

-(IBAction)leftBtnClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.captureSession stopRunning];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 摄像头初始化
- (void)initCamera{
    //初始化会话
    _captureSession = [[AVCaptureSession alloc] init];
    //设置分辨率
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset640x480]) {
        _captureSession.sessionPreset=AVCaptureSessionPreset640x480;
    }
    //获得输入设备
    AVCaptureDevice * captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
    if (!captureDevice) {
        NSLog(@"取得前置摄像头时出现问题。");
        return;
    }
    
    NSError * error = nil;
    
    //添加一个音频输入设备
    AVCaptureDevice * audioCaptureDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    AVCaptureDeviceInput * audioCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCaptureDevice error:&error];
    if (error) {
        NSLog(@"获得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    
    _captureMovieFileOutPut = [[AVCaptureMovieFileOutput alloc] init];
    
    //根据输入设备初始化设备输入对象，用于获得输入数据
    _captureDeviceInput = [[AVCaptureDeviceInput alloc]initWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    //初始化设备输出对象，用于获得输出数据
    _captureStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary * outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
    //输出设置
    [_captureStillImageOutput setOutputSettings:outputSettings];
    
    //将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
        [_captureSession addInput:audioCaptureDeviceInput];
        AVCaptureConnection * captureConnection = [_captureMovieFileOutPut connectionWithMediaType:AVMediaTypeVideo];
        ;
        if ([captureConnection isVideoStabilizationSupported]) {
            captureConnection.preferredVideoStabilizationMode= AVCaptureVideoStabilizationModeAuto;
        }
    }
    
    //将设输出添加到会话中
    if ([_captureSession canAddOutput:_captureStillImageOutput]) {
        [_captureSession addOutput:_captureStillImageOutput];
    }
    
    if ([_captureSession canAddOutput:_captureMovieFileOutPut]) {
        [_captureSession addOutput:_captureMovieFileOutPut];
    }
    
    //创建视频预览层，用于实时展示摄像头状态
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
    
    CALayer * layer = self.contentView.layer;
    layer.masksToBounds = YES;
    
    _captureVideoPreviewLayer.frame = layer.bounds;
    //填充模式
    _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    //将视频预览层添加到界面中
    [layer insertSublayer:_captureVideoPreviewLayer below:self.focusCursor.layer];
    
    [self addNotificationToCaptureDevice:captureDevice];
    [self addGenstureRecognizer];
    [self setFlashModeButtonStatus];
}

#pragma mark - 视频输出代理
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
    NSLog(@"开始录制...");
}
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    NSLog(@"视频录制完成.");
    //视频录入完成之后在后台将视频存储到相簿
    //  self.enableRotation=YES;
    UIBackgroundTaskIdentifier lastBackgroundTaskIdentifier=self.backgroundTaskIdentifier;
    self.backgroundTaskIdentifier=UIBackgroundTaskInvalid;
//    ALAssetsLibrary *assetsLibrary=[[ALAssetsLibrary alloc]init];
//    [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error) {
//        if (error) {
//            NSLog(@"保存视频到相簿过程中发生错误，错误信息：%@",error.localizedDescription);
//        }
//        if (lastBackgroundTaskIdentifier!=UIBackgroundTaskInvalid) {
//            [[UIApplication sharedApplication] endBackgroundTask:lastBackgroundTaskIdentifier];
//        }
//        NSLog(@"成功保存视频到相簿.");
//    }];
    
}

#pragma mark - 摄像头相关
//  给输入设备添加通知
-(void)addNotificationToCaptureDevice:(AVCaptureDevice *)captureDevice{
    //注意添加区域改变捕获通知必须首先设置设备允许捕获
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled=YES;
    }];
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //捕获区域发生改变
    [notificationCenter addObserver:self selector:@selector(areaChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}

-(void)removeNotificationFromCaptureDevice:(AVCaptureDevice *)captureDevice{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}

-(void)removeNotification{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

-(void)addNotificationToCaptureSession:(AVCaptureSession *)captureSession{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //会话出错
    [notificationCenter addObserver:self selector:@selector(sessionRuntimeError:) name:AVCaptureSessionRuntimeErrorNotification object:captureSession];
}

//屏幕旋转时调整视频预览图层的方向
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    AVCaptureConnection *captureConnection=[self.captureVideoPreviewLayer connection];
    captureConnection.videoOrientation=(AVCaptureVideoOrientation)toInterfaceOrientation;
}
//旋转后重新设置大小
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    _captureVideoPreviewLayer.frame=self.contentView.bounds;
}

//获取指定位置的摄像头
- (AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition) positon{
    
    NSArray * cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice * camera in cameras) {
        if ([camera position] == positon) {
            return camera;
        }
    }
    return nil;
}

//属性改变操作
- (void)changeDeviceProperty:(PropertyChangeBlock ) propertyChange{
    
    AVCaptureDevice * captureDevice = [self.captureDeviceInput device];
    NSError * error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
        
    } else {
        
        NSLog(@"设置设备属性过程发生错误，错误信息：%@", error.localizedDescription);
    }
}

//设置闪光灯模式
- (void)setFlashMode:(AVCaptureFlashMode ) flashMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFlashModeSupported:flashMode]) {
            [captureDevice setFlashMode:flashMode];
        }
    }];
}

//聚焦模式
- (void)setFocusMode:(AVCaptureFocusMode) focusMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
    }];
}

//设置曝光模式
- (void)setExposureMode:(AVCaptureExposureMode) exposureMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
    }];
}

//设置聚焦点
- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:point];
        }
        
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:point];
        }
        
    }];
}

//添加点击手势，点按时聚焦
- (void)addGenstureRecognizer{
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen:)];
    [self.contentView addGestureRecognizer:tapGesture];
}

//设置闪关灯按钮状态
- (void)setFlashModeButtonStatus{
    
    AVCaptureDevice * captureDevice = [self.captureDeviceInput device];
    AVCaptureFlashMode flashMode = captureDevice.flashMode;
    if ([captureDevice isFlashAvailable]) {
        self.flashAutoButton.hidden = NO;
        self.flashOnButton.hidden  = NO;
        self.flashOffButton.hidden = NO;
        self.flashAutoButton.enabled = YES;
        self.flashOnButton.enabled = YES;
        self.flashOffButton.enabled = YES;
        
        switch (flashMode) {
            case AVCaptureFlashModeAuto:
                self.flashAutoButton.enabled = NO;
                break;
            case AVCaptureFlashModeOn:
                self.flashOnButton.enabled = NO;
                break;
            case AVCaptureFlashModeOff:
                self.flashOffButton.enabled = NO;
                break;
            default:
                break;
        }
    } else {
        self.flashAutoButton.hidden = YES;
        self.flashOnButton.hidden   = YES;
        self.flashOffButton.hidden  = YES;
    }
    
}

//设置聚焦光标位置
- (void)setFocusCursorWithPoint:(CGPoint)point{
    
    self.focusCursor.center = point;
    self.focusCursor.transform = CGAffineTransformMakeScale(1.5, 1.5);
    self.focusCursor.alpha = 1.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.focusCursor.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusCursor.alpha=0;
    }];
}

/**
 *  设备连接成功
 *
 *  @param notification 通知对象
 */
-(void)deviceConnected:(NSNotification *)notification{
    NSLog(@"设备已连接...");
}
/**
 *  设备连接断开
 *
 *  @param notification 通知对象
 */
-(void)deviceDisconnected:(NSNotification *)notification{
    NSLog(@"设备已断开.");
}
/**
 *  捕获区域改变
 *
 *  @param notification 通知对象
 */
-(void)areaChange:(NSNotification *)notification{
    NSLog(@"捕获区域改变...");
}

/**
 *  会话出错
 *
 *  @param notification 通知对象
 */
-(void)sessionRuntimeError:(NSNotification *)notification{
    NSLog(@"会话发生错误.");
}

#pragma mark - 点击方法
- (void)tapScreen:(UITapGestureRecognizer *) tapGesture{
    
    CGPoint point = [tapGesture locationInView:self.contentView];
    //将UI坐标转化为摄像头坐标
    CGPoint cameraPoint = [self.captureVideoPreviewLayer captureDevicePointOfInterestForPoint:point];
    point.y +=124;
    [self setFocusCursorWithPoint:point];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
}

- (void)clickTakeButton:(UIButton *)sender{
    
    //根据设备输出获得连接
    AVCaptureConnection *captureConnection=[self.captureStillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    //根据连接取得设备输出的数据
    [self.captureStillImageOutput captureStillImageAsynchronouslyFromConnection:captureConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer) {
            NSData *imageData=[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image=[UIImage imageWithData:imageData];
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            
        }
        
    }];
}

// 打开闪关灯
- (void)clickFlashOnButton:(UIButton *)sender{
    [self setFlashMode:AVCaptureFlashModeOn];
    [self setFlashModeButtonStatus];
    
}

//关闭闪光灯
- (void)clickFlashOffButton:(UIButton *)sender{
    [self setFlashMode:AVCaptureFlashModeOff];
    [self setFlashModeButtonStatus];
    
}

//自动闪关灯开起
- (void)clickFlashAutoButton:(UIButton *)sender{
    [self setFlashMode:AVCaptureFlashModeAuto];
    [self setFlashModeButtonStatus];
}

//切换摄像头
- (void)clikcExchangeCamera:(UIButton *)sender{
    AVCaptureDevice * currentDevice = [self.captureDeviceInput device];
    AVCaptureDevicePosition currentPosition = [currentDevice position];
    [self removeNotificationFromCaptureDevice:currentDevice];
    AVCaptureDevice * toChangeDevice;
    AVCaptureDevicePosition  toChangePosition = AVCaptureDevicePositionFront;
    if (currentPosition==AVCaptureDevicePositionUnspecified||currentPosition==AVCaptureDevicePositionFront) {
        toChangePosition = AVCaptureDevicePositionBack;
    }
    toChangeDevice = [self getCameraDeviceWithPosition:toChangePosition];
    [self addNotificationToCaptureDevice:toChangeDevice];
    
    //获得要调整到设备输入对象
    AVCaptureDeviceInput * toChangeDeviceInput = [[AVCaptureDeviceInput alloc]initWithDevice:toChangeDevice error:nil];
    
    //改变会话到配置前一定要先开启配置，配置完成后提交配置改变
    [self.captureSession beginConfiguration];
    //移除原有输入对象
    [self.captureSession removeInput:self.captureDeviceInput];
    //添加新的输入对象
    if ([self.captureSession canAddInput:toChangeDeviceInput]) {
        [self.captureSession addInput:toChangeDeviceInput];
        self.captureDeviceInput=toChangeDeviceInput;
    }
    
    //提交新的输入对象
    [self.captureSession commitConfiguration];
    [self setFlashModeButtonStatus];
}

- (void)clickVideoButton:(UIButton *)sender{
    [self.videoButton setTitle:@"结束" forState:UIControlStateNormal];
    //根据设备输出获得连接
    AVCaptureConnection *captureConnection=[self.captureMovieFileOutPut connectionWithMediaType:AVMediaTypeVideo];
    //根据连接取得设备输出的数据
    if (![self.captureMovieFileOutPut isRecording]) {
        //      self.enableRotation=NO;
        //如果支持多任务则则开始多任务
        if ([[UIDevice currentDevice] isMultitaskingSupported]) {
            self.backgroundTaskIdentifier=[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
        }
        //预览图层和视频方向保持一致
        captureConnection.videoOrientation=[self.captureVideoPreviewLayer connection].videoOrientation;
        NSString *outputFielPath=[NSTemporaryDirectory() stringByAppendingString:@"myMovie.mp4"];
        NSLog(@"save path is :%@",outputFielPath);
        NSURL *fileUrl=[NSURL fileURLWithPath:outputFielPath];
        [self.captureMovieFileOutPut startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
    }
    else{
        [self.captureMovieFileOutPut stopRecording];//停止录制
        NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:@"SendCheckVideoNofication" object:@{@"code":self.strCode}];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

#pragma mark - UI相关和布局
- (void)setupUI{
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:self.contentView];
    self.contentView.frame = CGRectMake(0, 124, ScreenWith, ScreenHeight-100-124);
    
    //文字
    self.codeLabel = [[UILabel alloc] init];
    self.codeLabel.frame = CGRectMake(30, 70, ScreenWith, 40);
    self.codeLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.codeLabel];
    
    self.videoButton = [self createCustomButtonWithName:@"开始"];
    [self.videoButton addTarget:self action:@selector(clickVideoButton:) forControlEvents:UIControlEventTouchUpInside];
    self.videoButton.frame = CGRectMake(ScreenWith/2-30, ScreenHeight-80, 60, 60);
    [self.view addSubview:self.videoButton];
    
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (UIButton *)createCustomButtonWithName:(NSString *)name{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:name forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    button.layer.cornerRadius = 30;
    button.layer.masksToBounds = YES;
    return button;
}
@end
