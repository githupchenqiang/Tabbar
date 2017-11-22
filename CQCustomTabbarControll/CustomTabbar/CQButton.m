//
//  CQButton.m
//  CQCustomTabbarControll
//
//  Created by chenq@kensence.com on 2017/11/20.
//  Copyright © 2017年 chenq@kensence.com. All rights reserved.
//

#import "CQButton.h"
#import "CQBadgeView.h"
#import "CQTabBarConfig.h"

@interface CQButton();

@property (nonatomic ,weak)CQBadgeView          *badgeView;

@end
@implementation CQButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.adjustsImageWhenHighlighted = NO;
        self.imageView.contentMode = UIViewContentModeCenter;
        [self setTitleColor:[CQTabBarConfig shared].textColor forState:UIControlStateNormal];
        [self setTitleColor:[CQTabBarConfig shared].selectedTextColor forState:UIControlStateSelected];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = self.frame.size.width;
    
    CGFloat height = self.superview.frame.size.height - [[self.superview valueForKeyPath:@"controller.safeBottomInsets"]floatValue];
    if (self.titleLabel.text && ![self.titleLabel.text isEqualToString:@""]) {
        self.titleLabel.frame = CGRectMake(0, height-16, width, 16);
        self.imageView.frame = CGRectMake(0 , 0, width, 35);
    }
    else{
        self.imageView.frame = CGRectMake(0 , 0, width, height);
    }
}
/**
 *  Set red dot item
 */
- (void)setItem:(UITabBarItem *)item {
    self.badgeView.badgeValue = item.badgeValue;
    self.badgeView.badgeColor = item.badgeColor;
}


- (CQBadgeView *)badgeView {
    if (!_badgeView) {
        CQBadgeView * badgeView = [[CQBadgeView alloc] init];
        _badgeView = badgeView;
        [self addSubview:badgeView];
    }
    return _badgeView;
}

- (void)setHighlighted:(BOOL)highlighted{
}

    

@end
