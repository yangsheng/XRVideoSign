//
//  XRHomeViewController.h
//  XRVideoSign
//
//  Created by zhu yangsheng on 1/19/19.
//  Copyright © 2019 xrinfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XRHomeViewController : UIViewController
@property (nonatomic,strong) UIViewController *vc;
@property (nonatomic,strong) LoginModel *loginModel;
@end

NS_ASSUME_NONNULL_END
