//
//  UIScrollView+ZLRefresh.h
//  iosSelfTableView
//
//  Created by fengei on 16/8/2.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZLRefreshHeader;
@interface UIScrollView (ZLRefresh)

@property (nonatomic,weak,readonly) ZLRefreshHeader *header;

- (void) addRefreshheaderWithhandle:(void(^)())handle;
@end
