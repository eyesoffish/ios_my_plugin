//
//  UserLevelProgressView.h
//  UBaby
//
//  Created by fengei on 16/10/18.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserLevelProgressView : UIView

@property (nonatomic,strong) NSString *labelTitle;//eg:"300/600"
//注意。设置进度应该在调用setProgressWith之后来设置进度
@property (nonatomic,assign) CGFloat progress;
- (void) setProgressWidth:(CGFloat) width height:(CGFloat) height;//设置进度条的宽高
@end
