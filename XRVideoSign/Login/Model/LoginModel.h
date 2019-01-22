//
//  LoginModel.h
//  XRVideoSign
//
//  Created by zhu yangsheng on 1/23/19.
//  Copyright © 2019 xrinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginModel : NSObject
@property (nonatomic,strong) NSString *accountid;
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *systemkeyid;
@property (nonatomic,strong) NSString *classid;
@property (nonatomic,strong) NSString *companyid;
@property (nonatomic,strong) NSString *nickname;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *token;
@property (nonatomic,strong) NSString *password;
@end

NS_ASSUME_NONNULL_END
