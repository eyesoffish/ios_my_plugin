//
//  UserModel.h
//  AdaptiveCell
//
//  Created by swinglife on 14-1-10.
//  Copyright (c) 2014年 swinglife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

//用户名
@property (nonatomic,copy) NSString *username;
//介绍
@property (nonatomic,copy) NSString *introduction;
//头像图片路径
@property (nonatomic,copy) NSString *imagePath;

@end
