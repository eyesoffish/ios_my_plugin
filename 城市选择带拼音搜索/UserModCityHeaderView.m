//
//  UserModCityHeaderView.m
//  UBaby
//
//  Created by fengei on 16/11/22.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "UserModCityHeaderView.h"
#import "BQScreenAdaptation.h"
#import "Tool.h"
#import "UIView+ZLFrame.h"
@interface UserModCityHeaderView ()

@property (nonatomic,strong) NSMutableArray *arrayBtn;
@property (nonatomic,strong) UILabel *labelCurrentCity;
@property (nonatomic,strong) UIView *backLabelView;//背景
@property (nonatomic,strong) UILabel *labelChoose;
@property (nonatomic,strong) UILabel *labelHot;//热门城市
@property (nonatomic,strong) NSMutableArray *arrayChoose;//最近选择的城市
@end
@implementation UserModCityHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
#pragma mark -- Function
- (void)setArrayHotCity:(NSArray *)arrayHotCity{
    _arrayHotCity = arrayHotCity;
    CGFloat margin = 20;
    CGFloat width = (IPHONE_WIDTH -margin*4 - 30) / 3.0;
    CGFloat height = 55;
    [_arrayHotCity enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat x = margin + (width+margin)*(idx % 3);
        CGFloat y = margin + 10 + idx/3*(30+height) + self.labelHot.zlMaxY;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = BQAdaptationFrame(x, y, width, height);
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:30*BQAdaptationWidth()];
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = (idx+1)*100;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.borderColor = MY_COLOR(212, 212, 212, 1.0).CGColor;
        btn.layer.borderWidth = 1.0;
        btn.layer.cornerRadius = 30*BQAdaptationWidth();
        [self addSubview:btn];
        [self.arrayBtn addObject:btn];
    }];
}
- (void) setupUI{
    [self addSubview:self.backLabelView];
    [self addSubview:self.labelCurrentCity];
    [self addSubview:self.labelChoose];
    [self addSubview:self.labelHot];
    NSArray *array = [self readFromFile];
    CGFloat margin = 20;
    CGFloat width = (IPHONE_WIDTH -margin*4 - 30) / 3.0;
    CGFloat height = 55;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat x = margin + (width+margin)*idx;
        CGFloat y = margin + self.labelChoose.zlMaxY;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = BQAdaptationFrame(x, y, width, height);
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:30*BQAdaptationWidth()];
        btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.borderColor = MY_COLOR(212, 212, 212, 1.0).CGColor;
        btn.layer.borderWidth = 1.0;
        btn.layer.cornerRadius = 30*BQAdaptationWidth();
        [self addSubview:btn];
        [self.arrayBtn addObject:btn];
    }];
}
- (void) btnClick:(UIButton *)sender{
    [self.arrayBtn enumerateObjectsUsingBlock:^(UIButton *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = [UIColor whiteColor];
    }];
    sender.backgroundColor = MainRedColor;
    [self writeToFile:sender.titleLabel.text];
}
- (void)setStringCity:(NSString *)stringCity{
    _stringCity = stringCity;
    [self writeToFile:stringCity];
}
- (void) writeToFile:(NSString *)title{
    [self.arrayChoose addObject:title];
    _stringCity = title;
    if([self.delegate respondsToSelector:@selector(modCityHeaderView:)]){
        [self.delegate modCityHeaderView:title];
    }
    self.labelCurrentCity.text = [NSString stringWithFormat:@"当前选择：%@",title];
    if(self.arrayChoose.count > 3){
        [self.arrayChoose removeObject:[self.arrayChoose firstObject]];
    }
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"ChooseCityData.data"];
    [NSKeyedArchiver archiveRootObject:self.arrayChoose toFile:file];
}
- (NSMutableArray *) readFromFile{
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"ChooseCityData.data"];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:file];
}
#pragma mark -- Delegate
#pragma mark -- Getter
- (UILabel *)labelHot{
    if(!_labelHot){
        _labelHot = [[UILabel alloc]initWithFrame:BQAdaptationFrame(20, self.labelChoose.zlMaxY+100, 200, 30)];
        _labelHot.font = [UIFont systemFontOfSize:25*BQAdaptationWidth()];
        _labelHot.textColor = [UIColor grayColor];
        _labelHot.text = @"热门城市";
    }
    return _labelHot;
}
- (NSMutableArray *)arrayChoose{
    if(!_arrayChoose){
        _arrayChoose = [NSMutableArray arrayWithCapacity:3];
    }
    return _arrayChoose;
}
- (UILabel *)labelChoose{
    if(!_labelChoose){
        _labelChoose = [[UILabel alloc]initWithFrame:BQAdaptationFrame(20, self.backLabelView.zlMaxY+30, 200, 30)];
        _labelChoose.font = [UIFont systemFontOfSize:25*BQAdaptationWidth()];
        _labelChoose.text = @"最近选择";
        _labelChoose.textColor = [UIColor grayColor];
    }
    return _labelChoose;
}
- (UIView *)backLabelView{
    if(!_backLabelView){
        _backLabelView = [[UIView alloc]initWithFrame:BQAdaptationFrame(-20, 20, IPHONE_WIDTH+20, 100)];
        _backLabelView.backgroundColor = [UIColor whiteColor];
        _backLabelView.layer.borderColor = MY_COLOR(212, 212, 212, 1.0).CGColor;
        _backLabelView.layer.borderWidth = 0.7;
    }
    return _backLabelView;
}
- (UILabel *)labelCurrentCity{
    if(!_labelCurrentCity){
        _labelCurrentCity = [[UILabel alloc]init];
        _labelCurrentCity.frame = BQAdaptationFrame(20, 55, IPHONE_WIDTH - 40, 30);
        _labelCurrentCity.text = @"当前选择:";
        _labelCurrentCity.font = [UIFont systemFontOfSize:35*BQAdaptationWidth()];
    }
    return _labelCurrentCity;
}
- (NSMutableArray *)arrayBtn{
    if(!_arrayBtn){
        _arrayBtn = [NSMutableArray array];
    }
    return _arrayBtn;
}
@end
