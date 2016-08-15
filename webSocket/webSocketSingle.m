//
//  HomeLiveController.h
//  BeautifulSow
//
//  Created by dandan on 16/4/11.
//  Copyright © 2016年 Mars. All rights reserved.
//


#import "webSocketSingle.h"

#define Socket_HOST @"114.215.96.14"
#define Socket_PORT @"7272"
static webSocketSingle *_webSocketSingle = nil;

@interface webSocketSingle()

@property (nonatomic,copy)NSString *messageStr;

@end


@implementation webSocketSingle

+(webSocketSingle *)shareInstance{
    if (_webSocketSingle ==nil) {
        _webSocketSingle =[[webSocketSingle alloc]init];
    }
    
    return _webSocketSingle;
}

-(void)connectwebSocket{
    
    
    self.webSocket.delegate = nil;
    
    [self.webSocket close];
    
    self.webSocket =[[SRWebSocket alloc]initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"ws://%@:%@",Socket_HOST,Socket_PORT]]]];
    self.webSocket.delegate =self;
    
    [self.webSocket open];
    
    NSLog(@"打开成功");
    
}

//-(NSString *)sendMessage{
//    
//    NSDictionary *dic=@{@"_method_":@"login",
//                        @"levelid":@"0",
//                        @"room_id":@"1285804764",
//                        @"token":@"4ec34e5fea7eb7869924e406196f71fc",
//                        @"ucuid":@"1055",
//                        @"user_id":@"1109",
//                        @"user_name":@"18349352844",
//                        };
//    
//    
//    NSData *jsonData =[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
//    
//    NSString *str =[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
//    
//    
//    return str;
//}

-(void)fasongshuju:(NSString *)str{
//    NSLog(@"str%@",str);
    
    [self.webSocket send:str];
    
}

/**
 *  关闭
 */
- (void)close{
    
    [self.webSocket close];
}

#pragma mark -=====websocket代理=====
//-(void)webSocketDidOpen:(SRWebSocket *)webSocket{
//
//      NSLog(@"websocket Connected");
//    
//    [webSocket send:self];
//
//}

-(void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    self.messageStr = message;
//    NSLog(@"=====%@",message);
    NSData *messageData =[message dataUsingEncoding:NSUTF8StringEncoding];
        id dic =[NSJSONSerialization JSONObjectWithData:messageData options:NSJSONReadingMutableContainers error:nil];
    //

    [self messageStuats:dic];

    
}

-(void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    NSLog(@"websocket Failed 错误： %@",error);
    
    self.webSocket =nil;


}

-(void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    
    NSLog(@"%@",reason);
    self.webSocket =nil;
}


-(void)messageStuats:(NSDictionary *)dict{
    
//    NSLog(@"%@",dict);
    if ([self.delegate respondsToSelector:@selector(webSocketDataDict:)]) {
        [self.delegate webSocketDataDict:dict];
    }}


//-(void)messageStuats{
//    
//    
//    if ([self.messageStr isEqualToString:@"ack"]) {
//        return;
//    }
//    
//    NSLog(@"%@",[self.messageStr class]);
//    
//    NSLog(@"%@",self.messageStr);
//    //将字符串类型的数据转为NSdata类型
//    NSData *messageData =[self.messageStr dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSLog(@"%@",[messageData class]);
//    //将NSData类型数据转为字典
//    id dic =[NSJSONSerialization JSONObjectWithData:messageData options:NSJSONReadingMutableContainers error:nil];
//    
//    NSLog(@"%@",dic);
//    if ([dic[@"action"] isEqualToString:@"login"]) {
//        NSLog(@"登陆成功");
//
//
//}


@end
