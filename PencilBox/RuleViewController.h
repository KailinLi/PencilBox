//
//  PencilBox
//
//  Created by 李恺林 on 2017/1/21.
//  Copyright © 2017年 李恺林. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RuleViewControllerRuleChangeDelegate <NSObject>

- (void)ruleDidChange:(CGFloat)current;

@end


@interface RuleViewController : UIViewController


@property(nonatomic,assign)id delegate;

@property(nonatomic,assign)CGFloat ruleMin;
@property(nonatomic,assign)CGFloat ruleMax;

- (instancetype)initWithRuleMin:(CGFloat)min ruleMax:(CGFloat)max delegate:(id)delegate;



@end
