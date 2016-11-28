//
//  UserLevelEXPTabelView.h
//  UBaby
//
//  Created by fengei on 16/11/28.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserLevelEXPTabelView : UIView

/*
 使用说明：
 //设置数据
 NSArray *array = @[@[@"俱乐部等级",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"],@[@"游戏房间数量",@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"2"],@[@"管理员数量",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"]];
 //设置行高，列，行数（不包括头这一行），
 [_levelTabelView setTableWithRowHeight:70 coumn:3 row:8 dataArray:array];
 */
@property (nonatomic,strong) NSArray *arrayTitle;//标题头名称

- (void) setTableWithRowHeight:(CGFloat) rowHeight coumn:(NSInteger) column row:(NSInteger) row dataArray:(NSArray *)array;
@end
