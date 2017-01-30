//
//  PencilBox
//
//  Created by 李恺林 on 2017/1/21.
//  Copyright © 2017年 李恺林. All rights reserved.
//

#import "PhotoViewController.h"
#import "UIButton+DJBlock.h"
#import <AFNetworking.h>
#import <MBProgressHUD.h>
#import "CompareViewController.h"
#define AppWidth [[UIScreen mainScreen] bounds].size.width

#define AppHeigt [[UIScreen mainScreen] bounds].size.height
@interface PhotoViewController ()

@end

@implementation PhotoViewController {
    NSString *currentDateString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    currentDateString = [dateFormatter stringFromDate:currentDate];
    
    self.view.backgroundColor = [UIColor colorWithRed:250.0/255 green:255.0/255 blue:240.0/255 alpha:1.0];
    // Do any additional setup after loading the view.
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];
    imageView.frame = CGRectMake(10, 20, AppWidth - 20, AppWidth + 140);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    
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
   
    UIButton *save = [self buildButton:CGRectMake(300, AppWidth+120+(AppHeigt-AppWidth-100-20)/2 - 11 - 20, 30, 30)
                            normalImgStr:@"save"
                         highlightImgStr:@""
                          selectedImgStr:@""
                              parentView:self.view];

    [self.view addSubview:save];
    [save addActionBlock:^(id sender) {
        [self saveImageToPhotos:self.image];
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
    
    
    
    UIButton *compare = [self buildButton:CGRectMake(130, AppWidth+120+(AppHeigt-AppWidth-100-20)/2 - 11 - 20, 30, 30)
                          normalImgStr:@"compare"
                       highlightImgStr:@""
                        selectedImgStr:@""
                            parentView:self.view];

    [self.view addSubview:compare];
    [compare addActionBlock:^(id sender) {
        [self saveImageToPhotos:self.image];
        
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.userInteractionEnabled = YES;
        hud.animationType = MBProgressHUDAnimationZoom;
        hud.label.text = @"正在查找";
        hud.minShowTime = 2;
        //hud.contentColor = [UIColor grayColor];
        //hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"correctIcon"]];
        hud.removeFromSuperViewOnHide = YES;
        //[hud hideAnimated:YES afterDelay:1];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes =[NSSet setWithObject:@"text/html"];
        
        NSData *data = UIImageJPEGRepresentation(self.sourceImage, 0.1);
        
        NSString *encodedImageStr = [data base64EncodedStringWithOptions:0];


        
        
        NSDictionary *send = @{@"name":currentDateString, @"data":encodedImageStr};
        [manager POST:@"http://25.0.0.161/server1.php" parameters:send success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString * getString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            if ([getString isEqualToString:@"Error233"]) {
                [hud removeFromSuperview];
                
                [hud hideAnimated:YES];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeCustomView;
                hud.label.text = @"未找到类似图片";
                hud.minShowTime = 3;
                hud.userInteractionEnabled = YES;
                hud.animationType = MBProgressHUDAnimationZoom;
                hud.contentColor = [UIColor grayColor];
                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cryIcon"]];
                hud.removeFromSuperViewOnHide = YES;
                [hud hideAnimated:YES afterDelay:3];
                //[weak dismissViewControllerAnimated:YES completion:nil];
                }
            else{
                [hud removeFromSuperview];
                
                [hud hideAnimated:YES];
                NSData  *imgData = [[NSData alloc] initWithBase64EncodedString:getString options:0];
                UIImage *img     = [UIImage imageWithData:imgData];
                CompareViewController *VC = [CompareViewController new];
                VC.netImage = img;
                VC.locationImage = self.image;
                [self presentViewController:VC animated:YES completion:nil];
                //[weak dismissViewControllerAnimated:YES completion:nil];
                
            }
        }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [hud removeFromSuperview];
                  
                  [hud hideAnimated:YES];
                  NSLog(@"上传失败");
                  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                  hud.mode = MBProgressHUDModeCustomView;
                  hud.label.text = @"上传失败";
                  hud.userInteractionEnabled = YES;
                  hud.animationType = MBProgressHUDAnimationZoom;
                  hud.contentColor = [UIColor grayColor];
                  hud.minShowTime = 3;
                  hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cryIcon"]];
                  hud.removeFromSuperViewOnHide = YES;
                  [hud hideAnimated:YES afterDelay:2];

                  [weak dismissViewControllerAnimated:YES completion:nil];
              }];

    } forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *upload = [self buildButton:CGRectMake(210, AppWidth+120+(AppHeigt-AppWidth-100-20)/2 - 11 - 20, 30, 30)
                             normalImgStr:@"upload"
                          highlightImgStr:@""
                           selectedImgStr:@""
                               parentView:self.view];
    
    [self.view addSubview:upload];
    [upload addActionBlock:^(id sender) {
        [self saveImageToPhotos:self.image];
        
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.userInteractionEnabled = YES;
        hud.animationType = MBProgressHUDAnimationZoom;
        hud.label.text = @"正在上传";
        hud.minShowTime = 3;
        //hud.contentColor = [UIColor grayColor];
        //hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"correctIcon"]];
        hud.removeFromSuperViewOnHide = YES;
        //[hud hideAnimated:YES afterDelay:1];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes =[NSSet setWithObject:@"text/html"];
        
        NSData *data = UIImageJPEGRepresentation(self.image, 0.3);
        
        NSString *encodedImageStr = [data base64EncodedStringWithOptions:0];
        
        
        
        
        NSDictionary *send = @{@"name":currentDateString, @"data":encodedImageStr};
        [manager POST:@"http://25.0.0.161/server2.php" parameters:send success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [hud removeFromSuperview];
            
            [hud hideAnimated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeCustomView;
            hud.userInteractionEnabled = YES;
            hud.animationType = MBProgressHUDAnimationZoom;
            hud.label.text = @"上传成功";
            hud.contentColor = [UIColor grayColor];
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"correctIcon"]];
            hud.removeFromSuperViewOnHide = YES;
            [hud hideAnimated:YES afterDelay:3];
            [weak dismissViewControllerAnimated:YES completion:nil];
        }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [hud removeFromSuperview];
                  
                  [hud hideAnimated:YES];
                  NSLog(@"上传失败");
                  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                  hud.mode = MBProgressHUDModeCustomView;
                  hud.label.text = @"上传失败";
                  hud.userInteractionEnabled = YES;
                  hud.animationType = MBProgressHUDAnimationZoom;
                  hud.contentColor = [UIColor grayColor];
                  hud.minShowTime = 3;
                  hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cryIcon"]];
                  hud.removeFromSuperViewOnHide = YES;
                  [hud hideAnimated:YES afterDelay:2];
                  
                  [weak dismissViewControllerAnimated:YES completion:nil];
              }];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    

}

- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    //因为需要知道该操作的完成情况，即保存成功与否，所以此处需要一个回调方法image:didFinishSavingWithError:contextInfo:
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
