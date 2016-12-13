//
//  TextView.m
//  UBaby
//
//  Created by fengei on 16/11/1.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "TextView.h"
#import "BQScreenAdaptation.h"
@implementation TextView

- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 10 * BQAdaptationWidth();
    return iconRect;
}
@end
