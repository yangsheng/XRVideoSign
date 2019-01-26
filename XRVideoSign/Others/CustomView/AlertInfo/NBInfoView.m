//
//  NBInfoView.m
//  NBBankEnt
//
//  Created by zhu yangsheng on 1/26/19.
//  Copyright © 2019 xrinfo. All rights reserved.
//

#import "NBInfoView.h"

#import "UIView+Category.h"


@interface NBInfoView ()
@property (nonatomic, weak) IBOutlet UIView *cover;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UIButton *confirmBtn;
@property (nonatomic, weak) NSString *btnName;
@end

@implementation NBInfoView

+ (NBInfoView *)sharedNBInfoView{
    static NBInfoView *theView;
    @synchronized(self) {
        if (!theView)
            theView = [[self alloc] init];
    }
    return theView;
}

- (void)alertViewShowOnView:(UIView *)superView
                 ContentDic:(NSDictionary*)dic
               ButtonAciton:(ButtonClick)btnAction

{
    NBInfoView *view = [[[NSBundle mainBundle] loadNibNamed:@"NBInfoView" owner:self options:nil] lastObject];
    view.width = 310;
    view.height = 230;
    view.left = ([UIScreen mainScreen].bounds.size.width-310)/2;
    view.top = ([UIScreen mainScreen].bounds.size.height-230) * 1/3+40;
    [view cornerRadius:8];
    [view coverOnSuperView:superView];
    [superView addSubview:view];
    view.btnAciton = btnAction;
    //
    view.titleLabel.text = [dic objectForKey:@"title"];
    view.contentLabel.text = [dic objectForKey:@"content"];
    [view.confirmBtn setTitle:[dic objectForKey:@"confirmName"] forState:UIControlStateNormal];
    
}

- (void)coverOnSuperView:(UIView *)superView
{
    UIView *coverView = [[UIView alloc] initWithFrame:superView.bounds];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0;
    [superView addSubview:coverView];
    
    [UIView animateWithDuration:0.3 animations:^{
        coverView.alpha = 0.6;
    }];
    
    self.cover = coverView;
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
//    [coverView addGestureRecognizer:tap];
}


- (void)close{
    [self.cover removeFromSuperview];
    [self removeFromSuperview];
}

- (IBAction)btnClick:(UIButton *)sender {
    UIButton *btn = (UIButton*)sender;
    [self close];
    if (self.btnAciton) {
        self.btnAciton(btn.tag);
    }
}
@end
