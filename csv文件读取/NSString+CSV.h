//
//  NSString+CSV.h
//  CSV_TEST
//
//  Created by fengei on 17/1/8.
//  Copyright © 2017年 fengei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CSV)

//NSString *path = [[NSBundle mainBundle] pathForResource:
//                  @"cn" ofType:@"csv"];
//NSLog(@"到手的数据 = %@",[path getCSCWithIndex:4]);

- (NSArray *) getCSCWithIndex:(NSInteger) num;
@end
