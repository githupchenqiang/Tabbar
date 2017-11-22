//
//  CQTabBar.m
//  CQCustomTabbarControll
//
//  Created by chenq@kensence.com on 2017/11/20.
//  Copyright © 2017年 chenq@kensence.com. All rights reserved.
//

#import "CQTabBar.h"
#import "CQButton.h"
#import "CQTabBarConfig.h"

@interface CQTabBar()
@property (assign ,nonatomic)NSInteger              centerPlace;
@property (nonatomic ,weak)CQButton                 *selButton;
@property (nonatomic ,assign,getter=is_bulge)BOOL                   bulge;
@property (nonatomic ,weak)UITabBarController       *controller;
@property (nonatomic ,weak)CAShapeLayer             *borber;
@end

@implementation CQTabBar
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.btnArr = [NSMutableArray array];
        if ([CQTabBarConfig shared].haveBorder) {
            self.borber.fillColor = [CQTabBarConfig shared].bordergColor.CGColor;
        }
        self.backgroundColor = [CQTabBarConfig shared].backgroundColor;
        [[CQTabBarConfig shared]addObserver:self forKeyPath:@"textColor" options:NSKeyValueObservingOptionNew context:nil];
        [[CQTabBarConfig shared]addObserver:self forKeyPath:@"selectedTextColor" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)setItems:(NSArray<UITabBarItem *> *)items
{
    _items = items;
    for (int i=0; i<items.count; i++)
    {
        UITabBarItem *item = items[i];
        UIButton *btn = nil;
        if (-1 != self.centerPlace && i == self.centerPlace)
        {
            self.centerBtn = [CQCenterButton buttonWithType:UIButtonTypeCustom];
            self.centerBtn.adjustsImageWhenHighlighted = NO;
            self.centerBtn.bluge = self.is_bulge;
            btn = self.centerBtn;
            if (item.tag == -1)
            {
                [btn addTarget:self action:@selector(centerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                [btn addTarget:self action:@selector(controlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        else
        {
            btn = [CQButton buttonWithType:UIButtonTypeCustom];
            //Add Observer
            [item addObserver:self forKeyPath:@"badgeValue"
                      options:NSKeyValueObservingOptionNew
                      context:(__bridge void * _Nullable)(btn)];
            [item addObserver:self forKeyPath:@"badgeColor"
                      options:NSKeyValueObservingOptionNew
                      context:(__bridge void * _Nullable)(btn)];
            
            [self.btnArr addObject:(CQButton *)btn];
            [btn addTarget:self action:@selector(controlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        //Set image
        [btn setImage:item.image forState:UIControlStateNormal];
        [btn setImage:item.selectedImage forState:UIControlStateSelected];
        btn.adjustsImageWhenHighlighted = NO;
        
        //Set title
        [btn setTitle:item.title forState:UIControlStateNormal];
        btn.tag = item.tag;
        [self addSubview:btn];
    }
}

-(CAShapeLayer *)borber
{
    if (!_borber) {
        CAShapeLayer *border = [CAShapeLayer layer];
        border.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.bounds.size.width, [CQTabBarConfig shared].borderHeight)].CGPath;
        [self.layer insertSublayer:border atIndex:0];
        _borber = border;
    }
    return _borber;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.controller setValue:self.superview forKey:@"layoutTabBar"];
    int count = (int)(self.centerBtn ? self.btnArr.count + 1 : self.btnArr.count);
    NSInteger mid = ({
        NSInteger mid = [CQTabBarConfig shared].centerBtnIndex;
        (mid >= 0 && mid < count) ? mid : count/2;
    });
    
    CGRect rect = ({
        CGRectMake(0, 0, self.bounds.size.width / count, self.bounds.size.height - [[self.controller valueForKeyPath:@"safeBottomInsets"]floatValue]);
    });
    
    int j = 0;
    for (int i=0; i<count; i++) {
        if (i == mid && self.centerBtn!= nil) {
            CGFloat h = self.items[self.centerPlace].title ? 10.f : 0;
            self.centerBtn.frame = self.is_bulge
            ? CGRectMake(rect.origin.x,
                         -BULGEH-h ,
                         rect.size.width,
                         rect.size.height+h)
            : rect;
        }
        else{
            self.btnArr[j++].frame = rect;
        }
        rect.origin.x += rect.size.width;
    }
    
    _borber.path = [UIBezierPath bezierPathWithRect:CGRectMake(0,0,
                                                               self.bounds.size.width,
                                                               [CQTabBarConfig shared].borderHeight)].CGPath;
}


/**
 *  Control button click
 */
- (void)controlBtnClick:(CQButton *)button {
    if ([self.delegate respondsToSelector:@selector(tabbar:willSelectIndex:)]) {
        if (![self.delegate tabbar:self willSelectIndex:button.tag]) {
            return;
        }
    }
    self.controller.selectedIndex = button.tag;
}


/**
 *  Updata select button UI (kvc will setting)
 */
- (void)setSelectButtoIndex:(NSUInteger)index {
    if (self.centerBtn && index == self.centerBtn.tag) {
        self.selButton = (CQButton *)self.centerBtn;
    }else{
        for (CQButton *loop in self.btnArr) {
            if (loop.tag == index){
                self.selButton = loop;
                break;
            }
        }
    }
    if ([self.delegate respondsToSelector:@selector(tabbar:didSelectIndex:)]) {
        [self.delegate tabbar:self didSelectIndex:index];
    }
}


- (void)setSelButton:(CQButton *)selButton
{
    _selButton.selected = NO;
    _selButton = selButton;
    _selButton.selected = YES;
}


/**
 *  Center button click
 */
- (void)centerBtnClick:(CQCenterButton *)button {
    if ([self.delegate respondsToSelector:@selector(tabbar:clickForCenterButton:)]) {
        [self.delegate tabbar:self clickForCenterButton:button];
    }
}


/**
 *  Observe the attribute value change
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"badgeValue"] || [keyPath isEqualToString:@"badgeColor"]) {
        CQButton *btn = (__bridge CQButton *)(context);
        btn.item = (UITabBarItem*)object;
    }
    else if ([object isEqual:[CQTabBarConfig shared]]){
        if([keyPath isEqualToString:@"textColor"] ||[keyPath isEqualToString:@"selectedTextColor"]) {
            UIColor *color = change[@"new"];
            UIControlState state = [keyPath isEqualToString:@"textColor"]? UIControlStateNormal: UIControlStateSelected;
            for (UIButton *loop in self.btnArr){
                [loop setTitleColor:color forState:state];
            }
        }
    }
}

/**
 *  Remove observer
 */
- (void)dealloc {
    for (int i=0; i<self.btnArr.count; i++) {
        int index = ({
            int n = 0;
            if (-1 != _centerPlace)
                n = _centerPlace > i ? 0 : 1;
            i+n;});
        [self.items[index] removeObserver:self
                               forKeyPath:@"badgeValue"
                                  context:(__bridge void * _Nullable)(self.btnArr[i])];
        [self.items[index] removeObserver:self
                               forKeyPath:@"badgeColor"
                                  context:(__bridge void * _Nullable)(self.btnArr[i])];
    }
    [[CQTabBarConfig shared]removeObserver:self forKeyPath:@"textColor" context:nil];
    [[CQTabBarConfig shared]removeObserver:self forKeyPath:@"selectedTextColor" context:nil];
}
@end

@interface ContentView()
@property(weak,nonatomic)UITabBarController         *controller;

@end
@implementation ContentView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CQTabBar *tabBar = [self.controller valueForKeyPath:@"tabbar"];
    for (CQButton *loop in tabBar.btnArr) {
        CGRect rect = [tabBar convertRect:loop.frame toView:self];
        if (CGRectContainsPoint(rect, point)) {
            return loop;
        }
    }
    
    CGRect rect = [tabBar convertRect:tabBar.centerBtn.frame toView:self];
    if (CGRectContainsPoint(rect, point)) {
        return tabBar.centerBtn;
    }
    
    return [super hitTest:point withEvent:event];
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return NO;
}
@end



