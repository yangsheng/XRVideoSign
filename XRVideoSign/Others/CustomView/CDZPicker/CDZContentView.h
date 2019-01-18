//
//  CDZContentView.h
//  NBBankEnt
//
//  Created by zhuyangsheng on 2018/11/2.
//  Copyright © 2018 yt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DeleteBtnBlock)(void);
@interface CDZContentView : UIView

@property (nonatomic,weak) IBOutlet UILabel *titleLabel;
@property (nonatomic,weak) IBOutlet UIButton *delBtn;
@property (nonatomic,copy) DeleteBtnBlock deleteBtnBlock;
@end
