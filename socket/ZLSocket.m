//
//  ZLSocket.m
//  ClientWebSocket
//
//  Created by fengei on 16/6/14.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "ZLSocket.h"
@interface ZLSocket()<NSStreamDelegate>
{
    NSOutputStream *_outputStream;
    NSInputStream *_inputStream;
}
@end
@implementation ZLSocket

+ (ZLSocket *) shareSocked
{
    static ZLSocket *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZLSocket alloc]init];
    });
    return instance;
}
+ (void) sendData:(NSData *) data
{
    //发送数据
    [[ZLSocket shareSocked] mySendData:data];
}
+ (void) sendFileUrl:(NSString *) url
{
    [[ZLSocket shareSocked] mySendFileUrl:url];
}
+ (void) connectHost:(NSString *) host port:(NSInteger )port
{
    //链接主机
    [[ZLSocket shareSocked] myConnectHost:host port:port];
}
- (void) myConnectHost:(NSString *)host port:(NSInteger ) port
{
    CFReadStreamRef readStream;//输入流
    CFWriteStreamRef writeStream;//输出流
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)host, (UInt32)port, &readStream, &writeStream);//有指针取地址
    //将c语言转换成oc的
    _outputStream = (__bridge NSOutputStream*)writeStream;
    _inputStream = (__bridge NSInputStream *)readStream;
    //设置代理
    _outputStream.delegate = self;
    _inputStream.delegate = self;
    //打开IO通道
    [_outputStream open];
    [_inputStream open];
    
    //将IO加入到消息循环池
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    NSLog(@"链接成功");
}
- (void) mySendData:(NSData *) data
{
    NSInteger code =[_outputStream write:data.bytes maxLength:data.length];
    NSLog(@"sendData return code:%ld",code);
}
- (void) mySendFileUrl:(NSString *) url
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:url]];
    [self mySendData:data];
}
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    switch (eventCode) {
        case NSStreamEventOpenCompleted://IO通道打开
            NSLog(@"IO通道打开");
            break;
        case NSStreamEventHasBytesAvailable://有字节可读
            NSLog(@"有字节可读");
            break;
        case NSStreamEventHasSpaceAvailable://可发送字节
            NSLog(@"可发送字节");
            break;
        case NSStreamEventErrorOccurred://未知错误
            NSLog(@"未知错误");
            break;
        case NSStreamEventEndEncountered://连接断开了
            NSLog(@"连接断开了");
            break;
        default:
            break;
    }
}
@end
