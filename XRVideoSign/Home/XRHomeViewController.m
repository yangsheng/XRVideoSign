//
//  XRHomeViewController.m
//  XRVideoSign
//
//  Created by zhu yangsheng on 1/19/19.
//  Copyright © 2019 xrinfo. All rights reserved.
//

#import "XRHomeViewController.h"
#import "WRNavigationBar.h"

@interface XRHomeViewController ()

@end

@implementation XRHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"待面签报表";
    self.navigationController.navigationBar.hidden = NO;
    [self setupNav];
}

- (void)setupNav{
    // 设置导航栏颜色
    [self wr_setNavBarBarTintColor:ssRGBHex(0x495987)];
    // 设置导航栏按钮和标题颜色
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    // 设置导航栏标题默认颜色
    [self wr_setNavBarTitleColor:[UIColor whiteColor]];
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
