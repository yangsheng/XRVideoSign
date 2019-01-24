//
//  XRFaceLiveFourRequest.h
//  XRVideoSign
//
//  Created by zhu yangsheng on 1/24/19.
//  Copyright © 2019 xrinfo. All rights reserved.
//

#import "HQMBaseRequest.h"
#import "LoginModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XRFaceLiveFourRequest : HQMBaseRequest
@property (nonatomic,strong) LoginModel *loginModel;
@end

NS_ASSUME_NONNULL_END
