//
//  uploadLiveFaceRequest.m
//  XRVideoSign
//
//  Created by zhu yangsheng on 1/24/19.
//  Copyright © 2019 xrinfo. All rights reserved.
//

#import "uploadLiveFaceRequest.h"

@implementation uploadLiveFaceRequest
- (HQMRequestMethod)requestMethod {
    return HQMRequestMethodPOST;
}

- (NSString *)requestURLPath {
    return @"/xrspip/api/detectupload";
}

- (NSDictionary *)requestArguments {
    NSDictionary *dicValue = @{
                          @"idcard":@"340821",
                          @"name":@"df",
                          @"vcode":@"1234"
                          };
    NSData *data = [NSJSONSerialization dataWithJSONObject:dicValue
                                                   options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
                                                     error:nil];
    
    if (data == nil) {
        return nil;
    }
    
    NSString *string = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];

    return @{
             @"param":string,
             @"file":@"123.mp4"
             };
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

- (AFConstructingBodyBlock)constructingBodyBlock {
    @weakify(self);
    void (^bodyBlock)(id<AFMultipartFormData> formData) = ^(id<AFMultipartFormData> formData) {
        @strongify(self);
  
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置日期格式
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
 
        //
        NSString * bundlePath = [[NSBundle mainBundle] pathForResource: @"123"ofType :@"mp4"];
        NSData *data = [NSData dataWithContentsOfFile:bundlePath];
        NSLog(@"NSData类方法读取的内容是：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        [formData appendPartWithFileData:data name:@"file" fileName:@"123" mimeType:@"mp4/png/jpg/jpeg"];
            
    };
    
    return bodyBlock;
}

- (void)handleData:(id)data errCode:(NSInteger)errCode {
    NSDictionary *dict = (NSDictionary *)data;
    NSString *path = nil;
    if (VALID_DICTIONARY(dict)) {
        path = [dict objectForKey:@"path"];
    }
    if (self.successBlock) {
        self.successBlock(errCode,nil,path);
    }
}

@end
