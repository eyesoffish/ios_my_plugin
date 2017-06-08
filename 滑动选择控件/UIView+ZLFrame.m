//
//  UIView+ZLFrame.m
//  UBaby
//
//  Created by fengei on 16/11/14.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "UIView+ZLFrame.h"
#import "BQScreenAdaptation.h"
#import "NSString+iOSVersion.h"
@implementation UIView (ZLFrame)

- (CGFloat)zlMinX{
    return CGRectGetMinX(self.frame) / BQAdaptationWidth();
}
- (CGFloat)zlMaxX{
    return CGRectGetMaxX(self.frame) / BQAdaptationWidth();
}
- (CGFloat)zlMinY{
    return CGRectGetMinY(self.frame) / BQAdaptationWidth();
}
- (CGFloat)zlMaxY{
    return CGRectGetMaxY(self.frame) / BQAdaptationWidth();
}
- (CGFloat)zlMidX{
    return CGRectGetMidX(self.frame) / BQAdaptationWidth();
}
- (CGFloat)zlMidY{
    return CGRectGetMidY(self.frame) / BQAdaptationWidth();
}
- (CGFloat)zlWidth{
    return CGRectGetWidth(self.frame) / BQAdaptationWidth();
}
- (CGFloat)zlHeight{
    return CGRectGetHeight(self.frame) / BQAdaptationWidth();
}

//适配高度
+ (CGFloat) webViewAdapterHeight{
    NSString *version = [NSString GetCurrentDeviceModel];
    CGFloat moveUP = 65;
    if([version containsString:@"iPod"] || [version containsString:@"iPhone 5s"]){
        moveUP = 45;
    }
    return moveUP;
}
@end
