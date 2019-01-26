//
//  NBInfoView.h
//  NBBankEnt
//
//  Created by zhu yangsheng on 1/26/19.
//  Copyright © 2019 xrinfo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonClick)(NSInteger nIndex);

@interface NBInfoView : UIView

+ (NBInfoView *)sharedNBInfoView;

- (void)alertViewShowOnView:(UIView *)superView
                 ContentDic:(NSDictionary*)dic
              ButtonAciton:(ButtonClick)btnAction;

@property (nonatomic, copy) ButtonClick btnAciton;


@end
