//
//  XRLoginRequest.m
//  XRVideoSign
//
//  Created by zhu yangsheng on 1/22/19.
//  Copyright © 2019 xrinfo. All rights reserved.
//

#import "XRLoginRequest.h"
#import "DES3Util.h"

@implementation XRLoginRequest
- (HQMRequestMethod)requestMethod {
    return HQMRequestMethodPOST;
}

- (NSString *)requestURLPath {
    return @"/xrspip/api/login";
}

-(NSString *)convertToJsonData:(NSDictionary *)dict{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}


- (NSDictionary *)requestArguments {
    NSDictionary *dic = @{
                          @"userno": @"administrator",
                          @"userpwd": @"sun"
                          };
    
    NSString *jsonString = [self convertToJsonData:dic];
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
    
//    if (errCode == 0) {
//        NSMutableArray *friendLists = [NSMutableArray arrayWithCapacity:0];
//        NSArray *arr = [dict objectForKey:@"friend_list"];
//        for (NSDictionary *temp in arr) {
//            HQMContact *contact = [MTLJSONAdapter modelOfClass:[HQMContact class] fromJSONDictionary:temp error:&error];
//            [friendLists addObject:contact];
//        }
//
//        ///< 方式1：block 回调
//        if (self.successBlock) {
//            self.successBlock(errCode, dict, friendLists);
//        }
//
//        ///< 方式2：代理回调
//        if (self.delegate && [self.delegate respondsToSelector:@selector(requestDidFinishLoadingWithData:errCode:)]) {
//            [self.delegate requestDidFinishLoadingWithData:friendLists errCode:errCode];
//        }
//    }
//    else {
//        ///< block 回调
//        if (self.successBlock) {
//            self.successBlock(errCode, dict, nil);
//        }
//
//        ///< 代理回调
//        if (self.delegate && [self.delegate respondsToSelector:@selector(requestDidFinishLoadingWithData:errCode:)]) {
//            [self.delegate requestDidFinishLoadingWithData:data errCode:errCode];
//        }
//    }
}
@end
