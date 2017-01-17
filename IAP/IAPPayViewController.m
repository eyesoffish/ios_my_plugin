//
//  IAPPayViewController.m
//  ZL_IAPPay
//
//  Created by fengei on 16/8/16.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "IAPPayViewController.h"
#import <StoreKit/StoreKit.h>
@interface IAPPayViewController ()<SKProductsRequestDelegate,SKPaymentTransactionObserver>

@end

@implementation IAPPayViewController
{
    SKProductsRequest *_request;
    SKProduct *_product;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ----function
+ (IAPPayViewController *)sharedIAPPay
{
    static IAPPayViewController *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[IAPPayViewController alloc]init];
    });
    return instance;
}
+ (void)iapPayWithProductsID:(NSString *)productID
{
    //判断设备是否允许iap支付
    if([SKPaymentQueue canMakePayments])
    {
        [[IAPPayViewController sharedIAPPay] iapPayWithProductsID:productID];
    }
    else
    {
        NSLog(@"用户禁止iap支付");
    }
}
- (void)iapPayWithProductsID:(NSString *)productID
{
    NSSet *set = [[NSSet alloc]initWithObjects:productID, nil];
    _request = [[SKProductsRequest alloc]initWithProductIdentifiers:set];
    _request.delegate = self;
    [_request start];
}
- (void) callBack:(NSString *) info
{
    if(self.iapcallBackInfo)
    {
        self.iapcallBackInfo(info);
    }
}
#pragma mark ---delegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    _request = nil;
    for(SKProduct *product in response.products)
    {
        //返回商品信息
        _product = product;
        if(self.iapProductInfo)
        {
            self.iapProductInfo(product.localizedTitle,product.localizedDescription,product.price);
        }
    }
    if(!_product)
    {
        [self callBack:@"无法获取商品信息"];
    }
    else
    {
        //获取支付队列
        SKPayment *payment = [SKPayment paymentWithProduct:_product];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}
//购买出错
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSString *str = [NSString stringWithFormat:@"出错：%@",error];
    [self callBack:str];
}
//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    for(SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self callBack:@"交易完成"];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self callBack:@"交易失败"];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self callBack:@"已经购买过该商品"];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            default:
                break;
        }
        
    }
}
- (void)dealloc
{
    [[SKPaymentQueue defaultQueue]removeTransactionObserver:self];
}
@end
