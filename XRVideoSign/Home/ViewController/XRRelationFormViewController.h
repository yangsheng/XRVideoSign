//
//  XRRelationFormViewController.h
//  XRVideoSign
//
//  Created by zhu yangsheng on 1/24/19.
//  Copyright © 2019 xrinfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XRRelationFormViewController : UIViewController
@property (nonatomic,strong) LoginModel *loginModel;
@property (nonatomic, strong) NSMutableDictionary *dataDict;

@end

NS_ASSUME_NONNULL_END
