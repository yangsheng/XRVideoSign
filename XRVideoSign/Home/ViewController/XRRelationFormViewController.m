//
//  XRRelationFormViewController.m
//  XRVideoSign
//
//  Created by zhu yangsheng on 1/24/19.
//  Copyright © 2019 xrinfo. All rights reserved.
//

#import "XRRelationFormViewController.h"
#import "XRRelationRequest.h"
#import "WRNavigationBar.h"
#import "XRLiveVideoViewController.h"

@interface XRRelationFormViewController ()
@property (nonatomic, strong) IBOutlet UIButton *signBtn;
@property (nonatomic, strong) IBOutlet UITextField *nameField;
@property (nonatomic, strong) IBOutlet UITextField *idField;
@property (nonatomic, strong) IBOutlet UILabel *noLabel;

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
    clazzReq.dataDict = [self.selectList objectAtIndex:0];
    [clazzReq startRequest];
}

- (void)initUI{
    NSDictionary *dic = [self.selectList objectAtIndex:0];
    self.nameField.text = [dic objectForKey:@"fName"];
    self.idField.text = [dic objectForKey:@"fCardID"];
    NSString *strNO;
    for (int i=0; i< [self.selectList count]; ++i) {
        if (i == 0) {
            strNO = [[self.selectList objectAtIndex:i] objectForKey:@"合同号"];
        }else{
            strNO = [NSString stringWithFormat:@"%@\r\n%@",strNO,[[self.selectList objectAtIndex:i] objectForKey:@"合同号"]];
        }
    }
    self.noLabel.text = strNO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"合同信息确认";
    self.signBtn.layer.cornerRadius = 8;
    
    [self setupNav];
    [self initUI];
    [self loadRelationData];

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
    UIImage *imageForButton = [UIImage imageNamed:@"icon_arrow_left"];
    [button setImage:imageForButton forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0 , 30, 30);
    [button addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftNavItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftNavItem;
    
    //    UIBarButtonItem *rightNavItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_search"]
    //                                                                     style:UIBarButtonItemStylePlain
    //                                                                    target:self
    //                                                                    action:@selector(searchBtnclicked:)];
    //
    //  //  rightNavItem.imageInsets = UIEdgeInsetsMake(0, -12, 0, 0);
    //    self.navigationItem.rightBarButtonItem = rightNavItem;
}

-(IBAction)leftClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
