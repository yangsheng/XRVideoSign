//
//  ListTableViewCell.h
//  XRVideoSign
//
//  Created by zhu yangsheng on 1/21/19.
//  Copyright © 2019 xrinfo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CellItemClick)(NSInteger nIndex,BOOL bSelected);
NS_ASSUME_NONNULL_BEGIN

@interface ListTableViewCell : UITableViewCell
@property (nonatomic,strong) IBOutlet UIButton *noBtn;
@property (nonatomic,strong) IBOutlet UILabel *mainLabel;
@property (nonatomic,strong) IBOutlet UILabel *dealerLabel;
@property (nonatomic,strong) IBOutlet UILabel *CustomerTypeLabel;
@property (nonatomic,strong) IBOutlet UILabel *methodLabel;
@property (nonatomic,strong) IBOutlet UILabel *nameLabel;
@property (nonatomic,strong) IBOutlet UILabel *moneyLabel;
@property (nonatomic,strong) IBOutlet UILabel *expiredLabel;
@property (nonatomic,copy) CellItemClick cellItemClick;
@end

NS_ASSUME_NONNULL_END
