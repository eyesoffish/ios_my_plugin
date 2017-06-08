//
//  UserLevelProgressView.h
//  UBaby
//
//  Created by fengei on 16/10/18.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserLevelProgressView : UIView

/**
 - (UserLevelProgressView *)progressView{
 if(!_progressView){
 _progressView = [[UserLevelProgressView alloc]initWithFrame:BQAdaptationFrame(self.labelExp.zlMaxX+10, self.labelExp.zlMinY, IPHONE_WIDTH - 260, 30)];
 [_progressView setProgressWidth:IPHONE_WIDTH - 260 height:30];
 _progressView.progress = 0.75;
 _progressView.labelTitle = @"";
 }
 return _progressView;
 }
 
 首先调用设置进度条宽高。然后再设置值
 */
@property (nonatomic,strong) NSString *labelTitle;//eg:"300/600"
@property (nonatomic,assign) CGFloat progress;
- (void) setProgressWidth:(CGFloat) width height:(CGFloat) height;//设置进度条的宽高
@end
