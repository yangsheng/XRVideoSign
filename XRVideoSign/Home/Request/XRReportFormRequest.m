//
//  XRReportFormRequest.m
//  XRVideoSign
//
//  Created by zhu yangsheng on 1/24/19.
//  Copyright © 2019 xrinfo. All rights reserved.
//

#import "XRReportFormRequest.h"

@implementation XRReportFormRequest
- (HQMRequestMethod)requestMethod {
    return HQMRequestMethodPOST;
}

- (NSString *)requestURLPath {
    return @"/xrspip/api/reportform";
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
                             };
    
    NSDictionary *utilPage = @{
                               @"currentPage": @"1",
                               @"pageSize": @"1000"
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
             @"XR-ID": self.loginModel.id,
             @"XR-TOKEN": self.loginModel.token,
             @"XR-SYSTEMKEY": @"APP_NATIVE_V1",
             @"XR-USERCLASS": @"NEIBU",
             @"XR-ACCOUNTID": self.loginModel.accountid
             };
    
    //    return nil;
}

- (void)handleData:(id)data errCode:(NSInteger)errCode {
    NSDictionary *dict = (NSDictionary *)data;
    NSError *error = nil;
    
    if (errCode == 0) {
        
        
        if (self.successBlock) {
            self.successBlock(errCode, dict, nil);
        }
        
    }
    else {
        if (self.successBlock) {
            self.successBlock(errCode, dict, nil);
        }
    }
}
@end
