//
//  ImagePickerViewController.m
//  MyVedio
//
//  Created by fengei on 16/6/12.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "ImagePickerViewController.h"
#import "BQScreenAdaptation.h"
@interface ImagePickerViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UIImagePickerController *picker;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) UIImageView *ImageCut;

@property (nonatomic,strong) UIView *contentView;//
@property (nonatomic,strong) UIView *darkView;
@property (nonatomic,strong) UIView *cancelView;
@property (nonatomic,strong) UIView *chooseView;
@property (nonatomic,strong) UIButton *btnCamrea;
@property (nonatomic,strong) UIButton *btnAlbum;
@property (nonatomic,strong) UIButton *btnCancel;

@property (nonatomic,strong) UIViewController *MyControl;
@end

@implementation ImagePickerViewController
//////////////////////////外部调用Begin
+ (void) alertView:(UIViewController *) control
{
    [[ImagePickerViewController shareImage] MyAlertView:control];
}
//////////////////////////外部调用end
- (void) MyAlertView:(UIViewController *) control
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
- (void) showPicker:(UIViewController *) control
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [control presentViewController:self.picker animated:YES completion:^{
            [self.contentView removeFromSuperview];
        }];
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"设备不支持相册" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [control presentViewController:alert animated:YES completion:nil];
    }
}
- (void) showCamrea:(UIViewController *) control
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [control presentViewController:self.picker animated:YES completion:^{
            [self.contentView removeFromSuperview];
        }];
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"设备不支持相机" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [control presentViewController:alert animated:YES completion:nil];
    }
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self myAdd];
    }
    return self;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.darkView removeFromSuperview];
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
- (void) myAdd
{
    self.picker = [[UIImagePickerController alloc]init];
    self.picker.delegate = self;
    self.picker.allowsEditing = YES;
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
- (void) btnAlbumClick  //相册
{
    [self showPicker:self.MyControl];
}
- (void) btnCamreaClick //相机
{
    [self showCamrea:self.MyControl];
}
#pragma  mark -- getter
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
        _cancelView = [[UIView alloc]initWithFrame:BQAdaptationFrame(10,IPHONE_HEIGHT+70,IPHONE_WIDTH-20,80)];
        _cancelView.backgroundColor = [UIColor whiteColor];
        _cancelView.layer.cornerRadius = 10;
    }
    return _cancelView;
}
- (UIView *)chooseView
{
    if(!_chooseView)
    {
        _chooseView = [[UIView alloc]initWithFrame:BQAdaptationFrame(10, IPHONE_HEIGHT-90, IPHONE_WIDTH-20, 150)];
        _chooseView.backgroundColor = [UIColor whiteColor];
        _chooseView.layer.cornerRadius = 10;
    }
    return _chooseView;
}
- (UIButton *)btnAlbum
{
    if(!_btnAlbum)
    {
        _btnAlbum = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnAlbum setTitle:@"从相册选择" forState:UIControlStateNormal];
        [_btnAlbum setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _btnAlbum.bounds = BQAdaptationFrame(0, 0, IPHONE_WIDTH-20, 50);
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
        [_btnCamrea setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_btnCamrea setTitle:@"相机" forState:UIControlStateNormal];
        _btnCamrea.bounds = BQAdaptationFrame(0, 0, IPHONE_WIDTH-20, 50);
        _btnCamrea.center = BQadaptationCenter(CGPointMake(IPHONE_WIDTH/2, CGRectGetMinY(self.chooseView.frame)/BQAdaptationWidth()+40));
        [_btnCamrea addTarget:self action:@selector(btnCamreaClick) forControlEvents:UIControlEventTouchUpInside];
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
        [_btnCancel setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_btnCancel addTarget:self action:@selector(tapClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCancel;
}
@end
