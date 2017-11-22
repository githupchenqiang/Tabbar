//
//  UITabBarItem+BageColor.m
//  CQCustomTabbarControll
//
//  Created by chenq@kensence.com on 2017/11/17.
//  Copyright © 2017年 chenq@kensence.com. All rights reserved.
//

#import "UITabBarItem+BageColor.h"
#import <objc/runtime.h>
static const char itemBadgeColor_Key;

@implementation UITabBarItem (BageColor)
@dynamic badgeColor;

- (void)setBageColor:(UIColor *)badgeColor
{
    [self didChangeValueForKey:@"badgeColor"];
    objc_setAssociatedObject(self, &itemBadgeColor_Key, badgeColor, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"badgeColor"];
}

- (UIColor *)badgeColor
{
    return objc_getAssociatedObject(self, &itemBadgeColor_Key);
}

@end
