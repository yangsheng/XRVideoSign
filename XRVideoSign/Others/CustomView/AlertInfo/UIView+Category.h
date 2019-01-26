//
//  UIView+Category.h
//  NBBankEnt
//
//  Created by zhu yangsheng on 1/26/19.
//  Copyright © 2019 xrinfo. All rights reserved.
//


@import UIKit;

@interface UIView (Category)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

/**
 *	@brief	获取传递UIView或者其subviews是Class的
 */
- (UIView *)descendantOrSelfWithClass:(Class) cls;

/**
 *	@brief	获取View所属的view controller
 */
- (UIViewController *)viewController;

- (UINavigationController *)navigationController;

/**
 *	@brief	长度、宽度按百分比缩放
 */
- (void)resizeToPrecent:(float) precent;

- (void)removeAllSubviews;

/**
 *  @brief 判断自己是否在父视图上
 */
- (BOOL)visiable;

/**
 *  @brief  切圆角
 */
- (void)cornerRadius:(CGFloat)radius;

/**
 *  @brief  切圆
 */
- (void)cutCircle;
@end
