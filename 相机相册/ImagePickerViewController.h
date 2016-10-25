//
//  ImagePickerViewController.h
//  MyVedio
//
//  Created by fengei on 16/6/12.
//  Copyright © 2016年 fengei. All rights reserved.
//



// <key>NSPhotoLibraryUsageDescription</key>
// <string>确认访问相册</string>
#import <UIKit/UIKit.h>
typedef void (^callBack)(UIImage *);
@interface ImagePickerViewController : UIViewController
//弹出层的按钮可设置按钮属性


//
+ (void) alertView:(UIViewController *) control;
+ (ImagePickerViewController *) shareImage;//获取相机实列
@property (nonatomic,copy) callBack back;//返回照片
@end
