//
//  FaceView.h
//  MyNavgationTest
//
//  Created by fengei on 16/7/21.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^faceCallBack)(NSString *face);
@interface FaceView : UIView
@property (nonatomic,copy) faceCallBack face;
@end
