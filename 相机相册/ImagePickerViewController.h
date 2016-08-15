//
//  ImagePickerViewController.h
//  MyVedio
//
//  Created by fengei on 16/6/12.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "ViewController.h"
typedef void (^callBack)(UIImage *);
@interface ImagePickerViewController : ViewController


+ (void) alertView:(UIViewController *) control;
+ (ImagePickerViewController *) shareImage;//获取相机实列
@property (nonatomic,copy) callBack back;//返回照片
@end
