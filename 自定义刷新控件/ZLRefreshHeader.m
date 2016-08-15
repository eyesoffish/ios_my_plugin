//
//  ZLRefreshHeader.m
//  iosSelfTableView
//
//  Created by fengei on 16/8/1.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "ZLRefreshHeader.h"
#import "UIView+ZLRefresh.h"
const CGFloat ZLRefreshHeaderHeight = 35.0;
const CGFloat ZLRefreshPointRadius = 5.0;

const CGFloat ZLRefreshPullen = 55.0;
const CGFloat ZLRefreshTranslatlen = 5.0;
#define topPointColor    [UIColor colorWithRed:90 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1.0].CGColor
#define leftPointColor   [UIColor colorWithRed:250 / 255.0 green:85 / 255.0 blue:78 / 255.0 alpha:1.0].CGColor
#define bottomPointColor [UIColor colorWithRed:92 / 255.0 green:201 / 255.0 blue:105 / 255.0 alpha:1.0].CGColor
#define rightPointColor  [UIColor colorWithRed:253 / 255.0 green:175 / 255.0 blue:75 / 255.0 alpha:1.0].CGColor

@interface ZLRefreshHeader ()

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) CAShapeLayer *lineLayer;
@property (nonatomic,strong) CAShapeLayer *topPointLayer;
@property (nonatomic,strong) CAShapeLayer *bottomPointLayer;
@property (nonatomic,strong) CAShapeLayer *leftPointLayer;
@property (nonatomic,strong) CAShapeLayer *rightPointLayer;

@property (nonatomic,assign) CGFloat progress;
@property (nonatomic,assign) BOOL animation;
@end
@implementation ZLRefreshHeader

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, ZLRefreshHeaderHeight, ZLRefreshHeaderHeight)];
    if (self) {
        [self initLayers];
    }
    return self;
}

- (void) initLayers
{
    CGFloat centerLine = ZLRefreshHeaderHeight / 2;
    CGFloat radius = ZLRefreshPointRadius;
    
    CGPoint topPoint = CGPointMake(centerLine, radius);
    self.topPointLayer = [self layerWithPoint:topPoint color:topPointColor];
    self.topPointLayer.hidden = NO;
    self.topPointLayer.opacity = 0.f;
    [self.layer addSublayer:self.topPointLayer];
    
    CGPoint leftPoint = CGPointMake(radius, centerLine);
    self.leftPointLayer = [self layerWithPoint:leftPoint color:leftPointColor];
    [self.layer addSublayer:self.leftPointLayer];
    
    CGPoint bottomPoint = CGPointMake(centerLine, ZLRefreshHeaderHeight-radius);
    self.bottomPointLayer = [self layerWithPoint:bottomPoint color:bottomPointColor];
    [self.layer addSublayer:self.bottomPointLayer];
    
    CGPoint rightPoint = CGPointMake(ZLRefreshHeaderHeight-radius, centerLine);
    self.rightPointLayer = [self layerWithPoint:rightPoint color:rightPointColor];
    [self.layer addSublayer:self.rightPointLayer];
    
    self.lineLayer = [CAShapeLayer layer];
    self.lineLayer.frame = self.bounds;
    self.lineLayer.lineWidth = ZLRefreshPointRadius * 2;
    self.lineLayer.lineCap = kCALineCapRound;
    self.lineLayer.lineJoin = kCALineJoinRound;
    self.lineLayer.fillColor = topPointColor;
    self.lineLayer.strokeColor = topPointColor;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:topPoint];
    [path addLineToPoint:leftPoint];
    [path moveToPoint:leftPoint];
    [path addLineToPoint:bottomPoint];
    [path moveToPoint:bottomPoint];
    [path addLineToPoint:rightPoint];
    [path moveToPoint:rightPoint];
    [path addLineToPoint:topPoint];
    self.lineLayer.path = path.CGPath;
    self.lineLayer.strokeStart = 0.f;
    self.lineLayer.strokeEnd = 0.f;
    [self.layer insertSublayer:self.lineLayer above:self.topPointLayer];
}
- (CAShapeLayer *) layerWithPoint:(CGPoint) center color:(CGColorRef)color
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = CGRectMake(center.x - ZLRefreshPointRadius, center.y - ZLRefreshPointRadius, ZLRefreshPointRadius*2, ZLRefreshPointRadius*2);
    layer.fillColor = color;
    layer.hidden = YES;
    layer.path = [self pointPath];
    return layer;
}
- (CGPathRef) pointPath
{
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(ZLRefreshPointRadius, ZLRefreshPointRadius) radius:ZLRefreshPointRadius startAngle:0 endAngle:M_PI*2 clockwise:YES].CGPath;
}
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if(newSuperview)
    {
        self.scrollView = (UIScrollView *)newSuperview;
        self.center = CGPointMake(self.scrollView.centerX, self.scrollView.centerY);
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    else
    {
        [self.superview removeObserver:self forKeyPath:@"contentOffset"];
    }
}
#pragma mark --kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"contentOffset"])
    {
        self.progress = - self.scrollView.contentOffset.y;
    }
}

