//
//  XRRelationFormViewController.m
//  XRVideoSign
//
//  Created by zhu yangsheng on 1/24/19.
//  Copyright © 2019 xrinfo. All rights reserved.
//

#import "XRRelationFormViewController.h"
#import "XRRelationRequest.h"

#import "XRLiveVideoViewController.h"

@interface XRRelationFormViewController ()

@end

@implementation XRRelationFormViewController

- (void)loadRelationData{
    XRRelationRequest *clazzReq = [XRRelationRequest requestWithSuccessBlock:^(NSInteger errCode, NSDictionary *responseDict, id model) {
        NSLog(@"");
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error.localizedFailureReason);
    }];
    
    clazzReq.loginModel = self.loginModel;
    clazzReq.dataDict = self.dataDict;
    [clazzReq startRequest];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadRelationData];

}

- (IBAction)startFaceBtnClicked:(id)sender {
    XRLiveVideoViewController *VC = [[XRLiveVideoViewController alloc] initWithNibName:@"XRLiveVideoViewController" bundle:nil];
    VC.loginModel = self.loginModel;
    [self.navigationController pushViewController:VC animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
