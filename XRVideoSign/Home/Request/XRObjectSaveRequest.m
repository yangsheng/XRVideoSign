//
//  XRObjectSaveRequest.m
//  XRVideoSign
//
//  Created by zhu yangsheng on 1/26/19.
//  Copyright © 2019 xrinfo. All rights reserved.
//

#import "XRObjectSaveRequest.h"
#import "MJExtension.h"

@implementation XRObjectSaveRequest
- (HQMRequestMethod)requestMethod {
    return HQMRequestMethodPOST;
}

- (NSString *)requestURLPath {
    return @"/xrspip/api/objectsave";
}




- (NSDictionary *)requestArguments {
    NSArray *adjunctArray = @[self.adjunctData];
    
    NSDictionary *dicParam = @{
                           @"utilObj":self.utilObj,
                           @"dataPushData":self.dataPushData,
                           @"objectData":self.objectData,
                           @"adjunctData":@{@"adjuncts":adjunctArray}
                           };
    
    NSDictionary *dic = @{
                          @"dataOper": dicParam
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
