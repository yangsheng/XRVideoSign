//
//  XRSlideViewController.m
//  XRVideoSign
//
//  Created by zhu yangsheng on 1/20/19.
//  Copyright © 2019 xrinfo. All rights reserved.
//

#import "XRSlideViewController.h"

@interface XRSlideViewController ()

@end

@implementation XRSlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)exitBtnClicked:(id)sender {
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:@"ExitNofication" object:nil userInfo:nil];
    //发送消息
    [[NSNotificationCenter defaultCenter] postNotification:notice];

    
    [self dismissViewControllerAnimated:YES completion:nil];
}
//
- (IBAction)aboutBtnClicked:(id)sender {

}
//
- (IBAction)feedBackBtnClicked:(id)sender {
    
}
@end
