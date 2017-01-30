//
//  PencilViewController.m
//  PencilBox
//
//  Created by 李恺林 on 2017/1/21.
//  Copyright © 2017年 李恺林. All rights reserved.
//

#import "PencilViewController.h"
#import "PencilPaint.h"
#import "PhotoViewController.h"
#import "UIButton+DJBlock.h"
#import "DJCameraManager.h"
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define AppWidth [[UIScreen mainScreen] bounds].size.width
#define AppHeigt [[UIScreen mainScreen] bounds].size.height
@interface PencilViewController () <DJCameraManagerDelegate>
@property (nonatomic,strong)DJCameraManager *manager;
@end

@implementation PencilViewController {
    PencilPaint *paintView;
    UIView *pickView;
}
/**
 *  在页面结束或出现记得开启／停止摄像
 *
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![self.manager.session isRunning]) {
        [self.manager.session startRunning];
    }
    paintView = [[PencilPaint alloc]initWithFrame:self.view.frame];
    [self.view addSubview:paintView];
    [self.view insertSubview:paintView aboveSubview:pickView];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.manager.session isRunning]) {
        [self.manager.session stopRunning];
    }
}


- (void)dealloc
{
    NSLog(@"照相机释放了");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initLayout];
    [self initPickButton];
    //[self initFlashButton];
    [self initCameraFontOrBackButton];
    [self initDismissButton];
}

- (void)initLayout
{
    self.view.backgroundColor = [UIColor colorWithRed:250.0/255 green:255.0/255 blue:240.0/255 alpha:1.0];
    
    pickView = [[UIView alloc]initWithFrame:CGRectMake(10, 20, AppWidth - 20, AppWidth + 140)];
    [self.view addSubview:pickView];

    // 传入View的frame 就是摄像的范围
    DJCameraManager *manager = [[DJCameraManager alloc] initWithParentView:pickView];
    manager.delegate = self;
    manager.canFaceRecognition = YES;
    [manager setFaceRecognitonCallBack:^(CGRect faceFrame) {
        NSLog(@"你的脸在%@",NSStringFromCGRect(faceFrame));
    }];
    
    self.manager = manager;
}

/**
 * 截图
 */
- (UIImage *)snapshotSingleView:(UIView *)view
{
    CGRect rect =  CGRectMake(10, 20, AppWidth - 20, AppWidth + 140);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize

{
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

/**
 *  拍照按钮
 */
- (void)initPickButton
{
    static CGFloat buttonW = 40;
    UIButton *button = [self buildButton:CGRectMake(AppWidth/2-buttonW/2, AppWidth+120+(AppHeigt-AppWidth-100-20)/2 - buttonW/2 - 20, buttonW, buttonW)
                            normalImgStr:@"shut"
                         highlightImgStr:@"shut"
                          selectedImgStr:@""
                              parentView:self.view];
    WS(weak);
    [button addActionBlock:^(id sender) {
        [weak.manager takePhotoWithImageBlock:^(UIImage *originImage, UIImage *scaledImage, UIImage *croppedImage) {
            if (croppedImage) {
                
                UIImage *paintImage = [self scaleImage:[self snapshotSingleView:paintView] toScale:2.0];
                
                
                CGImageRef imgRef = paintImage.CGImage;
                CGFloat w = CGImageGetWidth(imgRef);
                CGFloat h = CGImageGetHeight(imgRef);
                
                //以1.png的图大小为底图
                CGImageRef imgRef1 = croppedImage.CGImage;
                CGFloat w1 = CGImageGetWidth(imgRef1);
                CGFloat h1 = CGImageGetHeight(imgRef1);
                
                //以1.png的图大小为画布创建上下文
                UIGraphicsBeginImageContext(CGSizeMake(w1, h1));
                
                [croppedImage drawInRect:CGRectMake(0, 0, w1, h1)];//先把1.png 画到上下文中
                [paintImage drawInRect:CGRectMake(-10, -30, w1, h1)];//再把小图放在上下文中
                UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();//从当前上下文中获得最终图片
                UIGraphicsEndImageContext();//关闭上下文
                
                [paintView removeFromSuperview];
                PhotoViewController *VC = [PhotoViewController new];
                VC.image = resultImg;
                VC.sourceImage = croppedImage;
                [weak presentViewController:VC animated:YES completion:nil];
            }
        }];
    } forControlEvents:UIControlEventTouchUpInside];
}
/**
 *  切换闪光灯按钮
 */

/**
 *  切换前后镜按钮
 */
- (void)initCameraFontOrBackButton
{
    static CGFloat buttonW = 30;
    UIButton *button = [self buildButton:CGRectMake(300, AppWidth+120+(AppHeigt-AppWidth-100-20)/2 - buttonW/2 - 20, buttonW, buttonW)
                            normalImgStr:@"change"
                         highlightImgStr:@""
                          selectedImgStr:@""
                              parentView:self.view];
    WS(weak);
    [button addActionBlock:^(id sender) {
        UIButton *bu = sender;
        bu.enabled = NO;
        bu.selected = !bu.selected;
        [weak.manager switchCamera:bu.selected didFinishChanceBlock:^{
            bu.enabled = YES;
        }];
    } forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)initDismissButton
{
    UIButton *button = [self buildButton:CGRectMake(40, AppWidth+120+(AppHeigt-AppWidth-100-20)/2 - 15 - 20, 30, 30)
                            normalImgStr:@"cancle"
                         highlightImgStr:@""
                          selectedImgStr:@""
                              parentView:self.view];
    WS(weak);
    [button addActionBlock:^(id sender) {
        [weak dismissViewControllerAnimated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
/**
 *  点击对焦
 *
 *  @param touches
 *  @param event
 */

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    [self.manager focusInPoint:point];
}

- (UIButton*)buildButton:(CGRect)frame
            normalImgStr:(NSString*)normalImgStr
         highlightImgStr:(NSString*)highlightImgStr
          selectedImgStr:(NSString*)selectedImgStr
              parentView:(UIView*)parentView {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    if (normalImgStr.length > 0) {
        [btn setImage:[UIImage imageNamed:normalImgStr] forState:UIControlStateNormal];
    }
    if (highlightImgStr.length > 0) {
        [btn setImage:[UIImage imageNamed:highlightImgStr] forState:UIControlStateHighlighted];
    }
    if (selectedImgStr.length > 0) {
        [btn setImage:[UIImage imageNamed:selectedImgStr] forState:UIControlStateSelected];
    }
    [parentView addSubview:btn];
    return btn;
}

#pragma -mark DJCameraDelegate
- (void)cameraDidFinishFocus
{
    NSLog(@"对焦结束了");
}
- (void)cameraDidStareFocus
{
    NSLog(@"开始对焦");
}

@end

