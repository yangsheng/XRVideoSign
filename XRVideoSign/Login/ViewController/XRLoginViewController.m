//
//  XRLoginViewController.m
//  XRVideoSign
//
//  Created by zhu yangsheng on 1/18/19.
//  Copyright © 2019 xrinfo. All rights reserved.
//

#import "XRLoginViewController.h"
#import "XRHomeViewController.h"
#import "CDZPicker.h"
#import "XRLoginRequest.h"

@interface XRLoginViewController ()
@property (nonatomic,strong) IBOutlet UIButton *loginBtn;
@property (nonatomic,strong) IBOutlet UITextField *groupText;
@property (nonatomic,strong) IBOutlet UITextField *userText;
@property (nonatomic,strong) IBOutlet UITextField *pwdText;

@property (nonatomic,strong) NSArray *groupList;
@end

@implementation XRLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
   // self.groupList = @[@"国金资本",@"旭冉科技",@"奇牛软件",@"还没想好"];
    //这个项目目前只有一个账套，不需要请求初始化接口
    self.groupList = @[@"国金资本"];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillDisappear:animated];
}

-(void)initUI{
    self.loginBtn.layer.cornerRadius = 15;
    self.groupText.text = @"国金资本";
    self.userText.text = @"administrator";
    self.pwdText.text = @"sun";
}

- (IBAction)loginBtnClicked:(id)sender {
    ///< 类方法
    XRLoginRequest *clazzReq = [XRLoginRequest requestWithSuccessBlock:^(NSInteger errCode, NSDictionary *responseDict, id model) {
        BOOL bRet = [[responseDict objectForKey:@"success"] boolValue];
        if (bRet) {
            XRHomeViewController *homeVC = [[XRHomeViewController alloc] initWithNibName:@"XRHomeViewController" bundle:nil];
            homeVC.vc = self;
            homeVC.loginModel = model;
            [self.navigationController pushViewController:homeVC animated:YES];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:[responseDict objectForKey:@"msg"]];
            });

        }

    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error.localizedFailureReason);
    }];
    clazzReq.user = self.userText.text;
    clazzReq.password = self.pwdText.text;
    [clazzReq startRequest];

}

- (IBAction)selectGroupBtnClicked:(id)sender {
    CDZPickerBuilder *builder = [CDZPickerBuilder new];
    builder.showMask = YES;
    builder.cancelTextColor = UIColor.redColor;
    [CDZPicker showSinglePickerInView:self.view withBuilder:builder strings:self.groupList confirm:^(NSArray<NSString *> * _Nonnull strings, NSArray<NSNumber *> * _Nonnull indexs) {
        self.groupText.text = strings.firstObject;
        //          NSLog(@"strings:%@ indexs:%@",strings,indexs);
    }cancel:^{
        
    }delete:^(NSInteger nIndex){

        
    }];
}

@end
