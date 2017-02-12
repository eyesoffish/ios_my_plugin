//
//  FaceView.h
//  MyNavgationTest
//
//  Created by fengei on 16/7/21.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import <UIKit/UIKit.h>

//FaceView *faceview = [[FaceView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
//faceview.face = ^(NSString *face)
//{
//    self.textView.text = face;
//};
//self.textView.inputView = faceview;

typedef void (^faceCallBack)(NSString *face);
@interface FaceView : UIView
@property (nonatomic,copy) faceCallBack face;
@end
