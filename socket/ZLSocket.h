//
//  ZLSocket.h
//  ClientWebSocket
//
//  Created by fengei on 16/6/14.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ZLSocket : NSObject

+ (void) sendData:(NSData *) data;//发送数据
+ (void) sendFileUrl:(NSString *) url;//根据文件路径发送
+ (void) connectHost:(NSString *) host port:(NSInteger )port;//链接主机
@end
