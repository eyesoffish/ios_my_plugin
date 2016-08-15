//
//  MyVedioController.m
//  MyVedio
//
//  Created by fengei on 16/6/8.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "MyVedioController.h"
#import <GCDAsyncSocket.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

@interface MyVedioController ()<GCDAsyncSocketDelegate>

@property (nonatomic,strong) AVAudioRecorder *recoder;
@property (nonatomic,strong) NSString *filePath;//wav录音路径
@property (nonatomic,strong) NSString *fileSendPath;//发送录音路径
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;
@property (nonatomic,strong) GCDAsyncSocket *listenSocket;//主机
@property (nonatomic,strong) GCDAsyncSocket *clientSocket;//客户机
@property (nonnull,strong) NSMutableData *amrData;//录音总数据
@end
NSMutableArray *array;//录音列表
NSInteger countLenth=0;//记录socket传过来的录音总大小
@implementation MyVedioController

//////////////////////外部调用
+ (void) startAudio
{
    [[self sharedVedio] BeginAudio];//开始录音
}
+ (void) stopAudio
{
    [[self sharedVedio] stop];//停止录音
}
+ (void) listenVedio
{
    [[self sharedVedio] bofangAudio];//播放录音
}
+ (NSMutableArray *) getAudioFileList
{
    return [[self sharedVedio] listVedio];// 获取录音列表
}
+ (void) listenVedio:(NSString *) filePath
{
    [[self sharedVedio] MyBoFang:filePath];//获取路径播放
}
+ (MyVedioController *) sharedVedio
{
    
    static MyVedioController *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        array = [NSMutableArray array];
        instance = [[MyVedioController alloc]init];
    });
    return instance;
}
+ (void) startSocket
{
    [[self sharedVedio] socketServer];
}
+ (void) sendData
{
    [[self sharedVedio] sendDataAmr];
}
+ (void) listenData:(NSData *) data
{
    [[self sharedVedio] MyBoFangWithData:data];
}
/////////////////////////
- (void) BeginAudio
{
    [self mySetting];
    NSString *name = @"vedio.wav";
    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:name];
    NSURL *url = [NSURL fileURLWithPath:file];
    self.filePath = file;
    NSLog(@"=====%@",file);
//    NSMutableDictionary *settings = [NSMutableDictionary dictionary];//录音时所必需的参数设置m4a格式
//    [settings setValue:[NSNumber numberWithInteger:kAudioFormatAppleLossless] forKey:AVFormatIDKey];
//    [settings setValue:[NSNumber numberWithFloat:44100.0f] forKey:AVSampleRateKey];
//    [settings setValue:[NSNumber numberWithInteger:1] forKey:AVNumberOfChannelsKey];
//    [settings setValue:[NSNumber numberWithInteger:AVAudioQualityLow] forKey:AVEncoderAudioQualityKey];
    //创建录音配置字典wav格式
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    dic[AVFormatIDKey] = @(kAudioFormatLinearPCM);
//    dic[AVSampleRateKey] = @(8000.0);
//    dic[AVNumberOfChannelsKey] = @(1);
//    dic[AVLinearPCMBitDepthKey] = @(16);
    self.recoder = [[AVAudioRecorder alloc]initWithURL:url settings:[VoiceConverter GetAudioRecorderSettingDict] error:nil];
    self.recoder.meteringEnabled = YES;
    [self.recoder prepareToRecord];//准备录音
    [self.recoder record];//开始录音
}
- (void) stop
{
    [array addObject:self.filePath];
    if(self.recoder != nil)
    {
        [self.recoder stop];
        self.fileSendPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"vedio.amr"];
        int res =[VoiceConverter ConvertWavToAmr:self.filePath amrSavePath:self.fileSendPath];
        if(res==1)
        {
            NSLog(@"to amr success");
        }
        else
        {
            NSLog(@"to amr fail");
        }
    }
}
- (NSMutableArray *) listVedio
{
    return array;
}
- (void) bofangAudio
{
    [self MyBoFang:self.filePath];
}
- (void) MyBoFang:(NSString *) file
{
    if(file!=nil)
    {
        NSError *err;
        self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:file] error:&err];
        [self.audioPlayer prepareToPlay];
        if(err)
        {
            NSLog(@"error:%@",err);
        }
        else
        {
            [self.audioPlayer play];
        }
    }
}
- (void) MyBoFangWithData:(NSData *) data
{
    if(data!=nil)
    {
        NSError *err;
        self.audioPlayer = [[AVAudioPlayer alloc]initWithData:data error:&err];
        [self.audioPlayer prepareToPlay];
        if(err)
        {
            NSLog(@"error:%@",err);
        }
        else
        {
            [self.audioPlayer play];
        }
    }
}
//直接发送当前转换过后的amr录音文件
- (void) sendDataAmr
{
    if(self.fileSendPath != nil)
    {
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:self.fileSendPath]];
        [self.clientSocket writeData:data withTimeout:-1 tag:0];
        NSLog(@"发送数据%ld",[data length]);
    }
}
- (void) mySetting
{
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        //7.0第一次运行会提示，是否允许使用麦克风
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        //AVAudioSessionCategoryPlayAndRecord用于录音和播放
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        if(session == nil)
            NSLog(@"Error creating session: %@", [sessionError description]);
        else
            [session setActive:YES error:nil];
    }
}

#pragma  mark --socket
- (void) socketServer
{
    self.listenSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *err;
    if(![self.listenSocket acceptOnPort:5000 error:&err])
    {
        NSLog(@"error:%@",err);
    }
    NSLog(@"socket:开放成功 ip:%@ port:5000",[self getIPAddress]);
}
#pragma mark --delegate
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    countLenth = 0;
    self.amrData = [NSMutableData data];
    self.clientSocket = newSocket;
    NSLog(@"链接成功");
    NSLog(@"服务器地址:%@ 端口:%d",self.clientSocket.connectedHost,self.clientSocket.connectedPort);
    [self.clientSocket readDataWithTimeout:-1 tag:0];
    self.amrData = [NSMutableData data];
    
    
}
- (void) socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    if(countLenth == 0)
    {
        
        countLenth = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] integerValue];
    }
    else
    {
        [self.amrData appendData:data];
    }
    if(self.amrData.length < countLenth)
    {
        [self.clientSocket readDataWithTimeout:-1 tag:0];
    }
    if(countLenth == self.amrData.length)
    {
        NSString *saveAMRPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recieve.amr"];
        NSString *saveWAVPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recieve.wav"];
        [self.amrData writeToURL:[NSURL fileURLWithPath:saveAMRPath] atomically:YES];
        NSLog(@"路径：%@",saveAMRPath);
        int res = [VoiceConverter ConvertAmrToWav:saveAMRPath wavSavePath:saveWAVPath];
        NSLog(@"数据接受完成---->%ld",self.amrData.length);
        if(res==1)
        {
            NSLog(@"音频转换成功－－－－－－》路径：%@",saveWAVPath);
            [self MyBoFang:saveWAVPath];
            [array addObject:saveWAVPath];
        }
        else
        {
            NSLog(@"转换格式出错");
        }
        
    }
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"发送完毕");
}
- (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}
@end
