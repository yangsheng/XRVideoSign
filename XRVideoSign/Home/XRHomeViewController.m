//
//  XRHomeViewController.m
//  XRVideoSign
//
//  Created by zhu yangsheng on 1/19/19.
//  Copyright © 2019 xrinfo. All rights reserved.
//

#import "XRHomeViewController.h"
#import "WRNavigationBar.h"
#import "XRSlideViewController.h"
#import "UIViewController+CWLateralSlide.h"

@interface XRHomeViewController ()

@end

@implementation XRHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"待面签报表";
    self.navigationController.navigationBar.hidden = NO;
    [self setupNav];
    // 注册手势驱动
    __weak typeof(self)weakSelf = self;
    // 第一个参数为是否开启边缘手势，开启则默认从边缘50距离内有效，第二个block为手势过程中我们希望做的操作
    [self cw_registerShowIntractiveWithEdgeGesture:NO transitionDirectionAutoBlock:^(CWDrawerTransitionDirection direction) {
        //NSLog(@"direction = %ld", direction);
        if (direction == CWDrawerTransitionFromLeft) { // 左侧滑出
            [weakSelf leftClick];
        }
    }];
}

- (void)setupNav{
    // 设置导航栏颜色
    [self wr_setNavBarBarTintColor:ssRGBHex(0x495987)];
    // 设置导航栏按钮和标题颜色
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    // 设置导航栏标题默认颜色
    [self wr_setNavBarTitleColor:[UIColor whiteColor]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //设置图片
    UIImage *imageForButton = [UIImage imageNamed:@"icon_user"];
    [button setImage:imageForButton forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0 , 30, 30);
    [button addTarget:self action:@selector(userBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftNavItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftNavItem;

    UIBarButtonItem *rightNavItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_search"]
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(searchBtnclicked:)];

  //  rightNavItem.imageInsets = UIEdgeInsetsMake(0, -12, 0, 0);
    self.navigationItem.rightBarButtonItem = rightNavItem;
}

- (void)leftClick{
    XRSlideViewController *slideVC = [[XRSlideViewController alloc] initWithNibName:@"XRSlideViewController" bundle:nil];
    CWLateralSlideConfiguration *conf = [CWLateralSlideConfiguration defaultConfiguration];
    conf.direction = CWDrawerTransitionFromLeft;
    conf.distance = kCWSCREENWIDTH * 0.6;
    conf.finishPercent = 0.2f;
    conf.showAnimDuration = 0.2;
    conf.HiddenAnimDuration = 0.2;
    conf.maskAlpha = 0.1;
    
    [self cw_showDrawerViewController:slideVC animationType:CWDrawerAnimationTypeDefault configuration:conf];
}
-(IBAction)userBtnClicked:(id)sender{
    [self leftClick];
}

-(IBAction)searchBtnclicked:(id)sender{
    
}
@end
