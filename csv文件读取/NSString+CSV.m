//
//  NSString+CSV.m
//  CSV_TEST
//
//  Created by fengei on 17/1/8.
//  Copyright © 2017年 fengei. All rights reserved.
//

#import "NSString+CSV.h"

@implementation NSString (CSV)

- (NSArray *) getCSCWithIndex:(NSInteger) num{
    NSMutableArray *array = [NSMutableArray array];
    NSError *error;
    NSString *string = [NSString stringWithContentsOfFile:self encoding:NSUTF8StringEncoding error:&error];
    NSArray *readArray = [string componentsSeparatedByString:@"\n"];
    if(error == nil){
        [readArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(idx > 0){
                NSArray *a = [obj componentsSeparatedByString:@","];
                [a enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj2, NSUInteger idx, BOOL * _Nonnull stop) {
                    if(idx == num && obj2 != nil){
                        [array addObject:obj2];
                    }
                }];
            }
        }];
    }else{
        NSLog(@"CSV文件读取出错---->%@",error);
    }
    return [array copy];
}
@end
