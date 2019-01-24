//
//  XRLoginRequest.h
//  XRVideoSign
//
//  Created by zhu yangsheng on 1/22/19.
//  Copyright © 2019 xrinfo. All rights reserved.
//

#import "HQMBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface XRLoginRequest : HQMBaseRequest
/**接口需要传的参数*/
@property (nonatomic, copy) NSString *user;
@property (nonatomic, copy) NSString *password;
@end

NS_ASSUME_NONNULL_END
