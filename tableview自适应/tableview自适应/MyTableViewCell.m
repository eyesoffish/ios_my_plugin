//
//  MyTableViewCell.m
//  tableview自适应
//
//  Created by fengei on 16/8/19.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setup];
    }
    return self;
}
- (void) setup
{
    _name = [[UILabel alloc]initWithFrame:CGRectMake(71, 5, CGRectGetWidth(self.frame), 40)];
    [self addSubview:_name];
    _userImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 66, 66)];
    [self addSubview:_userImage];
    _desc = [[UILabel alloc]initWithFrame:CGRectMake(5, 75, CGRectGetWidth(self.frame), 40)];
    [self addSubview:_desc];
}
//添加完空间之后设置cell的高度
- (void)setIntroductionTest:(NSString *)text
{
    CGRect frame = self.frame;
    //文本赋值
    self.desc.text = text;
    // 设置最大行数
    self.desc.numberOfLines = 10;
    CGSize size = CGSizeMake(self.frame.size.width, 1000);
    CGSize fitSize = [self getLabelSizeWithString:text font:[UIFont systemFontOfSize:17] maxSize:size];
    self.desc.frame = CGRectMake(5, 75, fitSize.width, fitSize.height);
    //计算出自适应的高度
    frame.size.height = fitSize.height+100;
    self.frame = frame;
}
//算并且获得长度
- (CGSize) getLabelSizeWithString:(NSString *)string font:(UIFont *)font maxSize:(CGSize)maxSize
{
    //定义一个字典
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    dic[NSFontAttributeName] = font;
    //调用方法得到size,maxSize最大尺寸，string:要算得字符串，font:字体样式
    CGSize size = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size;
}
@end
