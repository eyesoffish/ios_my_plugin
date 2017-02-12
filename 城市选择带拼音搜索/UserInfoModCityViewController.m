//
//  UserInfoModCityViewController.m
//  UBaby
//
//  Created by fengei on 16/11/21.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "UserInfoModCityViewController.h"
#import "Tool.h"
#import "BQScreenAdaptation.h"
#import "UserModCityHeaderView.h"
#import "TextView.h"
#import "ChineseToPinyin.h"
#import "SearchTabelView.h"
#import "URLRequest+UserInfoManager.h"
@interface UserInfoModCityViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UserModCityHeaderViewDelegate>

@property (nonatomic,strong) UITableView *tableView;//个人资料
@property (nonatomic,strong) NSArray *arrayHotCity;//城市
@property (nonatomic,strong) NSArray *arrayEnglish;//
@property (nonatomic,strong) NSMutableDictionary *dicCity;
@property (nonatomic,strong) UserModCityHeaderView *headView;

//搜索
@property (nonatomic,strong) UIButton *btnSearch;//搜索按钮
@property (nonatomic,strong) TextView *txtSearch;//搜索框
@property (nonatomic,strong) NSMutableArray *arraySearch;//搜索过后的数据
@property (nonatomic,strong) NSMutableArray *arrayAllCitys;//所有城市
@property (nonatomic,strong) SearchTabelView *searchTabelView;//搜索列表
@end

@implementation UserInfoModCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
#pragma mark -- Function
- (void) setupUI{
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:self.txtSearch];
    self.navigationItem.rightBarButtonItem = barItem;
}
- (void)setCity:(NSString *)city{
    _city = city;
    _stringCity = city;
}
- (void)setStringCity:(NSString *)stringCity{
    _stringCity = stringCity;
    self.headView.stringCity = stringCity;
}
//读取城市文件
-(NSMutableDictionary *)readCSVData{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"cities"
                                                   ofType:@"plist"];
    return [NSMutableDictionary dictionaryWithContentsOfFile:path];
}
- (void) btnSearchClick{
    //点击搜索按钮
    [self.txtSearch resignFirstResponder];
    self.txtSearch.text = @"";
    [self.searchTabelView removeFromSuperview];
}
- (void) txtSearchInput:(TextView *)sender{
    [self.arraySearch removeAllObjects];
    [self.arrayAllCitys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([[ChineseToPinyin pinyinFromChiniseString:obj] hasPrefix:[sender.text uppercaseString]] || [obj hasPrefix:sender.text]){
            [self.arraySearch addObject:obj];
        }
    }];
    self.searchTabelView.arrayData = self.arraySearch;
}
//修改城市代理回调
- (void) rightBarItemClick{
    self.userInfoManger.userCity = self.headView.stringCity;
    if(self.modCallback){
        self.modCallback();
    }
    [URLRequest managerModUserID:self.userInfoManger.userID param:@{@"city":self.userInfoManger.userCity} finish:^(id response, NSError *error) {
        NSLog(@"city = %@",response[@"data"][@"city"]);
    }];
}

