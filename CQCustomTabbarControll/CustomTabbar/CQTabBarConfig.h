//
//  CQTabBarConfig.h
//  CQCustomTabbarControll
//
//  Created by chenq@kensence.com on 2017/11/17.
//  Copyright © 2017年 chenq@kensence.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CQTabBarConfig : NSObject
/**设置文字颜色*/
@property(nonatomic,strong)UIColor          *textColor;
/** 设置文字选中颜色*/
@property(nonatomic,strong)UIColor          *selectedTextColor;
/**背景颜色*/
@property(nonatomic,strong)UIColor          *backgroundColor;

/** 指定的初始化控制器 */
@property(assign , nonatomic) NSInteger selectIndex;
/** 是否存在bar底部分割线 */
@property(assign , nonatomic) BOOL haveBorder;
/** bar底部分割线的高度 */
@property(assign , nonatomic) CGFloat borderHeight;
/** bar的底部分割线颜色 */
@property(strong , nonatomic) UIColor *bordergColor;
/** 中间按钮所在位置 */
@property (nonatomic,assign) NSInteger centerBtnIndex;

+ (instancetype)shared;
@end
