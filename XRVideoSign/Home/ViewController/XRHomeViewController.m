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
#import "XRLoginViewController.h"
#import "ListTableViewCell.h"
#import "XRRecordVideoViewController.h"
#import "XRRelationFormViewController.h"
#import "XRReportRequest.h"
#import "XRReportFormRequest.h"
#import "XRRelationListRequest.h"

#import "MJRefresh.h"

@interface XRHomeViewController ()
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIButton *signBtn;

@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSMutableArray *selectList;
@property (nonatomic, strong) NSMutableDictionary *filters;
@property (nonatomic, assign) int current_index;
@end

@implementation XRHomeViewController

- (void)loadFormData{
    XRReportFormRequest *clazzReq = [XRReportFormRequest requestWithSuccessBlock:^(NSInteger errCode, NSDictionary *responseDict, id model) {
        NSLog(@"");
        
 //       [[NSUserDefaults standardUserDefaults] setObject:@"reportFormObjectid" forKey:@""];
        
        self.filters = [[NSMutableDictionary alloc] init];
        NSArray *ar = [[[responseDict objectForKey:@"obj"] objectAtIndex:0] objectForKey:@"filters"];
        for (NSDictionary *dic in ar) {
            [self.filters setObject:[dic objectForKey:@"defaultvalue"] forKey:[dic objectForKey:@"no"]];
        }
        [self loadData:YES];
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error.localizedFailureReason);
    }];
    
    clazzReq.loginModel = self.loginModel;
    [clazzReq startRequest];
}

- (void)loadData:(BOOL)bFirst{
    XRReportRequest *clazzReq = [XRReportRequest requestWithSuccessBlock:^(NSInteger errCode, NSDictionary *responseDict, id model) {
        if (bFirst) {
           self.signBtn.hidden = NO;
           self.tableView.mj_footer.hidden = NO;
           self.dataList = [[responseDict objectForKey:@"obj"] objectAtIndex:0];
           [self.tableView.mj_header endRefreshing];
        }else{
            NSMutableArray *list = [[NSMutableArray alloc] initWithArray:self.dataList];
            NSArray *ar = [[responseDict objectForKey:@"obj"] objectAtIndex:0];
            [list addObjectsFromArray:ar];
            self.dataList = [list mutableCopy];
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        DLog(@"error:%@", error.localizedFailureReason);
    }];
    if (bFirst) {
       self.current_index = 1;
    }else{
       ++self.current_index;
    }
    
    clazzReq.filters = self.filters;
    clazzReq.loginModel = self.loginModel;
    clazzReq.current_index = self.current_index;
    [clazzReq startRequest];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"待面签报表";
    self.signBtn.layer.cornerRadius = 8;
    self.signBtn.hidden = YES;
    self.selectList = [[NSMutableArray alloc] init];
    [self setupNav];
    [self loadFormData];

    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(doExit:) name:@"ExitNofication" object:nil];
    [self registerSlideGesture];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"ListTableViewCell" bundle:nil] forCellReuseIdentifier:@"ListTableViewCell"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData:YES];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
       [self loadData:NO];
    }];
    self.tableView.mj_footer.hidden = YES;
}

-(void)doExit:(id)sender{
    [self.navigationController popToViewController:self.vc animated:NO];
}

- (void)registerSlideGesture{
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

//    UIBarButtonItem *rightNavItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_search"]
//                                                                     style:UIBarButtonItemStylePlain
//                                                                    target:self
//                                                                    action:@selector(searchBtnclicked:)];
//
//  //  rightNavItem.imageInsets = UIEdgeInsetsMake(0, -12, 0, 0);
//    self.navigationItem.rightBarButtonItem = rightNavItem;
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
- (IBAction)recordBtnClicked:(id)sender {
    if ([self.selectList count] == 0) {
        [SVProgressHUD setBackgroundColor:[UIColor lightGrayColor]];
        [SVProgressHUD showErrorWithStatus:@"请至少选择一个合同进行面签"];
        return;
    }
    XRRelationListRequest *clazzReq = [XRRelationListRequest requestWithSuccessBlock:^(NSInteger errCode, NSDictionary *responseDict, id model) {
        NSLog(@"");
        NSInteger nObjectid = [[[[[responseDict objectForKey:@"obj"] objectAtIndex:0] objectAtIndex:0] objectForKey:@"id"] integerValue];
        NSString *strObjectid = [NSString stringWithFormat:@"%ld",nObjectid];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:strObjectid forKey:@"relationID"];
        [userDefault synchronize];
        XRRelationFormViewController *VC = [[XRRelationFormViewController alloc] initWithNibName:@"XRRelationFormViewController" bundle:nil];
        VC.loginModel = self.loginModel;
        VC.selectList = self.selectList;
        [self.navigationController pushViewController:VC animated:YES];
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error.localizedFailureReason);
    }];
    
    clazzReq.loginModel = self.loginModel;
    clazzReq.dataDict = [self.selectList objectAtIndex:0];
    [clazzReq startRequest];
}


#pragma mark - tableview delegate / dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ListTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;  
    NSDictionary *dic = [self.dataList objectAtIndex:indexPath.row];
    NSString *strNo = [NSString stringWithFormat:@"  合同号:  %@",[dic objectForKey:@"fNO"]];
    [cell.noBtn setTitle:strNo forState:UIControlStateNormal];
    
    cell.mainLabel.text = [dic objectForKey:@"主机厂"];
    cell.dealerLabel.text = [dic objectForKey:@"经销商"];
    cell.CustomerTypeLabel.text = [[dic objectForKey:@"客户类型"] length]>0?[dic objectForKey:@"客户类型"]:@" ";
    cell.methodLabel.text = [[dic objectForKey:@"租赁方式"] length]>0?[dic objectForKey:@"租赁方式"]:@" ";
    cell.nameLabel.text = [dic objectForKey:@"fName"]?[dic objectForKey:@"fName"]:@"";
    cell.moneyLabel.text = [NSString stringWithFormat:@"%ld", [[dic objectForKey:@"融资金额"] integerValue]];
    cell.expiredLabel.text = [NSString stringWithFormat:@"%ld",[[dic objectForKey:@"租赁期限"] integerValue]];
    cell.noBtn.tag = indexPath.row;
    cell.cellItemClick = ^(NSInteger nIndex,BOOL bSelected) {
        //
        if (bSelected) {
            [self.selectList addObject:[self.dataList objectAtIndex:nIndex]];
        }else{
            [self.selectList removeObject:[self.dataList objectAtIndex:nIndex]];
        }
        NSLog(@"");
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}

@end
