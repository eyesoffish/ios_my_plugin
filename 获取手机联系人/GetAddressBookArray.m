//
//  GetAddressBookArray.m
//  AddressBookDemo
//
//  Created by bolo-mac mini2 on 2017/6/1.
//  Copyright © 2017年 bolo-mac mini2. All rights reserved.
//

#import "GetAddressBookArray.h"
#import <Contacts/CNContact.h>
#import <ContactsUI/ContactsUI.h>

@implementation GetAddressBookArray

+ (NSDictionary *)getPhoneAddressBookArray {
    // 获取联系人
    // 创建联系人仓库
    
    CNContactStore *store = [[CNContactStore alloc] init];
    
    // 创建联系人的请求对象
    // keys决定这次要获取哪些信息,比如姓名/电话
    NSArray *fetchKeys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:fetchKeys];
    
    // 请求联系人
    NSError *error = nil;

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [store enumerateContactsWithFetchRequest:request error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        // stop是决定是否要停止
        // 1.获取姓名
        NSString *firstname = contact.givenName;
        NSString *lastname = contact.familyName;
        //        NSLog(@"%@ %@",lastname, firstname);
        
        // 2.获取电话号码
        NSArray *phones = contact.phoneNumbers;
        
        // 3.遍历电话号码
        for (CNLabeledValue *labelValue in phones) {
            CNPhoneNumber *phoneNumber = labelValue.value;
            if (phoneNumber.stringValue.length >= 11 && [labelValue.label isEqualToString:@"_$!<Mobile>!$_"]) {
                NSString *name = [NSString stringWithFormat:@"%@%@",lastname,firstname];
                NSString *phoneNum = [phoneNumber.stringValue stringByReplacingOccurrencesOfString:@"+86" withString:@""];
                phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
                [dict setObject:name forKey:phoneNum];
            }
        }
    }];
    return [dict copy];
}

@end
