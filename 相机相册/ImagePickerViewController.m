//
//  ImagePickerViewController.m
//  MyVedio
//
//  Created by fengei on 16/6/12.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "ImagePickerViewController.h"
#import "BQScreenAdaptation.h"
#import "YFKit.h"
#import "Tool.h"
@import AVFoundation;
@import Photos;
@interface ImagePickerViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UIImagePickerController *picker;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) UIImageView *ImageCut;

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIView *darkView;
@property (nonatomic,strong) UIView *cancelView;
@property (nonatomic,strong) UIView *chooseView;


@property (nonatomic,strong) UIButton *btnCancel;

@property (nonatomic,strong) UIViewController *MyControl;

@property (nonatomic,strong) UIColor *btnColor;//按钮颜色
@end

@implementation ImagePickerViewController
//////////////////////////外部调用Begin
+ (void) alertView:(UIViewController *) control
{
    [[ImagePickerViewController shareImage] myAlertView:control];
}
//////////////////////////外部调用end
- (UIColor *)btnColor{
    if(!_btnColor){
        _btnColor = MainRedColor;
    }
    return _btnColor;
}


- (void) myAlertView:(UIViewController *) control
{
    [control.view addSubview:self.darkView];
    [self.contentView addSubview:self.chooseView];
    [self.contentView addSubview:self.cancelView];
    [self.contentView addSubview:self.btnCancel];
    [self.contentView addSubview:self.btnCamrea];
    [self.contentView addSubview:self.btnAlbum];
    UIView *line = [[UIView alloc]initWithFrame:BQAdaptationFrame(10, CGRectGetMaxY(self.chooseView.frame)/BQAdaptationWidth()-70, IPHONE_WIDTH-20, 1)];
    line.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:line];
    [control.view addSubview:self.contentView];
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.frame = [UIScreen mainScreen].bounds;
    } completion:^(BOOL finished) {
        
    }];
    self.MyControl = control;
}
- (void)optimalCameraBtnPressed:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // 应用第一次申请权限调用这里
        if ([YFKit isCameraNotDetermined])
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted)
                    {
                        // 用户授权
                        [self presentToImagePickerController:UIImagePickerControllerSourceTypeCamera];
                    }
                    else
                    {
                        // 用户拒绝授权
                        [self showAlertController:@"提示" message:@"授权失败"];
                    }
                });
            }];
        }
        // 用户已经拒绝访问摄像头
        else if ([YFKit isCameraDenied])
        {
            [self showAlertController:@"提示" message:@"拒绝访问摄像头，可去设置隐私里开启"];
        }
        
        // 用户允许访问摄像头
        else
        {
            [self presentToImagePickerController:UIImagePickerControllerSourceTypeCamera];
        }
    }
    else
    {
        // 当前设备不支持摄像头，比如模拟器
        [self showAlertController:@"提示" message:@"当前设备不支持拍照"];
    }
}

