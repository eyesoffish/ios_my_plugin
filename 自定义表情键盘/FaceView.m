//
//  FaceView.m
//  MyNavgationTest
//
//  Created by fengei on 16/7/21.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "FaceView.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface FaceView()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scFace;//显示表情的滚动视图
@property (nonatomic,strong) NSArray *arrFace;//表情包
@property (nonatomic,strong) UIPageControl *pageC;//分页控制器
@property (nonatomic,strong) NSMutableString *callBackString;

@end
@implementation FaceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initalize];
    }
    return self;
}
- (void) initalize
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"EmojisList" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    self.arrFace = dic[@"People"];
    [self setFaceFrame];
}
- (void)setFaceFrame
{
    //列数
    NSInteger colFaces = 7;
    //行数
    NSInteger rowFaces = 3;
    //设置face按钮frame
    CGFloat FaceW = 30;
    CGFloat FaceH = 30;
    CGFloat marginX = (SCREEN_WIDTH - colFaces * FaceW) / (colFaces + 1);
    CGFloat marginY = marginX;
    NSLog(@"%lf",marginX);
    
    //表情数量
    NSInteger FaceCount = self.arrFace.count;
    //每页表情数和scrollView页数；
    NSInteger PageFaceCount = colFaces * rowFaces ;
    NSInteger SCPages = FaceCount / PageFaceCount + 1;
    
    CGFloat scViewH = rowFaces * (FaceH + marginY) + marginY*2 + 10;
    //初始化scrollView
    self.scFace = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, scViewH)];
    self.scFace.contentSize = CGSizeMake(SCREEN_WIDTH * SCPages, scViewH);
    self.scFace.pagingEnabled = YES;
    self.scFace.bounces = NO;
    self.scFace.delegate = self;
    self.scFace.showsVerticalScrollIndicator = NO;
    self.scFace.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scFace];
    //初始化贴在sc上的view
    UIView * BtnView = [[UIView alloc] init];
    BtnView.frame = CGRectMake(0, 0, SCREEN_WIDTH * SCPages, scViewH);
    BtnView.backgroundColor = [UIColor whiteColor];
    [self.scFace addSubview:BtnView];
    
    for (NSInteger i = 0; i < FaceCount + SCPages; i ++)
    {
        //当前页数
        NSInteger currentPage = i / PageFaceCount;
        //当前行
        NSInteger rowIndex = i / colFaces - (currentPage * rowFaces);
        //当前列
        NSInteger colIndex = i % colFaces;
        
        //viewW * currentPage换页
        CGFloat btnX = marginX + colIndex * (FaceW + marginX) + SCREEN_WIDTH * currentPage;
        CGFloat btnY = rowIndex * (marginY + FaceH) + marginY;
        if ((i - (currentPage + 1) * (PageFaceCount - 1) == currentPage || i == FaceCount + SCPages - 1) && self.arrFace)
        {
            //创建删除按钮
            CGFloat btnDelteX = (currentPage + 1) * SCREEN_WIDTH - (marginX + FaceW);
            CGFloat btnDelteY = 2 * (FaceH + marginY) +marginY;
            
            UIButton * btnDelte = [UIButton buttonWithType:UIButtonTypeSystem];
            btnDelte.frame = CGRectMake(btnDelteX, btnDelteY, FaceW, FaceH);
            [btnDelte setBackgroundImage:[UIImage imageNamed:@"del"] forState:UIControlStateNormal];
            [btnDelte setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btnDelte.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            
            [btnDelte addTarget:self action:@selector(tapDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
            [BtnView addSubview:btnDelte];
        }
        else
        {
            //创建face按钮
            UIButton * btn = [[UIButton alloc] init];
            btn.frame = CGRectMake(btnX , btnY, FaceW, FaceH);
            //tga
            btn.tag = i - currentPage;
            //按钮回调；
            [btn addTarget:self action:@selector(tapFaceBtnWithButton:) forControlEvents:UIControlEventTouchUpInside];
            NSString * strIMG = self.arrFace[i - currentPage];
            [btn setTitle:strIMG forState:UIControlStateNormal];
            [BtnView addSubview:btn];
        }
    }
    
    //创建pageController
    CGFloat pageH = 10;
    CGFloat pageW = SCREEN_WIDTH;
    CGFloat pageX = 0;
    CGFloat pageY = scViewH - pageH - marginY;
    self.pageC = [[UIPageControl alloc] initWithFrame:CGRectMake(pageX, pageY, pageW, pageH)];
    self.pageC.numberOfPages = SCPages;
    self.pageC.currentPage = 0;
    self.pageC.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageC.currentPageIndicatorTintColor = [UIColor grayColor];
    [self addSubview:self.pageC];
}
#pragma mark ---delegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    self.pageC.currentPage = targetContentOffset->x / SCREEN_WIDTH;
}
#pragma mark---删除回调
- (void) tapDeleteBtn
{
    if(![self.callBackString isEqualToString:@""]&&self.callBackString.length - 2 >= 2)
    {
        [self.callBackString deleteCharactersInRange:NSMakeRange(self.callBackString.length-2, 2)];
//        NSLog(@"%@",self.callBackString);
    }
    else
    {
        self.callBackString = [NSMutableString string];
//        NSLog(@"callBackString = %@",self.callBackString);
    }
    self.face([self.callBackString copy]);
}
- (void) tapFaceBtnWithButton:(UIButton *) sender
{
    if(self.face)
    {
        [self.callBackString appendString:sender.titleLabel.text];
//        NSLog(@"%@",self.callBackString);
        self.face([self.callBackString copy]);
    }
}
#pragma mark ---getter
- (NSMutableString *)callBackString
{
    if(!_callBackString)
    {
        _callBackString = [NSMutableString string];
    }
    return _callBackString;
}
@end
