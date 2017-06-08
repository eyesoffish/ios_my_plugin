//
//  CNScrollSlider.m
//  UBaby
//
//  Created by fengei on 16/12/9.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "HallCreateRoomScrollSlider.h"
#import "BQScreenAdaptation.h"
#import "UIView+ZLFrame.h"
#import "Tool.h"
@interface HallCreateRoomScrollSlider ()

@property (nonatomic,strong) UIView *lineVeiw;//背景线
@property (nonatomic,strong) UIView *lineBackView;

@end
@implementation HallCreateRoomScrollSlider

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setupUI];
    }
    return self;
}
#pragma mark -- Function
- (void) setupUI{
    [self addSubview:self.lineBackView];
    [self addSubview:self.lineVeiw];
    
}
- (void)setArrayTime:(NSArray *)arrayTime{
    _arrayTime = arrayTime;
    CGFloat margin = (self.zlWidth - 60.0) / (self.arrayTime.count - 1);
    CGFloat labeFont = 20;
    CGFloat imageW = 35;
    CGFloat marginY = 40;
    CGFloat labelW = 80;
    if(arrayTime.count > 5){
        labeFont = 25;
        imageW = 40;
        marginY = 60;
        labelW = 100;
    }
    for(int i=0;i<arrayTime.count;i++){
        CGFloat x = 10+margin*i;
        UIImageView *image = [[UIImageView alloc]initWithFrame:BQAdaptationFrame(x, self.zlHeight / 2.0 - imageW/2.0, imageW, imageW)];
        if(i==0){
            image.image = [UIImage imageNamed:@"选中点"];
        }else{
            image.image = [UIImage imageNamed:@"未选中点"];
        }
        [self addSubview:image];
        [self.arrayImage addObject:image];
        if(i>0){
            //添加时间
            UILabel *label = [[UILabel alloc]initWithFrame:BQAdaptationFrame(0, 0, labelW, 30)];
            label.center = CGPointMake(image.center.x, image.center.y - marginY*BQAdaptationWidth());
            label.text = arrayTime[i];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:labeFont*BQAdaptationWidth()];
            [self addSubview:label];
        }else{
            UILabel *label = [[UILabel alloc]initWithFrame:BQAdaptationFrame(0, 0, labelW, 30)];
            label.center = CGPointMake(image.center.x+10*BQAdaptationWidth(), image.center.y + marginY*BQAdaptationWidth());
            label.text = @"30分钟";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:labeFont*BQAdaptationWidth()];
            
            [self addSubview:label];
        }
    }
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //获取点击事件
    UITouch *touch = [touches anyObject];
    //获取点击坐标
    CGPoint point = [touch locationInView:self];
    CGFloat width = self.zlWidth+200;//移动线条的宽度
    CGRect frame = self.lineVeiw.frame;
//    frame.origin.x = (-self.zlWidth + point.x*1.5)*BQAdaptationWidth();
    frame.origin.x = -(width * BQAdaptationWidth()) + point.x+10*BQAdaptationWidth();
    self.lineVeiw.frame = frame;
    [self arrarSetImage:point.x];
}
- (void) arrarSetImage:(CGFloat) x{
//    CGFloat margin = (self.zlWidth - 55) / 4.0;
    [self.arrayImage enumerateObjectsUsingBlock:^(UIImageView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(x >= obj.frame.origin.x){
            obj.image = [UIImage imageNamed:@"选中点"];
        }else{
            if(idx > 0){
                obj.image = [UIImage imageNamed:@"未选中点"];
            }
        }
    }];
}
#pragma mark -- Delegate
#pragma mark -- Getter
- (NSMutableArray *)arrayImage{
    if(!_arrayImage){
        _arrayImage = [NSMutableArray array];
    }
    return _arrayImage;
}
- (UIView *)lineBackView{
    if(!_lineBackView){
        _lineBackView = [[UIView alloc]initWithFrame:BQAdaptationFrame(0, self.zlHeight / 2.0 - 10, self.zlWidth, 20)];
        _lineBackView.backgroundColor = MY_COLOR(216, 214, 214, 1.0);
        _lineBackView.layer.cornerRadius = 10*BQAdaptationWidth();
    }
    return _lineBackView;
}
-  (UIView *)lineVeiw{
    if(!_lineVeiw){
        CGFloat width = self.zlWidth+200;
        _lineVeiw = [[UIView alloc]initWithFrame:BQAdaptationFrame(-width, self.lineBackView.zlMinY, width, 20)];
        _lineVeiw.backgroundColor = MY_COLOR(203, 171, 247, 1.0);
        _lineVeiw.layer.cornerRadius = 10*BQAdaptationWidth();
    }
    return _lineVeiw;
}
@end
