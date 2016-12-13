//
//  UserInfoModCityViewController.h
//  UBaby
//
//  Created by fengei on 16/11/21.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "ReturnViewController.h"

@interface UserInfoModCityViewController : ReturnViewController

@property (nonatomic,strong) void(^modCallback)();
@property (nonatomic,strong) NSString *city;
@property (nonatomic,copy) NSString *stringCity;
@end
