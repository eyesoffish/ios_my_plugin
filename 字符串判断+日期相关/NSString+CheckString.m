//
//  NSString+CheckString.m
//  UBaby
//
//  Created by fengei on 16/12/27.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "NSString+CheckString.h"

@implementation NSString (CheckString)

//是否是电话号码
- (BOOL) isPhoneNum{
    NSString *checkTel=@"^1[3|4|5|8][0-9]\\d{8}$";//验证是否是电话号码
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", checkTel];
    return [emailTest evaluateWithObject:self];
}
//是否是网址
- (BOOL) isHttpWeb{
    NSString *checkTel=@"^1[3|4|5|8][0-9]\\d{8}$";//验证是否是电话号码
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", checkTel];
    return [emailTest evaluateWithObject:self];
}
- (BOOL)isUserIDCard{
    if (self.length != 18) return NO;
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:self]) return NO;
    
    //** 开始进行校验 *//
    
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex = [[self substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum+= subStrIndex * idCardWiIndex;
    }
    
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [self substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {
        if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }
    else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
}
//是否是表情
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}
//检查是否为并给默认值
+ (NSString *) checkISNULL:(NSString *)string{
    if([string isKindOfClass:[NSNull class]] || string == nil){
        return @"暂未设置";
    }else{
        return string;
    }
}
//检查并给空
+ (NSString *)checkString:(NSString *)string{
    if(string == nil || [string isKindOfClass:[NSNull class]]){
        return @"";
    }else{
        return [NSString stringWithFormat:@"%@",string];
    }
}

//账户是否过于太长
- (NSString *)stringIsToLong:(NSInteger)num{
    if(self.length > num){
        return [NSString stringWithFormat:@"%ld万",[self integerValue] / 10000];
    }else{
        return self;
    }
}


//判断游戏类型
+ (NSString *) getGame_type:(NSInteger) type{
    switch (type) {
        case 0:
            return @"吹牛";
            break;
        case 1:
            return @"德州";
            break;
        case 2:
            return @"梭哈";
            break;
        case 3:
            return @"牛牛";
            break;
        default:
            break;
    }
    return @"";
}


//获取汉字首字母
- (NSString *)getEnglishNum{
    NSMutableString *str = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef) str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pinYin = [str capitalizedString];
    return [pinYin substringToIndex:1];
}
@end
