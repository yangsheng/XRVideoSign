//
//  XRLoginRequest.m
//  XRVideoSign
//
//  Created by zhu yangsheng on 1/22/19.
//  Copyright © 2019 xrinfo. All rights reserved.
//

#import "XRLoginRequest.h"
#import "LoginModel.h"
#import "MJExtension.h"

@implementation XRLoginRequest
- (HQMRequestMethod)requestMethod {
    return HQMRequestMethodPOST;
}

- (NSString *)requestURLPath {
    return @"/xrspip/api/login";
}




- (NSDictionary *)requestArguments {
    NSDictionary *dic = @{
                          @"userno": @"administrator",
                          @"userpwd": @"sun"
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
        NSMutableArray *friendLists = [NSMutableArray arrayWithCapacity:0];
//        NSArray *arr = [dict objectForKey:@"friend_list"];
//        for (NSDictionary *temp in arr) {
//            HQMContact *contact = [MTLJSONAdapter modelOfClass:[HQMContact class] fromJSONDictionary:temp error:&error];
//            [friendLists addObject:contact];
//        }
        LoginModel *model = [LoginModel mj_objectWithKeyValues:[[dict objectForKey:@"obj"] objectAtIndex:1]];
        if (self.successBlock) {
            self.successBlock(errCode, dict, model);
        }

    }
    else {
        if (self.successBlock) {
            self.successBlock(errCode, dict, nil);
        }
    }
}
@end
