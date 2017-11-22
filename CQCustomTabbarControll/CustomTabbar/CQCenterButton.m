//
//  CQCenterButton.m
//  CQCustomTabbarControll
//
//  Created by chenq@kensence.com on 2017/11/20.
//  Copyright © 2017年 chenq@kensence.com. All rights reserved.
//

#import "CQCenterButton.h"

@implementation CQCenterButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
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
    if (CGRectEqualToRect(self.frame, CGRectZero)) {
        return;
    }
    if (self.is_bulge) {
        self.imageView.frame = self.bounds;
        if (self.titleLabel.text.length) {
            self.titleLabel.frame = CGRectMake(0, self.frame.size.height + (BULGEH - 16), self.frame.size.width, 16);
        }else
        {
            CGRect rect = self.imageView.frame;
            rect.size.height += 8;
            self.imageView.frame = rect;
    }
        return;
    }
        if (!self.titleLabel.text.length) {
            self.imageView.frame = self.bounds;
            return;
        }
        CGFloat width = self.frame.size.width;
        CGFloat height = self.superview.frame.size.height;
        self.titleLabel.frame = CGRectMake(0, height - BULGEH, width, BULGEH);
        self.imageView.frame  = CGRectMake(0, 0, width, 35);
        
}

- (void)setHighlighted:(BOOL)highlighted{
}

@end
