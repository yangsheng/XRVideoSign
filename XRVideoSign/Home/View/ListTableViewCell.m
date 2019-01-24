//
//  ListTableViewCell.m
//  XRVideoSign
//
//  Created by zhu yangsheng on 1/21/19.
//  Copyright © 2019 xrinfo. All rights reserved.
//

#import "ListTableViewCell.h"

@implementation ListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)checkBtnClicked:(id)sender {
    UIButton *btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    NSLog(@"");
}

@end