- (void)optimalPhotoBtnPressed:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        // 第一次安装App，还未确定权限，调用这里
        if ([YFKit isPhotoAlbumNotDetermined])
        {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            {
                // 该API从iOS8.0开始支持
                // 系统弹出授权对话框
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
                        {
                            // 用户拒绝授权
                            [self showAlertController:@"提示" message:@"授权失败"];
                        }
                        else if (status == PHAuthorizationStatusAuthorized)
                        {
                            // 用户授权，弹出相册对话框
                            [self presentToImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
                        }
                    });
                }];
            }
            else
            {
                // 以上requestAuthorization接口只支持8.0以上，如果App支持7.0及以下，就只能调用这里。
//                NSLog(@"// 以上requestAuthorization接口只支持8.0以上，如果App支持7.0及以下，就只能调用这里。");
                [self presentToImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
            }
        }
        else if ([YFKit isPhotoAlbumDenied])
        {
            // 如果已经拒绝，则弹出对话框
            [self showAlertController:@"提示" message:@"拒绝访问相册，可去设置隐私里开启"];
        }
        else
        {
            // 已经授权，跳转到相册页面
            [self presentToImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
        }
    }
    else
    {
        // 当前设备不支持打开相册
        [self showAlertController:@"提示" message:@"当前设备不支持相册"];
    }
}
- (void)showAlertController:(NSString *)title message:(NSString *)message
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self.MyControl presentViewController:ac animated:YES completion:nil];
}
- (void)presentToImagePickerController:(UIImagePickerControllerSourceType)type
{
    self.picker.sourceType = type;
    [self.MyControl presentViewController:self.picker animated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.darkView removeFromSuperview];
    [self.contentView removeFromSuperview];
    self.contentView.frame = CGRectMake(0, 200, SCREEN_WIDTH, SCREEN_HEIGHT);
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    self.image = info[UIImagePickerControllerEditedImage];
    [self.picker dismissViewControllerAnimated:YES completion:^{
        if(self.back)
        {
            self.back(self.image);
        }
        [self.darkView removeFromSuperview];
        self.contentView.frame = CGRectMake(0, 200, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}
+ (ImagePickerViewController *) shareImage
{
    static ImagePickerViewController *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ImagePickerViewController alloc]init];
    });
    return instance;
}
- (void) btnAlbumClick{
    [self tapClick];
    self.btnheadImageClick();
}
#pragma mark gesture
- (void) tapClick
{
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.frame = CGRectMake(0, 200, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self.darkView removeFromSuperview];
        [self.contentView removeFromSuperview];
    }];
}
#pragma  mark -- getter
- (UIImagePickerController *)picker{
    if(!_picker){
        _picker = [[UIImagePickerController alloc]init];
        _picker.delegate = self;
        _picker.allowsEditing = YES;
        _picker.navigationBar.tintColor = MainRedColor;
    }
    return _picker;
}
- (UIView *)contentView
{
    if(!_contentView)
    {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _contentView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
        [_contentView addGestureRecognizer:tap];
    }
    return _contentView;
}
- (UIView *)darkView
{
    if(!_darkView)
    {
        _darkView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _darkView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    return _darkView;
}
- (UIView *)cancelView
{
    if(!_cancelView)
    {
        _cancelView = [[UIView alloc]initWithFrame:BQAdaptationFrame(15,IPHONE_HEIGHT+60,IPHONE_WIDTH-30,80)];
        _cancelView.backgroundColor = [UIColor whiteColor];
        _cancelView.layer.cornerRadius = 10;
    }
    return _cancelView;
}
- (UIView *)chooseView
{
    if(!_chooseView)
    {
        _chooseView = [[UIView alloc]initWithFrame:BQAdaptationFrame(15, IPHONE_HEIGHT-120, IPHONE_WIDTH-30, 150)];
        _chooseView.backgroundColor = [UIColor whiteColor];
        _chooseView.layer.cornerRadius = 8;
    }
    return _chooseView;
}
- (UIButton *)btnAlbum
{
    if(!_btnAlbum)
    {
        _btnAlbum = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnAlbum setTitle:@"查看图片" forState:UIControlStateNormal];
        [_btnAlbum setTitleColor:self.btnColor forState:UIControlStateNormal];
        _btnAlbum.bounds = BQAdaptationFrame(0, 0, IPHONE_WIDTH-30, 60);
        _btnAlbum.center = BQadaptationCenter(CGPointMake(IPHONE_WIDTH/2, CGRectGetMaxY(self.chooseView.frame)/BQAdaptationWidth()-40));
        [_btnAlbum addTarget:self action:@selector(btnAlbumClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnAlbum;
}
- (UIButton *)btnCamrea
{
    if(!_btnCamrea)
    {
        _btnCamrea = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnCamrea setTitleColor:self.btnColor forState:UIControlStateNormal];
        [_btnCamrea setTitle:@"更改头像" forState:UIControlStateNormal];
        _btnCamrea.bounds = BQAdaptationFrame(0, 0, IPHONE_WIDTH-30, 60);
        _btnCamrea.center = BQadaptationCenter(CGPointMake(IPHONE_WIDTH/2, CGRectGetMinY(self.chooseView.frame)/BQAdaptationWidth()+40));
        [_btnCamrea addTarget:self action:@selector(optimalPhotoBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCamrea;
}
- (UIButton *)btnCancel
{
    if(!_btnCancel)
    {
        _btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        _btnCancel.bounds = BQAdaptationFrame(0, 0, IPHONE_WIDTH-20, 50);
        _btnCancel.center = self.cancelView.center;
        [_btnCancel setTitleColor:self.btnColor forState:UIControlStateNormal];
        [_btnCancel addTarget:self action:@selector(tapClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCancel;
}
@end
