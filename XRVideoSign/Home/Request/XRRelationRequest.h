//
//  XRRelationRequest.h
//  XRVideoSign
//
//  Created by zhu yangsheng on 1/24/19.
//  Copyright © 2019 xrinfo. All rights reserved.
//

#import "HQMBaseRequest.h"
#import "LoginModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XRRelationRequest : HQMBaseRequest
@property (nonatomic,strong) LoginModel *loginModel;
@property (nonatomic, assign) int current_index;
@property (nonatomic, strong) NSMutableArray *selectList;
@end

NS_ASSUME_NONNULL_END
