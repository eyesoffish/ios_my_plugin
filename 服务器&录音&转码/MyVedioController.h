//
//  MyVedioController.h
//  MyVedio
//
//  Created by fengei on 16/6/8.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "VoiceConvert/VoiceConverter.h"
@interface MyVedioController : ViewController

+ (void) startAudio;//开始录音
+ (void) stopAudio;//停止录音
+ (void) listenVedio;//播放录音
+ (void) listenVedio:(NSString *) filePath;//根据路径播放
+ (void) listenData:(NSData *) data;
+ (NSMutableArray *) getAudioFileList;//获取录音路径列表

//-----------------socket--------------//
+ (void) startSocket;
+ (void) sendData;
@end
