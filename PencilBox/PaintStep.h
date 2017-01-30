//
//  PaintStep.h
//  PencilBox
//
//  Created by 李恺林 on 2017/1/21.
//  Copyright © 2017年 李恺林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PaintStep : NSObject {
    
@public
    //路径
    NSMutableArray *pathPoints;
    //颜色
    CGColorRef color;
    //笔画粗细
    float strokeWidth;
}

@end

