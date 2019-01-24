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

@interface XRLiveVideoViewController ()

@end

@implementation XRLiveVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadFaceLiveData];
}

- (void)loadFaceLiveData{
    XRFaceLiveFourRequest *clazzReq = [XRFaceLiveFourRequest requestWithSuccessBlock:^(NSInteger errCode, NSDictionary *responseDict, id model) {
        NSLog(@"");
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error.localizedFailureReason);
    }];
    
    clazzReq.loginModel = self.loginModel;
    [clazzReq startRequest];
}

- (IBAction)submitResultClick:(id)sender
{
    @weakify(self);
    uploadLiveFaceRequest *req = [[uploadLiveFaceRequest alloc] init];
    [req startUploadTaskWithSuccess:^(NSInteger errCode, NSDictionary *responseDict, id model) {
        DLog(@"errCode:%ld---dict:%@---model:%@", errCode, responseDict, model);
        [SVProgressHUD showImage:[UIImage imageNamed:@"112.jpg"] status:@"图片上传成功"];
    } failure:^(NSError *error) {
        DLog(@"error:%@", error.localizedFailureReason);
    } uploadProgress:^(NSProgress *progress) {
        DLog(@"progress:%lld,%lld,%f", progress.totalUnitCount, progress.completedUnitCount, progress.fractionCompleted);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);

        });
    }];
    req.showHUD = YES;
    req.loginModel = self.loginModel;
    [req startRequest];
}

@end
