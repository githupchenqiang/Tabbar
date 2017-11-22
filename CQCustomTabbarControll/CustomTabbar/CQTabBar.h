//
//  CQTabBar.h
//  CQCustomTabbarControll
//
//  Created by chenq@kensence.com on 2017/11/20.
//  Copyright © 2017年 chenq@kensence.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CQCenterButton.h"
@class CQButton;
@class CQTabBar;


@protocol CQTabBarDelegate <NSObject>
@optional
//中间按钮点击会通过这个代理通知
- (void)tabbar:(CQTabBar *)tabbar clickForCenterButton:(CQCenterButton *)centerButton;

// 默认返回YES，允许所有的切换，不过你通过TabBarController来直接设置SelectIndex来切换的是不会收到通知的。
- (BOOL)tabbar:(CQTabBar *)tabbar willSelectIndex:(NSInteger)index;

//通知已经选择的控制器下标
- (void)tabbar:(CQTabBar *)tabBar didSelectIndex:(NSInteger)index;
@end

@interface CQTabBar : UIView
@property (nonatomic ,copy)NSArray<UITabBarItem *> *items; //tabbar按钮显示信息
@property (nonatomic ,strong)NSMutableArray <CQButton *> *btnArr; //其他按钮
@property (nonatomic ,strong)CQCenterButton             *centerBtn; //中间按钮
@property (nonatomic ,assign)id <CQTabBarDelegate>delegate;



@end


@interface ContentView:UIView


@end;