#pragma mark -- Delegate
- (void)modCityHeaderView:(NSString *)city{
    [self rightBarItemClick];
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self.view addSubview:self.searchTabelView];
    return YES;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50*BQAdaptationWidth();
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arrayEnglish.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = [self.dicCity objectForKey:self.arrayEnglish[section]];
    return array.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.arrayEnglish[section];
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSArray *array = [self.dicCity objectForKey:self.arrayEnglish[indexPath.section]];
    cell.textLabel.text = array[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.arrayEnglish;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.headView.stringCity = cell.textLabel.text;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self resignFirstResponder];
    [self btnSearchClick];
    return YES;
}
#pragma mark -- Getter
- (SearchTabelView *)searchTabelView{
    if(!_searchTabelView){
        _searchTabelView = [[SearchTabelView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH * BQAdaptationWidth(), IPHONE_HEIGHT *BQAdaptationWidth()) style:UITableViewStylePlain];
        _searchTabelView.backgroundColor = [UIColor whiteColor];
        _searchTabelView.delegate = self;
    }
    return _searchTabelView;
}
- (NSMutableArray *)arrayAllCitys{
    if(!_arrayAllCitys){
        _arrayAllCitys = [NSMutableArray array];
        NSArray *allKes = [self.dicCity allKeys];
        [allKes enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_arrayAllCitys addObjectsFromArray:[self.dicCity valueForKey:obj]];
        }];
    }
    return _arrayAllCitys;
}
- (NSMutableArray *)arraySearch{
    if(!_arraySearch){
        _arraySearch  = [NSMutableArray array];
    }
    return _arraySearch;
}
- (TextView *)txtSearch{
    if(!_txtSearch){
        _txtSearch = [[TextView alloc]init];
        _txtSearch.frame = BQAdaptationFrame(0, 0, IPHONE_WIDTH - 135, 55);
        _txtSearch.backgroundColor = [UIColor whiteColor];
        _txtSearch.leftView = self.btnSearch;
        _txtSearch.leftViewMode = UITextFieldViewModeAlways;
        _txtSearch.clearButtonMode = UITextFieldViewModeWhileEditing;
        _txtSearch.tintColor = [UIColor blackColor];
        _txtSearch.delegate = self;
        _txtSearch.layer.cornerRadius = 28*BQAdaptationWidth();
        _txtSearch.layer.borderColor = [UIColor orangeColor].CGColor;
        _txtSearch.layer.borderWidth = 1.0;
        _txtSearch.textColor = [UIColor blackColor];
        _txtSearch.font = [UIFont systemFontOfSize:25*BQAdaptationWidth()];
        _txtSearch.returnKeyType = UIReturnKeySearch;//设置按键类型
        _txtSearch.enablesReturnKeyAutomatically = NO;//设置为无文字就灰色不可以点击
        _txtSearch.placeholder = @"请输入城市名或拼音查询";
        [_txtSearch addTarget:self action:@selector(txtSearchInput:) forControlEvents:UIControlEventEditingChanged];
    }
    return _txtSearch;
}
- (UIButton *)btnSearch{
    if(!_btnSearch){
        _btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnSearch setImage:[UIImage imageNamed:@"搜索图标"] forState:UIControlStateNormal];
        _btnSearch.frame = BQAdaptationFrame(10, 0, 50, 35);
        [_btnSearch addTarget:self action:@selector(btnSearchClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSearch;
}
- (UserModCityHeaderView *)headView{
    if(!_headView){
        _headView = [[UserModCityHeaderView alloc]initWithFrame:BQAdaptationFrame(0, 0, 0, 750)];
        _headView.backgroundColor = MY_COLOR(238, 238, 238, 1.0);
        _headView.arrayHotCity = self.arrayHotCity;
        _headView.delegate = self;
    }
    return _headView;
}
- (NSArray *)arrayHotCity{
    if(!_arrayHotCity){
        _arrayHotCity = @[@"北京",@"上海",@"广州",@"深圳",@"香港",@"澳门",@"武汉",@"南京",@"西安",@"郑州",@"成都",@"天津",@"苏州",@"重庆"];
    }
    return _arrayHotCity;
    
}
- (NSMutableDictionary *)dicCity{
    if(!_dicCity){
        _dicCity = [self readCSVData];
    }
    return _dicCity;
}
- (NSArray *)arrayEnglish{
    if(!_arrayEnglish){
        NSString *string = @"A B C D E F G H I J K L M N O P Q R S T U V W X Y Z";
        _arrayEnglish = [string componentsSeparatedByString:@" "];
    }
    return _arrayEnglish;
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.tableHeaderView = self.headView;
        _tableView.sectionFooterHeight = 1.0;
        _tableView.bounces = NO;
        _tableView.sectionIndexColor = [UIColor blackColor];
    }
    return _tableView;
}
@end
