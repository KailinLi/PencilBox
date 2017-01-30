//
//  BubberPaint.m
//  PencilBox
//
//  Created by 李恺林 on 2017/1/21.
//  Copyright © 2017年 李恺林. All rights reserved.
//

#import "BubberPaint.h"
#import "UIView+ColorOfPoint.h"
#import <QuartzCore/QuartzCore.h>

#define screenX [UIScreen mainScreen].bounds.origin.x
#define screenY [UIScreen mainScreen].bounds.origin.y

#define width  [UIScreen mainScreen].bounds.size.width
#define height [UIScreen mainScreen].bounds.size.height

@implementation BubberPaint {
    
    //画的线路径的集合，内部是NSMutableArray类型
    NSMutableArray *paintSteps;
    //当前笔触粗细选择器
    UISlider *slider;
    
    
}

-(instancetype)init{
    self = [super init];
    if (self) {
        //初始化uiview的样式
        [self paintViewInit];
    }
    return  self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化uiview的样式
        [self paintViewInit];
    }
    return  self;
}

//初始化paintViewInit样式和数据
-(void)paintViewInit{
    
    //添加背景色
    self.backgroundColor = [UIColor clearColor];
    //初始化路径集合
    paintSteps = [[NSMutableArray alloc]init];
    
    

    self.currColor = [UIColor redColor];
    //创建色板
    //[self createColorBord];
    
    //创建笔触粗细选择器
    [self createStrokeWidthSlider];
    
}

//创建色板
-(void)createColorBord{
    self.currColor = [UIColor redColor];
    //色板的view
    UIView *colorBoardView = [[UIView alloc]initWithFrame:CGRectMake(0, height - 50, width, 20)];
    [self addSubview:colorBoardView];
    //色板样式
    colorBoardView.layer.borderWidth = 1;
    colorBoardView.layer.borderColor = [UIColor blackColor].CGColor;
    
    //创建每个色块
    NSArray *colors = [NSArray arrayWithObjects:
                       [UIColor blackColor],[UIColor redColor],[UIColor blueColor],
                       [UIColor greenColor],[UIColor yellowColor],[UIColor brownColor],
                       [UIColor orangeColor],[UIColor whiteColor],[UIColor orangeColor],
                       [UIColor purpleColor],[UIColor cyanColor],[UIColor lightGrayColor], nil];
    for (int i =0; i<colors.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((width/colors.count)*i, 0, width/colors.count, 20)];
        [colorBoardView addSubview:btn];
        [btn setBackgroundColor:colors[i]];
        [btn addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

//切换颜色
-(void)changeColor:(id)target{
    UIButton *btn = (UIButton *)target;
    self.currColor = [btn backgroundColor];
}

//创建笔触粗细选择器
-(void)createStrokeWidthSlider{
    slider = [[UISlider alloc]initWithFrame:CGRectMake(10, height - 40, width - 20, 20)];
    slider.maximumValue = 60;
    slider.minimumValue = 25;
    [self addSubview:slider];
}


-(void)drawRect:(CGRect)rect{
    //必须调用父类drawRect方法，否则 UIGraphicsGetCurrentContext()获取不到context
    [super drawRect:rect];
    //获取ctx
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //渲染所有路径
    for (int i=0; i<paintSteps.count; i++) {
        PaintStep *step = paintSteps[i];
        NSMutableArray *pathPoints = step->pathPoints;
        CGMutablePathRef path = CGPathCreateMutable();
        CGContextSetAllowsAntialiasing(ctx, true);
        for (int j=0; j<pathPoints.count; j++) {
            CGPoint point = [[pathPoints objectAtIndex:j]CGPointValue] ;
            if (j==0) {
                CGPathMoveToPoint(path, &CGAffineTransformIdentity, point.x,point.y);
            }else{
                CGPathAddLineToPoint(path, &CGAffineTransformIdentity, point.x, point.y);
            }
        }
        //设置path 样式
        CGContextSetStrokeColorWithColor(ctx, step->color);
        CGContextSetLineWidth(ctx, step->strokeWidth);
        //路径添加到ct
        CGContextAddPath(ctx, path);
        //描边
        CGContextStrokePath(ctx);
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //创建一个路径，放到paths里面
    //    NSMutableArray *path = [[NSMutableArray alloc]init];
    //    [paths addObject:path];
    
    PaintStep *paintStep = [[PaintStep alloc]init];
    paintStep->color = self.currColor.CGColor;
    paintStep->pathPoints =  [[NSMutableArray alloc]init];
    paintStep->strokeWidth = slider.value;
    [paintSteps addObject:paintStep];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //获取当前路径
    PaintStep *step = [paintSteps lastObject];
    NSMutableArray *pathPoints = step->pathPoints;
    //获取当前点
    CGPoint movePoint = [[touches anyObject]locationInView:self];
    NSLog(@"touchesMoved     x:%f,y:%f",movePoint.x,movePoint.y);

    //CGPint要通过NSValue封装一次才能放入NSArray
    [pathPoints addObject:[NSValue valueWithCGPoint:movePoint]];
    //通知重新渲染界面，这个方法会重新调用UIView的drawRect:(CGRect)rect方法
    [self setNeedsDisplay];
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
}





/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
