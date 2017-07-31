//
//  NSString+CheckString.h
//  UBaby
//
//  Created by fengei on 16/12/27.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaceAlertTool.h"
@interface NSString (CheckString)

//验证是否是电话号码
- (BOOL) isPhoneNum;
//身份证号码验证
- (BOOL)isUserIDCard;
//是否是表情
+ (BOOL)stringContainsEmoji:(NSString *)string;
//是否是网址
- (BOOL) isHttpWeb;

/** 获取汉子首字母*/
- (NSString *)getEnglishNum;
/**
 检查字符串是否为空，并给默认值
 **/
+ (NSString *) checkISNULL:(NSString *)string;
//**检查，并不给默认值*/
+ (NSString *)checkString:(NSString *)string;
/** 账户是否过于太长 */
- (NSString *)stringIsToLong:(NSInteger)num;

/** 判断游戏类型 */
+ (NSString *) getGame_type:(NSInteger) type;
@end
