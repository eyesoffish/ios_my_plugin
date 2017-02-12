//
//  UIScrollView+ZLRefresh.m
//  iosSelfTableView
//
//  Created by fengei on 16/8/2.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "UIScrollView+ZLRefresh.h"
#import <objc/runtime.h>
#import "ZLRefreshHeader.h"
@implementation UIScrollView (ZLRefresh)
- (void)addRefreshheaderWithhandle:(void (^)())handle
{
    ZLRefreshHeader *header = [[ZLRefreshHeader alloc]init];
    header.handle = handle;
    self.header = header;
    [self insertSubview:header atIndex:0];
}
- (void)setHeader:(ZLRefreshHeader *)header
{
    objc_setAssociatedObject(self, @selector(header), header, OBJC_ASSOCIATION_ASSIGN);
}
- (ZLRefreshHeader *)header
{
    return objc_getAssociatedObject(self, @selector(header));
}
+ (void)load
{
    Method originalMethod = class_getInstanceMethod([self class],NSSelectorFromString(@"dealloc"));
    Method swizzleMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"su_dealloc"));
    method_exchangeImplementations(originalMethod, swizzleMethod);
}
- (void) su_dealloc
{
    self.header = nil;
    [self su_dealloc];
}
@end
