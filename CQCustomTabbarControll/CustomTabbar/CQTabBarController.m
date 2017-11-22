//
//  CQTabBarController.m
//  CQCustomTabbarControll
//
//  Created by chenq@kensence.com on 2017/11/20.
//  Copyright © 2017年 chenq@kensence.com. All rights reserved.
//

#import "CQTabBarController.h"
#if  __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_10_0
#import "UITabBarItem+BageColor.h"
#endif

@interface CQTabBarController ()
@property (nonatomic,assign)NSInteger                   centerPlace;
@property (nonatomic ,assign,getter=is_bulge)BOOL       bulge;
@property (nonatomic ,strong)NSMutableArray<UITabBarItem *> *items;
@property (nonatomic ,assign)CGFloat                    safeBottomInsets;
@end

@implementation CQTabBarController
{
    int tabBarItemTag;
    BOOL firstInit;
    CGRect tabbarFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.centerPlace = -1;
    ContentView *view = [[ContentView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [view setValue:self forKey:@"controller"];
    [self.view addSubview:view];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!firstInit) {
        firstInit = YES;
        NSInteger index = [CQTabBarConfig shared].selectIndex;
        if (index < 0) {
            self.selectedIndex = (self.centerPlace != -1 && self.items[self.centerPlace].tag != -1)? self.centerPlace : 0;
        }else if (index >= self.viewControllers.count)
        {
            self.selectedIndex = self.viewControllers.count - 1;
        }else
        {
            self.selectedIndex = index;
        }
    }
}

- (void)addChildController:(id)Controller title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    UIViewController *vc = [self findViewControllerWithobject:Controller];
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:imageName];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
    
    vc.tabBarItem.tag = tabBarItemTag++;
    [self.items addObject:vc.tabBarItem];
    [self addChildViewController:Controller];
}


- (void)addCenterController:(id)Controller bulge:(BOOL)bulge title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    _bulge = bulge;
    if (Controller) {
        [self addChildController:Controller title:title imageName:imageName selectedImageName:selectedImageName];
        self.centerPlace = tabBarItemTag - 1;
    }else
    {
        UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:title image:[UIImage imageNamed:imageName] selectedImage:[UIImage imageNamed:selectedImageName]];
        item.tag = -1;
        [self.items addObject:item];
        self.centerPlace = tabBarItemTag;
    }
}


-(CQTabBar *)tabbar
{
    if (self.items.count && !_tabbar) {
        _tabbar = [[CQTabBar alloc]initWithFrame:CGRectZero];
        [_tabbar setValue:self forKey:@"controller"];
        [_tabbar setValue:[NSNumber numberWithBool:self.bulge] forKey:@"bulge"];
        [_tabbar setValue:[NSNumber numberWithInteger:self.centerPlace] forKey:@"centerPlace"];
        _tabbar.items = self.items;
        
        for (UIView *loop in self.tabBar.subviews) {
            [loop removeFromSuperview];
        }
        self.tabBar.hidden = YES;
        [self.tabBar removeFromSuperview];
    }
    return _tabbar;
}

- (NSMutableArray<UITabBarItem *> *)items
{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}


- (void)InitializeTabbar{
    [_tabbar setValue:[NSNumber numberWithBool:self.bulge] forKey:@"bulge"];
    [_tabbar setValue:[NSNumber numberWithInteger:self.centerPlace] forKey:@"centerPlace"];
    _tabbar.items = self.items;
}

/**
 *  Update current select controller
 */
- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if (selectedIndex >= self.viewControllers.count) {
        @throw [NSException exceptionWithName:@"selectedTabbarError" reason:@"No controller can be used,Because of index beyond the viewControllers,Please check the configuration of tabbar." userInfo:nil];
    }
    
    [super setSelectedIndex:selectedIndex];
    UIViewController *viewController = [self findViewControllerWithobject:self.viewControllers[selectedIndex]];
    [self.tabbar removeFromSuperview];
    [viewController.view addSubview:self.tabbar];
    [self.tabbar setValue:[NSNumber numberWithInteger:selectedIndex] forKey:@"selectButtoIndex"];
    [self.tabbar setNeedsLayout];
}

/**
 *  Layout tabBar for superView
 */
- (void)setLayoutTabBar:(UIView *)layoutTabBar {
    self.safeBottomInsets = 0;
    if (@available(iOS 11.0, *)) {
        self.safeBottomInsets = self.view.safeAreaInsets.bottom;
    }
    
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    CGRect rect = CGRectMake(0,
                             h-49-self.safeBottomInsets-layoutTabBar.frame.origin.y,
                             layoutTabBar.frame.size.width,
                             49+self.safeBottomInsets);
    self.tabbar.frame = rect;
}

/**
 *  Catch viewController
 */
- (UIViewController *)findViewControllerWithobject:(id)object{
    while ([object isKindOfClass:[UITabBarController class]] || [object isKindOfClass:[UINavigationController class]]){
        object = ((UITabBarController *)object).viewControllers.firstObject;
    }
    return object;
}

- (void)setCQTabbarHiden:(BOOL)hidden animated:(BOOL)animated
{
    NSTimeInterval time = animated ? 0.3:0.0;
    if (self.tabbar.isHidden) {
        self.tabbar.hidden = NO;
        [UIView animateWithDuration:time animations:^{
            self.tabbar.transform = CGAffineTransformIdentity;
        }];
    }else
    {
        CGFloat h = self.tabbar.frame.size.height;
        [UIView animateWithDuration:time - 0.1 animations:^{
           self.tabbar.transform = CGAffineTransformMakeTranslation(0,h);
        } completion:^(BOOL finished) {
            self.tabbar.hidden = YES;
        }];
    }
}



@end
