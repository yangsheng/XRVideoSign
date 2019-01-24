//
//  XRFaceLiveFourRequest.m
//  XRVideoSign
//
//  Created by zhu yangsheng on 1/24/19.
//  Copyright © 2019 xrinfo. All rights reserved.
//

#import "XRFaceLiveFourRequest.h"

@implementation XRFaceLiveFourRequest

- (HQMRequestMethod)requestMethod {
    return HQMRequestMethodPOST;
}

- (NSString *)requestURLPath {
    return @"/xrspip/api/getFaceLivefour";
}




- (NSDictionary *)requestArguments {
  return nil;
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
