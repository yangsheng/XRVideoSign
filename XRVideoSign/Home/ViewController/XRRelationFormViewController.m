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
#import "XRRecordVideoViewController.h"
#import "uploadLiveFaceRequest.h"
#import "uploadVideoRequest.h"
#import "XRObjectSaveRequest.h"
#import "FFCircularProgressView.h"
#import "NBInfoView.h"

#define ScreenWith     [UIScreen mainScreen].bounds.size.width
#define ScreenHeight   [UIScreen mainScreen].bounds.size.height

@interface XRRelationFormViewController ()
@property (nonatomic, strong) IBOutlet UIButton *signBtn;
@property (nonatomic, strong) IBOutlet UITextField *nameField;
@property (nonatomic, strong) IBOutlet UITextField *idField;
@property (nonatomic, strong) IBOutlet UILabel *noLabel;
@property (nonatomic,strong) FFCircularProgressView *circularPV;

@property (nonatomic,strong) NSMutableDictionary *dataPushData;
@property (nonatomic,strong) NSMutableDictionary *objectData;
@property (nonatomic,strong) NSMutableDictionary *adjunctData;
@property (nonatomic,strong) NSMutableDictionary *utilObj;

@end

@implementation XRRelationFormViewController

- (void)insertValueToObjectData{
    NSMutableArray *ar = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in [self.objectData objectForKey:@"datas"]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:dic];
        [dict setObject:@"1" forKey:@"operid"];
        [ar addObject:dict];
    }
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] initWithDictionary:self.objectData];
    [mutableDic setObject:ar forKey:@"datas"];
    //child datas
    NSMutableArray *newChildAr = [[NSMutableArray alloc] init];
    NSArray *oldChildAr = [[[self.objectData objectForKey:@"childDatas"] objectAtIndex:0] objectForKey:@"datas"];
    for (NSDictionary *dic in oldChildAr) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:dic];
        [dict setObject:@"1" forKey:@"operid"];
        [newChildAr addObject:dict];
    }
    NSMutableDictionary *childMutDic = [[NSMutableDictionary alloc] initWithDictionary:[[self.objectData objectForKey:@"childDatas"] objectAtIndex:0]];
    
    NSMutableArray *ar1 = [[NSMutableArray alloc] init];
    [ar1 addObject:childMutDic];
    [mutableDic setObject:ar1 forKey:@"childDatas"];
    self.objectData = mutableDic;
    NSLog(@"sd");
}

