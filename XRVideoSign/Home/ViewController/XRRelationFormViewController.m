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
        /*
         "objectid":dataObject.getInt("objectid"),
         "dataid":mainData.get("fID"),// 主表数据中的fID
         "adjunctclassid":Math.abs(adjunctClasss.get(0).get("id"))// 取第一个附件分类的绝对值
         */
        NSInteger nObjectid = [[[[responseDict objectForKey:@"obj"] objectAtIndex:0] objectForKey:@"objectid"] integerValue];
        NSString *strObjectid = [NSString stringWithFormat:@"%ld",nObjectid];
     
        NSString *strDataid = [[[[[[responseDict objectForKey:@"obj"] objectAtIndex:4] objectForKey:@"objectData"] objectForKey:@"datas"] objectAtIndex:0] objectForKey:@"fID"] ;
        
        NSString *strAdjunctclassid = [[[[responseDict objectForKey:@"obj"] objectAtIndex:1] objectAtIndex:0] objectForKey:@"no"] ;
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:strObjectid forKey:@"Objectid"];
        [userDefault setObject:strDataid forKey:@"Dataid"];
        [userDefault setObject:strAdjunctclassid forKey:@"Adjunctclassid"];
        [userDefault synchronize];
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
