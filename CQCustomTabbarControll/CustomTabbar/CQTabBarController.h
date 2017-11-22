//
//  CQTabBarController.h
//  CQCustomTabbarControll
//
//  Created by chenq@kensence.com on 2017/11/20.
//  Copyright © 2017年 chenq@kensence.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CQTabBar.h"
#define CQTABBarController ((CQTabBarController *)self.tabBarController)

@interface CQTabBarController : UITabBarController
@property (nonatomic ,strong)CQTabBar           *tabbar;


/**
 添加子控制器

 @param Controller 需管理的子控制器
 @param title 底部文字
 @param imageName 未选中的图片名
 @param selectedImageName 选中的图片名
 */
- (void)addChildController:(id)Controller
                     title:(NSString *)title
                 imageName:(NSString *)imageName
         selectedImageName:(NSString *)selectedImageName;




/**
 设置中间按钮

 @param Controller 需要控制的子控制器
 @param bulge 圆形凸出 bulge传入YES  普通 bulge传入NO
 @param title   底部文字
 @param imageName 未选中的图片名
 @param selectedImageName 选中的图片名
 */
- (void)addCenterController:(id)Controller
                      bulge:(BOOL)bulge
                      title:(NSString *)title
                  imageName:(NSString *)imageName
          selectedImageName:(NSString *)selectedImageName;


/**
 隐藏tabbar

 @param hidden 是否隐藏
 @param animated 是否执行动画 
 */
- (void)setCQTabbarHiden:(BOOL)hidden animated:(BOOL)animated;


@end
