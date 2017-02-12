//
//  UserLevelEXPTabelView.m
//  UBaby
//
//  Created by fengei on 16/11/28.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "UserLevelEXPTabelView.h"
#import "BQScreenAdaptation.h"
#import "Tool.h"
@implementation UserLevelEXPTabelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
#pragma mark -- Function
- (void) setupUI{
    
}
- (void) setTableWithRowHeight:(CGFloat) rowHeight coumn:(NSInteger) column row:(NSInteger) row dataArray:(NSArray *)array{
    //画横线
    for(NSInteger i=0;i<row+2;i++){
        UIView *line = [[UIView alloc]initWithFrame:BQAdaptationFrame(0, i*rowHeight, IPHONE_WIDTH-40, 1.0)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
    }
    //画竖线
    CGFloat margin = (IPHONE_WIDTH-40.0) / column;
    CGFloat height = rowHeight * (row+1);
    for(NSInteger i=0;i<column+1;i++){
        UIView *line = [[UIView alloc]initWithFrame:BQAdaptationFrame(i*margin, 0, 1.0, height)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
    }
    //添加label
    [array enumerateObjectsUsingBlock:^(NSArray *  _Nonnull obj, NSUInteger idx1, BOOL * _Nonnull stop) {
        [obj enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop) {
            UILabel *label = [[UILabel alloc]initWithFrame:BQAdaptationFrame(idx1*margin, idx2*rowHeight, margin, rowHeight)];
            label.text = obj2;
            label.font = [UIFont systemFontOfSize:28*BQAdaptationWidth()];
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
        }];
    }];
}
#pragma mark -- Delegate
#pragma mark -- Getter
@end
