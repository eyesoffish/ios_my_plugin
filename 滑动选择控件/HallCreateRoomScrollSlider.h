//
//  CNScrollSlider.h
//  UBaby
//
//  Created by fengei on 16/12/9.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HallCreateRoomScrollSlider : UIView

/**
 - (HallCreateRoomScrollSlider *)scrollSlider{
 if(!_scrollSlider){
 _scrollSlider = [[HallCreateRoomScrollSlider alloc]initWithFrame:BQAdaptationFrame(25, self.slider1.zlMaxY+70, self.zlWidth - 50, 100)];
 _scrollSlider.layer.masksToBounds = YES;
 _scrollSlider.arrayTime = @[@"30分钟",@"1小时",@"2小时",@"3小时",@"4小时"];
 }
 return _scrollSlider;
 }
 
 */

@property (nonatomic,strong) NSArray *arrayTime;//时间节点
@property (nonatomic,strong) NSMutableArray *arrayImage;//选中、未选中点
@end
