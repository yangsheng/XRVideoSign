//
//  XRObjectSaveRequest.h
//  XRVideoSign
//
//  Created by zhu yangsheng on 1/26/19.
//  Copyright © 2019 xrinfo. All rights reserved.
//

#import "HQMBaseRequest.h"
#import "LoginModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XRObjectSaveRequest : HQMBaseRequest
@property (nonatomic,strong) LoginModel *loginModel;
@property (nonatomic,strong) NSMutableDictionary *dataPushData;
@property (nonatomic,strong) NSMutableDictionary *objectData;
@property (nonatomic,strong) NSMutableDictionary *adjunctData;
@property (nonatomic,strong) NSMutableDictionary *utilObj;

@end

NS_ASSUME_NONNULL_END
