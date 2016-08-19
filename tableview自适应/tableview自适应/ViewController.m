//
//  ViewController.m
//  tableview自适应
//
//  Created by fengei on 16/8/15.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "ViewController.h"
#import "MyTableViewCell.h"
#import "UserModel.h"
@interface ViewController ()

@property (nonatomic,strong) NSMutableArray *array;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUserData];
    [self.tableView registerClass:[MyTableViewCell class] forCellReuseIdentifier:@"cell"];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableViewCell *cell = (MyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    UserModel *user = self.array[indexPath.row];
    cell.name.text = user.username;
    [cell.userImage setImage:[UIImage imageNamed:user.imagePath]];
    [cell setIntroductionTest:user.introduction];
    return cell;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableViewCell *cell = (MyTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
//我需要一点测试数据，直接复制老项目东西
-(void)createUserData{
    UserModel *user = [[UserModel alloc] init];
    [user setUsername:@"胖虎"];
    [user setIntroduction:@"我是胖虎我怕谁!!我是胖虎我怕谁!!我是胖虎我怕谁!!"];
    [user setImagePath:@"panghu.jpg"];
    UserModel *user2 = [[UserModel alloc] init];
    [user2 setUsername:@"多啦A梦"];
    [user2 setIntroduction:@"我是多啦A梦我有肚子!!我是多啦A梦我有肚子!!我是多啦A梦我有肚子!!我是多啦A梦我有肚子!!我是多啦A梦我有肚子!!我是多啦A梦我有肚子!!我是多啦A梦我有肚子!!我是多啦A梦我有肚子!!"];
    [user2 setImagePath:@"duolaameng.jpg"];
    UserModel *user3 = [[UserModel alloc] init];
    [user3 setUsername:@"大雄"];
    [user3 setIntroduction:@"我是大雄我谁都怕，我是大雄我谁都怕，我是大雄我谁都怕，我是大雄我谁都怕，我是大雄我谁都怕，我是大雄我谁都怕，"];
    [user3 setImagePath:@"daxiong.jpg"];
    
    
    [self.array addObject:user];
    [self.array addObject:user2];
    [self.array addObject:user3];
}
- (NSMutableArray *)array
{
    if(!_array)
    {
        _array = [NSMutableArray array];
    }
    return _array;
}
@end
