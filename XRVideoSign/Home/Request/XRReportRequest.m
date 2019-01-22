//
//  XRReportRequest.m
//  XRVideoSign
//
//  Created by zhu yangsheng on 1/23/19.
//  Copyright © 2019 xrinfo. All rights reserved.
//

#import "XRReportRequest.h"
#import "LoginModel.h"
#import "MJExtension.h"

@implementation XRReportRequest
- (HQMRequestMethod)requestMethod {
    return HQMRequestMethodPOST;
}

- (NSString *)requestURLPath {
    return @"/xrspip/api/reportdata";
}




- (NSDictionary *)requestArguments {
    NSDictionary *utilObj = @{
                              @"sysmoduleid": @"mui_REP_ASD_spVideoGetContract",
                              @"objectclassid": @"1",
                              @"objectid":@"4580",
                              @"dataid":@"0",
                              @"operid":@"0",
                              @"relationid":@"0"
                              };
    
    NSDictionary *filter = @{
                                 @"@ShowC@": @"0",
                                 @"@sNO@": @"",
                                 @"@sName@":@"",
                                 @"@ASD_MachineCompany@":@"",
                                 @"@ShowD@":@"",
                                 @"@MachineDeptID@":@"",
                                 @"@RZ_DealerName@":@""
                                 };
    
    NSDictionary *utilPage = @{
                             @"currentPage": @"1",
                             @"pageSize": @"20"
                             };
    
    NSDictionary *dataFilter = @{
                              @"utilPage": utilPage,
                              @"filter": filter
                              };
    
    NSDictionary *dic = @{
                                 @"utilObj": utilObj,
                                 @"dataFilter": dataFilter
                                 };
    
    NSString *jsonString = [XRTools convertToJsonData:dic];
    NSString *encString = [DES3Util AES128Encrypt:jsonString];
    return @{
             @"data": encString
             };
    
    //return nil;如果接口不需传参，返回 nil 即可
}

///< 配置请求头，根据需求决定是否重写
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{
             @"XR-ID": @"0",
             @"XR-TOKEN": @"",
             @"XR-SYSTEMKEY": @"APP_NATIVE_V1",
             @"XR-USERCLASS": @"NEIBU",
             @"XR-ACCOUNTID": @"0"
             };
    
    //    return nil;
}

- (void)handleData:(id)data errCode:(NSInteger)errCode {
    NSDictionary *dict = (NSDictionary *)data;
    NSError *error = nil;
    
    if (errCode == 0) {

       
        if (self.successBlock) {
  //          self.successBlock(errCode, dict, model);
        }
        
    }
    else {
        if (self.successBlock) {
            self.successBlock(errCode, dict, nil);
        }
    }
}
@end
