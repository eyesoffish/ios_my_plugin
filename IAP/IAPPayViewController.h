//
//  IAPPayViewController.h
//  ZL_IAPPay
//
//  Created by fengei on 16/8/16.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^iapProductInfo)(NSString *title,NSString *desc,NSNumber *price);
typedef void (^iapCallBackInfo)(NSString *callBackInfo);
@interface IAPPayViewController : UIViewController

//单列
+ (IAPPayViewController *) sharedIAPPay;
//支付
+ (void) iapPayWithProductsID:(NSString *)productID;
//返回商品信息
@property (nonatomic,copy) iapProductInfo iapProductInfo;
//返回回调信息
@property (nonatomic,copy) iapCallBackInfo iapcallBackInfo;
@end
