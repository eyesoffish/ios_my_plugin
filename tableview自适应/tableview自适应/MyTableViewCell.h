//
//  MyTableViewCell.h
//  tableview自适应
//
//  Created by fengei on 16/8/19.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *name;
@property (nonatomic,strong) UILabel *desc;
@property (nonatomic,strong) UIImageView *userImage;

//给用户介绍复制并且实现自动换行
- (void) setIntroductionTest:(NSString *)text;
@end
