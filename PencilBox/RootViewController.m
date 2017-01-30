//
//  RootViewController.m
//  PencilBox
//
//  Created by 李恺林 on 2017/1/21.
//  Copyright © 2017年 李恺林. All rights reserved.
//

#import "RootViewController.h"
#import "PencilViewController.h"
#import "RubberViewController.h"
#import "RuleViewController.h"
#import "DJCameraManager.h"

#define AppWidth [[UIScreen mainScreen] bounds].size.width
#define AppHeigt [[UIScreen mainScreen] bounds].size.height

@interface RootViewController ()

@end

@implementation RootViewController {
    UIButton *pencil;
    UIButton *rubber;
    UIButton *ruler;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:245/255.0 green:222.0/255.0 blue:179.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor brownColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor brownColor],NSForegroundColorAttributeName,nil]];
    self.navigationItem.title = @"小小文具盒";
    
    
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"云端" style:UIBarButtonItemStylePlain target:self action:@selector(album)];
//    self.navigationItem.rightBarButtonItem = addButton;
    
    
    self.view.backgroundColor = [UIColor colorWithRed:250.0/255 green:255.0/255 blue:240.0/255 alpha:1.0];
    pencil = [[UIButton alloc]initWithFrame:CGRectMake(30, 80, AppWidth - 60, 180)];
    [pencil setImage:[UIImage imageNamed:@"pencil"] forState:UIControlStateNormal];
    pencil.layer.masksToBounds = YES;
    [pencil.layer setCornerRadius: 10];
    pencil.layer.borderWidth = 5;
    pencil.layer.borderColor = [UIColor grayColor].CGColor;
    [self.view addSubview:pencil];
    [pencil addTarget:self action:@selector(pencil) forControlEvents:UIControlEventTouchUpInside];
    
    rubber = [[UIButton alloc]initWithFrame:CGRectMake(30, 275, AppWidth - 60, 180)];
    rubber.backgroundColor = [UIColor blueColor];
    [rubber setImage:[UIImage imageNamed:@"rubber"] forState:UIControlStateNormal];
    rubber.layer.masksToBounds = YES;
    [rubber.layer setCornerRadius: 10];
    rubber.layer.borderWidth = 5;
    rubber.layer.borderColor = [UIColor grayColor].CGColor;
    [self.view addSubview:rubber];
    [rubber addTarget:self action:@selector(rubber) forControlEvents:UIControlEventTouchUpInside];
    
    ruler = [[UIButton alloc]initWithFrame:CGRectMake(30, 470, AppWidth - 60, 180)];
    [ruler setImage:[UIImage imageNamed:@"ruler"] forState:UIControlStateNormal];
    ruler.layer.masksToBounds = YES;
    [ruler.layer setCornerRadius: 10];
    ruler.layer.borderWidth = 5;
    ruler.layer.borderColor = [UIColor grayColor].CGColor;
    [self.view addSubview:ruler];
    [ruler addTarget:self action:@selector(ruler) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) pencil {
    if ([DJCameraManager checkAuthority]) {
        PencilViewController *VC = [PencilViewController new];
        [self presentViewController:VC animated:YES completion:nil];
    }else{
        NSLog(@"请在系统中打开相机权限");
    }
}

- (void) rubber {
    if ([DJCameraManager checkAuthority]) {
        RubberViewController *VC = [RubberViewController new];
        [self presentViewController:VC animated:YES completion:nil];
    }else{
        NSLog(@"请在系统中打开相机权限");
    }
}

- (void) ruler {
    RuleViewController *ruleVC = [[RuleViewController alloc]initWithRuleMin:0 ruleMax:50 delegate:self];
    [self.navigationController pushViewController:ruleVC animated:YES];
    //[self presentViewController:ruleVC animated:YES completion:nil];
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
