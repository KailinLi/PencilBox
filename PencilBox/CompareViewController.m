//
//  CompareViewController.m
//  PencilBox
//
//  Created by 李恺林 on 2017/1/22.
//  Copyright © 2017年 李恺林. All rights reserved.
//

#import "CompareViewController.h"
#import "UIButton+DJBlock.h"
#import <MBProgressHUD.h>
#define AppWidth [[UIScreen mainScreen] bounds].size.width

#define AppHeigt [[UIScreen mainScreen] bounds].size.height

@interface CompareViewController ()

@end

@implementation CompareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:250.0/255 green:255.0/255 blue:240.0/255 alpha:1.0];
    // Do any additional setup after loading the view.
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.locationImage];
    imageView.frame = CGRectMake(5, 20, AppWidth / 2 - 10, AppWidth + 140);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    
    UIImageView *getImage = [[UIImageView alloc] initWithImage:self.netImage];
    getImage.frame = CGRectMake(AppWidth / 2 - 10 + 15, 20, AppWidth / 2 - 10, AppWidth + 140);
    getImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:getImage];
    // Do any additional setup after loading the view.
    
    UIButton *button = [self buildButton:CGRectMake(30, AppWidth+120+(AppHeigt-AppWidth-100-20)/2 - 11 - 20, 30, 30)
                            normalImgStr:@"cancle"
                         highlightImgStr:@""
                          selectedImgStr:@""
                              parentView:self.view];
    

    [self.view addSubview:button];
    __weak typeof(self) weak = self;
    [button addActionBlock:^(id sender) {
        [weak dismissViewControllerAnimated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *save = [self buildButton:CGRectMake(300, AppWidth+120+(AppHeigt-AppWidth-100-20)/2 - 40/2 - 20, 30, 30)
                            normalImgStr:@"save"
                         highlightImgStr:@""
                          selectedImgStr:@""
                              parentView:self.view];
    

    [self.view addSubview:save];
    [save addActionBlock:^(id sender) {
        [self saveImageToPhotos:self.netImage];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.userInteractionEnabled = YES;
        hud.animationType = MBProgressHUDAnimationZoom;
        hud.label.text = @"保存成功";
        hud.contentColor = [UIColor grayColor];
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"correctIcon"]];
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:3];
        [weak dismissViewControllerAnimated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    
    //UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    //[self showViewController:alert sender:nil];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
