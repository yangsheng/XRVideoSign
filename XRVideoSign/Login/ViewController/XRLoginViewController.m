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
    self.groupList = @[@"国金资本",@"旭冉科技",@"奇牛软件",@"还没想好"];
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
}

- (IBAction)loginBtnClicked:(id)sender {
    ///< 类方法
    XRLoginRequest *clazzReq = [XRLoginRequest requestWithSuccessBlock:^(NSInteger errCode, NSDictionary *responseDict, id model) {
        DLog(@"errCode:%ld---dict:%@---model:%@", errCode, responseDict, model);
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error.localizedFailureReason);
    }];
    [clazzReq startRequest];
    XRHomeViewController *homeVC = [[XRHomeViewController alloc] initWithNibName:@"XRHomeViewController" bundle:nil];
    homeVC.vc = self;
    [self.navigationController pushViewController:homeVC animated:YES];
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
