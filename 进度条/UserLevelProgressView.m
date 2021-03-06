//
//  UserLevelProgressView.m
//  UBaby
//
//  Created by fengei on 16/10/18.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "UserLevelProgressView.h"
#import "BQScreenAdaptation.h"
#import "Tool.h"
@interface UserLevelProgressView ()

@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@end
@implementation UserLevelProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.layer.masksToBounds = YES;
        [self addSubview:self.backView];
        [self addSubview:self.label];
        self.backgroundColor = MY_COLOR(244, 244, 244, 1.0);
    }
    return self;
}
- (void) setProgressWidth:(CGFloat) width height:(CGFloat) height{
    //设置自空间
    self.backView.frame = BQAdaptationFrame(-width, 0, width, height);
    self.label.bounds = BQAdaptationFrame(0, 0, width, height);
    self.label.center = BQadaptationCenter(CGPointMake(width/2, height/2));
    self.width = width;
    self.height = height;
}
- (void)setLabelTitle:(NSString *)labelTitle{
    _labelTitle = labelTitle;
    self.label.text = labelTitle;
}
- (UIView *)backView{
    if(!_backView){
        _backView = [[UIView alloc]initWithFrame:BQAdaptationFrame(-350, 0, 350, 20)];
        _backView.backgroundColor = MainRedColor;
    }
    return _backView;
}
- (UILabel *)label{
    if(!_label){
        _label = [[UILabel alloc]init];
        _label.bounds = BQAdaptationFrame(0, 0, 200, 20);
        _label.center = BQadaptationCenter(CGPointMake(350/2, 20/2));
        _label.text = @"1922/121345";
        _label.font = [UIFont systemFontOfSize:fontMid()];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}
- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    //设置进度条位置
    self.backView.frame = BQAdaptationFrame(-self.width, 0, self.width, self.height);
    CGRect frame = self.backView.frame;
    frame.origin.x = progress * frame.size.width + frame.origin.x;
    self.backView.frame = frame;
}
@end
