//
//  SearchTabelView.m
//  UBaby
//
//  Created by fengei on 16/11/22.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "SearchTabelView.h"

@interface SearchTabelView ()<UITableViewDataSource>

@end
@implementation SearchTabelView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if(self){
        [self setupUI];
    }
    return self;
}
#pragma mark -- Function
- (void) setupUI{
    self.dataSource = self;
    [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}
- (void)setArrayData:(NSArray *)arrayData{
    _arrayData = arrayData;
    [self reloadData];
}
#pragma mark -- Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.arrayData[indexPath.row];
    return cell;
}
#pragma mark -- Getter
@end