#pragma mark -- property
- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    if(!self.animation)
    {
        if(progress >= ZLRefreshPullen)
        {
            self.y = - (ZLRefreshPullen - (ZLRefreshPullen - ZLRefreshHeaderHeight) / 2);
        }
        else
        {
            if(progress <= self.h)
            {
                self.y = -progress;
            }
            else
            {
                self.y = - (self.h + (progress - self.h) / 2);
            }
        }
        [self setLineLayerStrokeWithProgress:progress];
    }
    //如果到达临界点，则执行刷新动画
    if(progress >= ZLRefreshPullen && !self.animation)
    {
        [self startAnimate];
        if(self.handle)
        {
            self.handle();
        }
    }
}
- (void) setLineLayerStrokeWithProgress:(CGFloat) progress
{
    float startProgress = 0.f;
    float endProgress = 0.f;
    
    //隐藏
    if(progress < 0)
    {
        self.topPointLayer.opacity = 0.f;
        [self adjustPointStateWithIndex:0];
    }
    else if(progress >= 0 && progress < (ZLRefreshPullen - 40))
    {
        self.topPointLayer.opacity = progress / 20;
        [self adjustPointStateWithIndex:0];
    }
    else if(progress >=(ZLRefreshPullen - 40) && progress<ZLRefreshPullen)
    {
        self.topPointLayer.opacity = 1.0;
        // 大阶段0～3
        NSInteger stage = (progress - (ZLRefreshPullen - 40)) / 10;
        CGFloat subProgress = (progress - (ZLRefreshPullen - 40))-(stage * 10);
        //大阶段的前半段
        if(subProgress >= 0 && subProgress <= 5)
        {
            [self adjustPointStateWithIndex:stage * 2];
            startProgress = stage / 4.0;
            endProgress = stage / 4.0 + subProgress / 40.0 * 2;
        }
        //大阶段后半段
        if(subProgress > 5 && subProgress < 10)
        {
            [self adjustPointStateWithIndex:stage * 2 + 1];
            startProgress = stage / 4.0 + (subProgress - 5) / 40.0 * 2;
            if(startProgress < (stage + 1)/4.0 - 0.1)
            {
                startProgress = (stage + 1) / 4.0 -0.1;
            }
            endProgress = (stage +1) / 4.0;
        }
    }
    else
    {
        self.topPointLayer.opacity = 1.0;
        [self adjustPointStateWithIndex:NSIntegerMax];
        startProgress = 1.0;
        endProgress = 1.0;
    }
    self.lineLayer.strokeStart = startProgress;
    self.lineLayer.strokeEnd = endProgress;
}
- (void) adjustPointStateWithIndex:(NSInteger) index//index：小阶段0～7
{
    self.leftPointLayer.hidden = index > 1 ? NO:YES;
    self.bottomPointLayer.hidden = index > 3 ? NO:YES;
    self.rightPointLayer.hidden = index > 5 ? NO:YES;
    self.lineLayer.strokeColor = index > 5 ? rightPointColor:index > 3 ? bottomPointColor : index > 1 ? leftPointColor:topPointColor;
}
- (void) startAnimate
{
    self.animation = YES;
    [UIView animateWithDuration:0.5 animations:^{
        UIEdgeInsets inset = self.scrollView.contentInset;
        inset.top = ZLRefreshPullen;
        self.scrollView.contentInset = inset;
    }];
    [self addTranslationAniToLayer:self.topPointLayer xValue:0 yValue:ZLRefreshTranslatlen];
    [self addTranslationAniToLayer:self.leftPointLayer xValue:ZLRefreshTranslatlen yValue:0];
    [self addTranslationAniToLayer:self.bottomPointLayer xValue:0 yValue:-ZLRefreshTranslatlen];
    [self addTranslationAniToLayer:self.rightPointLayer xValue:-ZLRefreshTranslatlen yValue:0];
    [self addRotationAniTolayer:self.layer];
}
- (void) addTranslationAniToLayer:(CALayer *) layer xValue:(CGFloat) x yValue:(CGFloat) y
{
    CAKeyframeAnimation *translationKey = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    translationKey.duration = 1.0;
    translationKey.repeatCount = HUGE;
    translationKey.removedOnCompletion = NO;
    translationKey.fillMode = kCAFillModeForwards;
    translationKey.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    NSValue *fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)];
    NSValue *toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(x, y, 0)];
    translationKey.values = @[fromValue,toValue,fromValue,toValue,fromValue];
    [layer addAnimation:translationKey forKey:@"translationKeyFrameAni"];
    
}
- (void) addRotationAniTolayer:(CALayer *)layer
{
    CABasicAnimation *rotationAni = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAni.fromValue = @(0);
    rotationAni.toValue = @(M_PI * 2);
    rotationAni.duration = 1.0;
    rotationAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotationAni.repeatCount = HUGE;
    rotationAni.fillMode = kCAFillModeForwards;
    rotationAni.removedOnCompletion = NO;
    [layer addAnimation:rotationAni forKey:@"rotationAni"];
}
- (void) removeAni
{
    [UIView animateWithDuration:0.5 animations:^{
        UIEdgeInsets inset = self.scrollView.contentInset;
        inset.top = 0.f;
        self.scrollView.contentInset = inset;
    }completion:^(BOOL finished) {
        [self.topPointLayer removeAllAnimations];
        [self.leftPointLayer removeAllAnimations];
        [self.bottomPointLayer removeAllAnimations];
        [self.rightPointLayer removeAllAnimations];
        [self.layer removeAllAnimations];
        [self adjustPointStateWithIndex:0];
        self.animation = NO;
    }];
}
- (void)endRefreshing
{
    [self removeAni];
}
@end
