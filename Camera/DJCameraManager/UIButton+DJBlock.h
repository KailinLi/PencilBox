//
//  PencilBox
//
//  Created by 李恺林 on 2017/1/21.
//  Copyright © 2017年 李恺林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (DJBlock)
- (void)addActionBlock:(void(^)(id sender))block forControlEvents:(UIControlEvents )event;
@end
