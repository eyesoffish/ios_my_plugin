//
//  UIView+ZLRefresh.m
//  iosSelfTableView
//
//  Created by fengei on 16/8/1.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "UIView+ZLRefresh.h"

@implementation UIView (ZLRefresh)

- (void)setH:(float)h
{
    CGRect frame = self.frame;
    frame.size.height = h;
    self.frame = frame;
}
- (float)h
{
    return self.frame.size.height;
}
// w
- (void)setW:(float)w
{
    CGRect frame = self.frame;
    frame.size.width = w;
    self.frame = frame;
}
- (float)w
{
    return self.frame.size.width;
}

//x
- (void)setX:(float)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (float)x
{
    return self.frame.origin.x;
}

- (void)setY:(float)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (float)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
- (CGFloat)centerX
{
    return self.center.x;
}
- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
- (CGFloat)centerY
{
    return self.center.y;
}
@end
