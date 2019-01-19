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

@interface XRLoginViewController ()
@property (nonatomic,strong) IBOutlet UIButton *loginBtn;
@property (nonatomic,strong) NSArray *groupList;
@end

@implementation XRLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.hidden = YES;
    [self initUI];
    self.groupList = @[@"国金资本",@"旭冉科技",@"奇牛软件",@"还没想好"];
}

-(void)initUI{
    self.loginBtn.layer.cornerRadius = 15;
}

- (IBAction)loginBtnClicked:(id)sender {
    XRHomeViewController *homeVC = [[XRHomeViewController alloc] initWithNibName:@"XRHomeViewController" bundle:nil];
    [self.navigationController pushViewController:homeVC animated:YES];
}

- (IBAction)selectGroupBtnClicked:(id)sender {
    CDZPickerBuilder *builder = [CDZPickerBuilder new];
    builder.showMask = YES;
    builder.cancelTextColor = UIColor.redColor;
    [CDZPicker showSinglePickerInView:self.view withBuilder:builder strings:self.groupList confirm:^(NSArray<NSString *> * _Nonnull strings, NSArray<NSNumber *> * _Nonnull indexs) {
      //  self.usernameTextField.text = strings.firstObject;
        //          NSLog(@"strings:%@ indexs:%@",strings,indexs);
    }cancel:^{
        
    }delete:^(NSInteger nIndex){

        
    }];
}

@end
