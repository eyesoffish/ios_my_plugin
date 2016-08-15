//
//  HomeLiveController.h
//  BeautifulSow
//
//  Created by dandan on 16/4/11.
//  Copyright © 2016年 Mars. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "SRWebSocket.h"

@class webSocketSingle;

@protocol webSocketSingleDelegate <NSObject>
//数据传输
- (void)webSocketDataDict:(NSDictionary *)dict;

@end

@interface webSocketSingle : NSObject<SRWebSocketDelegate>

//懒加载
+ (webSocketSingle *)shareInstance;


@property (nonatomic,strong)SRWebSocket *webSocket;

/**
 *  打开
 */
-(void)connectwebSocket;

//发送数据
-(void)fasongshuju:(NSString*)str;

//关闭
- (void)close;

@property (nonatomic, weak) id<webSocketSingleDelegate> delegate;


@end
