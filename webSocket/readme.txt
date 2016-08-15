please import some lib,oh i`m forget it sorry!!,by search i find lib named  libicucore.dylib


//开始录音
    [RecordPlugins startRecord];
//停止录音
    [RecordPlugins stopRecord];
//播放当前录音
    [RecordPlugins playAudioFile];
//根据路径停止播放录音
    NSString *path = [RecordPlugins getAllAudioFile][0];
    [RecordPlugins stopRecord:path];
//获取录音文件路径
    NSLog(@"list = %@",[RecordPlugins getAllAudioFile]);
//清理录音
    [RecordPlugins clearAllAudioFile];
//链接播放AMR文件
    [RecordPlugins playAudioURL:@"http://www.baidu.com/record.amr"];

//上传文件
    NSString *path = [[NSBundle mainBundle] pathForResource:@"upload" ofType:@"png"];
    //上传进度回调
    [RecordPlugins shareRecordPlugin].uploadProgress = ^(CGFloat tag){
        NSLog(@"上传进度 ＝ %f",tag);
    };
    [RecordPlugins uploadFile:path url:@"http://www.baidu.com"];

//下载进度回调
    [RecordPlugins shareRecordPlugin].downloadProgress = ^(CGFloat tag){
        NSLog(@"下载进度 ＝ %f",tag);
    };
    //下载完成回调
    [RecordPlugins shareRecordPlugin].downloadFinish = ^(NSData *data){
        NSLog(@"下载数据完成 ＝ %@",data);
    };
    //下载文件
    [RecordPlugins downloadFile:@"http://www.baidu.com"];

[RecordPlugins downloadImageWithURL:@"http://www.baidu.com" finish:^(UIImage *image) {
        NSLog(@"下载图片完成 ＝ %@",image);
}];