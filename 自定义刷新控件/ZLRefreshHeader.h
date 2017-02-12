//
//  ZLRefreshHeader.h
//  iosSelfTableView
//
//  Created by fengei on 16/8/1.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+ZLRefresh.h"
@interface ZLRefreshHeader : UIView

UIKIT_EXTERN const CGFloat ZLRefreshHeaderHeight;
UIKIT_EXTERN const CGFloat ZLRefreshPointRadius;

@property (nonatomic,copy) void(^handle)();
- (void) endRefreshing;
@end
