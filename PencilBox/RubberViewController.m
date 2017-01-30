//
//  RubberViewController.m
//  PencilBox
//
//  Created by 李恺林 on 2017/1/21.
//  Copyright © 2017年 李恺林. All rights reserved.
//

#import "RubberViewController.h"
#import "BubberPaint.h"
#import "PhotoViewController.h"
#import "UIButton+DJBlock.h"
#import <MBProgressHUD.h>
#import "DJCameraManager.h"
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define AppWidth [[UIScreen mainScreen] bounds].size.width
#define AppHeigt [[UIScreen mainScreen] bounds].size.height
@interface RubberViewController () <DJCameraManagerDelegate>
@property (nonatomic,strong)DJCameraManager *manager;
@end

@implementation RubberViewController {
    BubberPaint *paintView;
    UIView *pickView;
    UIImageView *pickImage;
    NSInteger havePicked;
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
    paintView = [[BubberPaint alloc]initWithFrame:self.view.frame];
    havePicked = 0;
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
    [self initgetColor];
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

/**
 *  拍照按钮
 */

- (void) initgetColor {
    static CGFloat buttonW = 40;
    UIButton *button = [self buildButton:CGRectMake(AppWidth/2-buttonW/2 + 80 + 25
                                                    , AppWidth+120+(AppHeigt-AppWidth-100-20)/2 - buttonW/2, buttonW, buttonW)
                            normalImgStr:@"pick"
                         highlightImgStr:@"pick"
                          selectedImgStr:@""
                              parentView:self.view];
    WS(weak);
    [button addActionBlock:^(id sender) {
        [weak.manager takePhotoWithImageBlock:^(UIImage *originImage, UIImage *scaledImage, UIImage *croppedImage) {
            if (havePicked == 0) {
                if (croppedImage) {
                    havePicked = 1;
                    pickImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, AppWidth - 20, AppWidth + 140)];
                    pickImage.image = croppedImage;
                    //[self.view addSubview:pickImage];
                    [self.view sendSubviewToBack:paintView];
                    //                UIImage *paintImage = [self snapshotSingleView:paintView];
                    //                
                    
                }
            }
            else {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeCustomView;
                hud.label.text = @"只能选色一次哦";
                hud.userInteractionEnabled = YES;
                hud.animationType = MBProgressHUDAnimationZoom;
                hud.contentColor = [UIColor grayColor];
                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cryIcon"]];
                hud.removeFromSuperViewOnHide = YES;
                [hud hideAnimated:YES afterDelay:2];
            }
            
        }];
    } forControlEvents:UIControlEventTouchUpInside];
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize

{
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (void)initPickButton
{
    static CGFloat buttonW = 40;
    UIButton *button = [self buildButton:CGRectMake(AppWidth/2-buttonW/2, AppWidth+120+(AppHeigt-AppWidth-100-20)/2 - buttonW/2, buttonW, buttonW)
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
    UIButton *button = [self buildButton:CGRectMake(80 + 20, AppWidth+120+(AppHeigt-AppWidth-100-20)/2 - buttonW/2, buttonW, buttonW)
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
    UIButton *button = [self buildButton:CGRectMake(30, AppWidth+120+(AppHeigt-AppWidth-100-20)/2 - 11, 30, 30)
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
    CGPoint size = [self.view convertPoint:point toView:pickImage];
    NSLog(@"%f %f", size.x, size.y);
    //[self.manager focusInPoint:point];
    if (pickImage.image) {
        UIColor *imageColor = [self getPixelColorAtLocation:size :pickImage.image];
        paintView.currColor = imageColor;
        //[pickImage removeFromSuperview];
        pickImage.image = nil;
        [self.view insertSubview:paintView aboveSubview:pickView];
    }
//    
//    UIColor *pointColor = [self colorOfPoint:point];
//    shit.backgroundColor = pointColor;
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

- (UIColor*) getPixelColorAtLocation: (CGPoint)point : (UIImage *)image {
    UIColor* color = nil;
    CGImageRef inImage = image.CGImage;
    // Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
    if (cgctx == NULL) { return nil; /* error */ }
    
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(cgctx, rect, inImage);
    
    
    unsigned char* data = CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        //offset locates the pixel in the data from x,y.
        //4 for 4 bytes of data per pixel, w is width of one row of data.
        int offset = 4*((w*round(point.y))+round(point.x));
        int alpha =  data[offset];
        int red = data[offset+1];
        int green = data[offset+2];
        int blue = data[offset+3];
        NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
        color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
    }
    
    // When finished, release the context
    CGContextRelease(cgctx);
    // Free image data memory for the context
    if (data) { free(data); }
    
    return color;
}


- (CGContextRef)createARGBBitmapContextFromImage:(CGImageRef)inImage
{
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapData;
    unsigned long bitmapByteCount;
    unsigned long bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL)
    {
        fprintf(stderr,"Error allocating color space\n");
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc(bitmapByteCount);
    if (bitmapData == NULL)
    {
        fprintf(stderr,"Memory not allocated!");
        CGColorSpaceRelease(colorSpace);
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate(bitmapData,
                                    pixelsWide,
                                    pixelsHigh,
                                    8,   // bits per component
                                    bitmapBytesPerRow,
                                    colorSpace,
                                    kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free(bitmapData);
        fprintf(stderr,"Context not created!");
    }
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease(colorSpace);
    
    return context;
}


@end

