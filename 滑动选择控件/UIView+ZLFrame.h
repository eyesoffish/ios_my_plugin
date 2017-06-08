//
//  UIView+ZLFrame.h
//  UBaby
//
//  Created by fengei on 16/11/14.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZLFrame)

@property (nonatomic,assign,readonly) CGFloat zlMinX;
@property (nonatomic,assign,readonly) CGFloat zlMaxX;
@property (nonatomic,assign,readonly) CGFloat zlMinY;
@property (nonatomic,assign,readonly) CGFloat zlMaxY;
@property (nonatomic,assign,readonly) CGFloat zlMidX;
@property (nonatomic,assign,readonly) CGFloat zlMidY;
@property (nonatomic,assign,readonly) CGFloat zlWidth;
@property (nonatomic,assign,readonly) CGFloat zlHeight;

+ (CGFloat) webViewAdapterHeight;//适配高度
@end
