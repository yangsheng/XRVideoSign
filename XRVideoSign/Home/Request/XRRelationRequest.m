//
//  XRRelationRequest.m
//  XRVideoSign
//
//  Created by zhu yangsheng on 1/24/19.
//  Copyright © 2019 xrinfo. All rights reserved.
//

#import "XRRelationRequest.h"

@implementation XRRelationRequest
- (HQMRequestMethod)requestMethod {
    return HQMRequestMethodPOST;
}

- (NSString *)requestURLPath {
    return @"/xrspip/api/objectrelation";
}




- (NSDictionary *)requestArguments {
    //
    NSString *strNO;
    for (int i=0; i< [self.selectList count]; ++i) {
        if (i == 0) {
            NSInteger intValue = [[[self.selectList objectAtIndex:i] objectForKey:@"fID"] integerValue];
            strNO = [NSString stringWithFormat:@"%ld,",intValue];
        }else{
            NSInteger intValue = [[[self.selectList objectAtIndex:i] objectForKey:@"fID"] integerValue];
            strNO = [NSString stringWithFormat:@"%@%ld,",strNO,intValue];
        }
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *utilObj = @{
                              @"dataid":[[self.selectList objectAtIndex:0] objectForKey:@"fID"],
                              @"relationid":[userDefault objectForKey:@"relationID"],
                              @"relationoperid":@"11",
                              @"relationdataid":[[self.selectList objectAtIndex:0] objectForKey:@"fID"],
                              @"relationidkeyvalues":strNO
                              };
    NSDictionary *data = @{
                              };
    NSDictionary *keyDatas = @{
                               @"datas": @[]
                           };
    NSDictionary *dic = @{
                          @"utilObj": utilObj,
                          @"data": data,
                          @"keyDatas":keyDatas
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
