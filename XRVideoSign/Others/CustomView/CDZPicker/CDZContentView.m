//
//  CDZContentView.m
//  NBBankEnt
//
//  Created by zhuyangsheng on 2018/11/2.
//  Copyright © 2018 yt. All rights reserved.
//

#import "CDZContentView.h"

@implementation CDZContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)deleteBtnPressed:(id)sender{
    if (self.deleteBtnBlock) {
        self.deleteBtnBlock();
    }
}

@end
