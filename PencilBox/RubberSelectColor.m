//
//  RubberSelectColor.m
//  PencilBox
//
//  Created by 李恺林 on 2017/1/21.
//  Copyright © 2017年 李恺林. All rights reserved.
//

#import "RubberSelectColor.h"
#import "UIView+ColorOfPoint.h"

@implementation RubberSelectColor


- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:self];
    self.color = [self colorOfPoint:location];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
