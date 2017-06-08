//
//  BQScreenAdaptation.h
//  runtimeDemo
//
//  Created by baiqiang on 15/12/2.
//  Copyright © 2015年 baiqiang. All rights reserved.
//

#ifndef BQScreenAdaptation_h
#define BQScreenAdaptation_h

#import <UIKit/UIKit.h>

/**
    将IPHONE_WIDTH改为对应设计图的宽度
    在使用的时候直接使用BQAdaptationFrame函数
    若通过CGRectGetMaxX(firstView.frame)获取视图坐标
    需判断该视图是否已做过适配，若做过适配需要除以BQAdaptationWidth()
    还原为其设计图上的坐标位置
 */
#define IPHONE_WIDTH 640
#define IPHONE_HEIGHT 960
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
static inline CGFloat BQAdaptationWidth() {
    return SCREEN_WIDTH / IPHONE_WIDTH;
}
static inline CGSize BQadaptationSize(CGFloat width, CGFloat height) {
    CGFloat newWidth = width * BQAdaptationWidth();
    CGFloat newHeight = height * BQAdaptationWidth();
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    return newSize;
}
static inline CGPoint BQadaptationCenter(CGPoint point) {
    point.x *= BQAdaptationWidth();
    point.y *= BQAdaptationWidth();
    return point;
}

static inline CGRect BQAdaptationFrame(CGFloat x,CGFloat y, CGFloat width,CGFloat height)  {
    CGFloat newX = x * BQAdaptationWidth();
    CGFloat newY = y * BQAdaptationWidth();
    CGFloat newWidth = width * BQAdaptationWidth();
    CGFloat newHeight = height * BQAdaptationWidth();
    CGRect rect = CGRectMake(newX, newY, newWidth, newHeight);
    return rect;
}
static inline CGFloat fontBigMid(){
    return 33*BQAdaptationWidth();
}
static inline CGFloat fontCell(){
    return 28*BQAdaptationWidth();
}
static inline CGFloat fontSmall(){
    return 15*BQAdaptationWidth();
}
static inline CGFloat fontMid(){
    return 23*BQAdaptationWidth();
}

static inline CGFloat fontNormal(){
    return 20*BQAdaptationWidth();
}
static inline CGFloat fontBig(){
    return 40*BQAdaptationWidth();
}
#endif /* BQScreenAdaptation_h */