- (void)insertValueToAdjunct:(NSDictionary*)dic{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:dic];
   
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"EEE MMM ddHH:mm:ss 'CST' yyyy"];
    NSDate *date=[dateFormatter dateFromString:[dic objectForKey:@"createdate"]];
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    
    NSString *strTime = [NSString stringWithFormat:@"%ld",timeSp];
    [dict setObject:strTime forKey:@"createdate"];
    [dict setObject:@"1" forKey:@"operID"];
    self.adjunctData = dict;
    NSLog(@"sd");
}
- (void)loadRelationData{
    XRRelationRequest *clazzReq = [XRRelationRequest requestWithSuccessBlock:^(NSInteger errCode, NSDictionary *responseDict, id model) {
        /*
         "objectid":dataObject.getInt("objectid"),
         "dataid":mainData.get("fID"),// 主表数据中的fID
         "adjunctclassid":Math.abs(adjunctClasss.get(0).get("id"))// 取第一个附件分类的绝对值
         */
        self.objectData = [[[responseDict objectForKey:@"obj"] objectAtIndex:4] objectForKey:@"objectData"];
        self.dataPushData = [[[responseDict objectForKey:@"obj"] objectAtIndex:4] objectForKey:@"dataPushData"];
        self.adjunctData = [[[responseDict objectForKey:@"obj"] objectAtIndex:4] objectForKey:@"adjunctData"];
        [self insertValueToObjectData];
        
        self.utilObj = [[[responseDict objectForKey:@"obj"] objectAtIndex:4] objectForKey:@"utilObj"];
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
    clazzReq.selectList = self.selectList;
    [clazzReq startRequest];
}

- (void)saveFormData{
    XRObjectSaveRequest *clazzReq = [XRObjectSaveRequest requestWithSuccessBlock:^(NSInteger errCode, NSDictionary *responseDict, id model) {

        NSLog(@"");
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error.localizedFailureReason);
    }];
    /*
     @property (nonatomic,strong) NSMutableDictionary *dataPushData;
     @property (nonatomic,strong) NSMutableDictionary *objectData;
     @property (nonatomic,strong) NSMutableDictionary *adjunctData;
     @property (nonatomic,strong) NSMutableDictionary *utilObj;
     */
    clazzReq.loginModel = self.loginModel;
    clazzReq.dataPushData = self.dataPushData;
    clazzReq.objectData = self.objectData;
    clazzReq.adjunctData = self.adjunctData;
    clazzReq.utilObj = self.utilObj;
    
 //   clazzReq.selectList = self.selectList;
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
    
    self.circularPV = [[FFCircularProgressView alloc] initWithFrame:CGRectMake(ScreenWith/2-50, ScreenHeight/2-50, 100, 100)];
    //_circularPV.center = self.view.center;
    
    [self.view addSubview:_circularPV];
    _circularPV.hidden = YES;
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //注册活体验证的消息
    [center addObserver:self selector:@selector(SendLiveVideoCheck:) name:@"SendCheckVideoNofication" object:nil];
    //注册视频附件的消息
    [center addObserver:self selector:@selector(SendSaveVideo:) name:@"SendSaveVideoNofication" object:nil];
    
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
- (void)SendSaveVideo:(NSNotification *)notification {
    self.signBtn.enabled = NO;
    [self updateVideo];
}
- (void)updateVideo{
    uploadVideoRequest *req = [[uploadVideoRequest alloc] init];
    [req startUploadTaskWithSuccess:^(NSInteger errCode, NSDictionary *responseDict, id model) {
        DLog(@"errCode:%ld---dict:%@---model:%@", errCode, responseDict, model);
        _circularPV.hidden = YES;
        self.adjunctData = [[responseDict objectForKey:@"obj"] objectAtIndex:0];
        [self insertValueToAdjunct:self.adjunctData];
        [self saveFormData];
    } failure:^(NSError *error) {
        DLog(@"error:%@", error.localizedFailureReason);
    } uploadProgress:^(NSProgress *progress) {
        DLog(@"progress:%lld,%lld,%f", progress.totalUnitCount, progress.completedUnitCount, progress.fractionCompleted);
        _circularPV.hidden = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_circularPV setProgress:progress.fractionCompleted];
        });
    }];
    req.showHUD = YES;
    req.loginModel = self.loginModel;
    [req startRequest];
}
- (void)SendLiveVideoCheck:(NSNotification *)notification {
    self.signBtn.enabled = NO;
    NSString *strCode =[notification.object objectForKey:@"code"];
    [self sendVideoToCheck:strCode];
}
- (void)sendVideoToCheck:(NSString*)strCode{
    @weakify(self);
    uploadLiveFaceRequest *req = [[uploadLiveFaceRequest alloc] init];
    [req startUploadTaskWithSuccess:^(NSInteger errCode, NSDictionary *responseDict, id model) {
        DLog(@"errCode:%ld---dict:%@---model:%@", errCode, responseDict, model);
        self.circularPV.hidden = YES;
        self.signBtn.enabled = YES;
        NSDictionary *dic = [[responseDict objectForKey:@"obj"] objectAtIndex:0];
        NSString *strResult = [NSString stringWithFormat:@"活体检测结果:%@\r\n\r\n人脸核身比对结果:%@\r\n\r\n相似度:%ld",[dic objectForKey:@"live_msg"],[dic objectForKey:@"compare_msg"],[[dic objectForKey:@"sim"] integerValue]];
        if ([[dic objectForKey:@"live_status"] integerValue] == 0 &&
            [[dic objectForKey:@"compare_status"] integerValue] == 0
            ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *dic = @{@"title":@"温馨提示",@"content":strResult,@"confirmName":@"进入视频面签"};
                [[NBInfoView sharedNBInfoView] alertViewShowOnView:self.view ContentDic:dic ButtonAciton:^(NSInteger nIndex) {
                        XRRecordVideoViewController *VC = [[XRRecordVideoViewController alloc] initWithNibName:@"XRRecordVideoViewController" bundle:nil];
                    VC.loginModel = self.loginModel;
                        [self.navigationController pushViewController:VC animated:YES];
                }];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *dic = @{@"title":@"温馨提示",@"content":strResult,@"confirmName":@"重新进行活体检测"};
                [[NBInfoView sharedNBInfoView] alertViewShowOnView:self.view ContentDic:dic ButtonAciton:^(NSInteger nIndex) {
                    
                }];
            });
        }

    } failure:^(NSError *error) {
        self.signBtn.enabled = YES;
        DLog(@"error:%@", error.localizedFailureReason);
        
    } uploadProgress:^(NSProgress *progress) {
        DLog(@"progress:%lld,%lld,%f", progress.totalUnitCount, progress.completedUnitCount, progress.fractionCompleted);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            self.circularPV.hidden = NO;
            [self.circularPV setProgress:progress.fractionCompleted];
        });
    }];
    req.showHUD = YES;
    req.loginModel = self.loginModel;
    req.dataDict = [self.selectList objectAtIndex:0];
    req.strCode = strCode;
    [req startRequest];
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
