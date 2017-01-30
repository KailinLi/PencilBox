//
//  PencilBox
//
//  Created by 李恺林 on 2017/1/21.
//  Copyright © 2017年 李恺林. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RuleTableViewCellModel.h"

typedef NS_ENUM(NSUInteger, RuleTableViewCellState) {
    RuleTableViewCellStateShort,
    RuleTableViewCellStateMiddle,
    RuleTableViewCellStateLong,
};

@interface RuleTableViewCell : UITableViewCell

@property(nonatomic,assign)NSInteger ruleTableViewCellState;

@property (weak, nonatomic) IBOutlet UILabel *ruleLabel;


@property (retain, nonatomic) IBOutlet UIImageView *cellNormalState;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellNormalRuleWidth;

- (void)configCell:(RuleTableViewCellModel*)model;


@end
