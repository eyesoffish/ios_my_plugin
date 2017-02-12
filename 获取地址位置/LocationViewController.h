//
//  LocationViewController.h
//  UBaby
//
//  Created by fengei on 17/1/5.
//  Copyright © 2017年 fengei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationViewController : UIViewController
//开始定位
- (void)startLocating;
@property (nonatomic,copy) void(^callBackCity)(NSString *city);
@end
