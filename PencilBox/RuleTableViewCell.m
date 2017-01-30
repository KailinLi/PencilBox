//
//  PencilBox
//
//  Created by 李恺林 on 2017/1/21.
//  Copyright © 2017年 李恺林. All rights reserved.
//

#import "RuleTableViewCell.h"


@implementation RuleTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.ruleLabel.transform = CGAffineTransformRotate(self.ruleLabel.transform, -1 * M_PI_4);

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCell:(RuleTableViewCellModel*)model
{
    self.ruleTableViewCellState = [self stateWithNumber:model.rule];
    self.ruleLabel.text = [NSString stringWithFormat:@"%.0lf",model.rule ];
//    if ([self stateWithNumber:model.rule]) {
//        self.ruleTableViewCellState = [self stateWithNumber:model.rule];
//        self.ruleLabel.text = [NSString stringWithFormat:@"%.0lf",model.rule ];
//    }
//    else
//    {
//        self.ruleTableViewCellState = RuleTableViewCellStateShort;
//        self.ruleLabel.text = [NSString stringWithFormat:@"%.0lf",model.rule];
//    }
}

- (void)setRuleTableViewCellState:(NSInteger)ruleTableViewCellState
{
    _ruleTableViewCellState = ruleTableViewCellState;
     if (ruleTableViewCellState ==  RuleTableViewCellStateLong)
    {
        self.cellNormalState.hidden = NO;
        self.ruleLabel.hidden = NO;
        self.cellNormalRuleWidth.constant = 60;
    }
    else if (ruleTableViewCellState == RuleTableViewCellStateMiddle)
    {
        self.cellNormalState.hidden = NO;
        self.ruleLabel.hidden = YES;
        self.cellNormalRuleWidth.constant = 50;
    }
    else
    {
        self.cellNormalState.hidden = NO;
        self.ruleLabel.hidden = YES;
        self.cellNormalRuleWidth.constant = 30;
    }
}

- (RuleTableViewCellState)stateWithNumber:(CGFloat)number
{
    NSInteger tenMltiple = number * 10 ;
    if (tenMltiple % 10 == 0) {
        
        return RuleTableViewCellStateLong;
    }
    else
    {
        if (tenMltiple % 5 == 0) {
            return RuleTableViewCellStateMiddle;
        }
        else
        {
            return RuleTableViewCellStateShort;
        }
    }
}

@end
