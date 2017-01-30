//
//  PencilBox
//
//  Created by 李恺林 on 2017/1/21.
//  Copyright © 2017年 李恺林. All rights reserved.
//

#import "RuleViewController.h"

#import "RuleTableViewCell.h"


@interface RuleViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *taleView;

@property(nonatomic,strong)NSMutableArray *sourceArray;

@property(nonatomic,assign)NSInteger       mistake;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation RuleViewController

- (instancetype)initWithRuleMin:(CGFloat)min ruleMax:(CGFloat)max delegate:(id)delegate
{
    self = [super init];
    if (self) {
        self.ruleMin = min;
        self.ruleMax = max;
        self.delegate = delegate;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.taleView registerNib:[UINib nibWithNibName:@"RuleTableViewCell" bundle:nil] forCellReuseIdentifier:@"RuleTableViewCell"];
    self.sourceArray = [NSMutableArray array];
    [self configSource];
    
    CGFloat screenHeight = CGRectGetHeight([UIApplication sharedApplication].keyWindow.bounds);
    
    UIEdgeInsets insets = UIEdgeInsetsMake(screenHeight - 229 - 74, 0, 229, 0);
    
    _taleView.contentInset = insets;
    _taleView.contentOffset = CGPointMake(0, -insets.top);
    
    [_taleView scrollsToTop];
}


- (void)configSource
{
    if (_ruleMin <=0 ) {
        _ruleMin = 0 ;
    }
    if (_ruleMax <= 0) {
        _ruleMax = 0;
    }
    if (_ruleMin >= _ruleMax) {
        _ruleMax = _ruleMin + 10 ;
    }
    _mistake = ((NSInteger)(_ruleMax - _ruleMin) + 1) * 10;
    
    CGFloat kRuleMin = _ruleMin;
    
    for (int i = _mistake; i >= 0; i --) {
        RuleTableViewCellModel *model = [[RuleTableViewCellModel alloc]init];
        model.rule = kRuleMin ;
        
        kRuleMin += 0.1;

        [_sourceArray addObject:model];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _sourceArray.count ;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RuleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RuleTableViewCell"];
    [cell configCell:_sourceArray[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 6.5;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat screenHeight = CGRectGetHeight([UIApplication sharedApplication].keyWindow.bounds);
    CGFloat offset =  scrollView.contentOffset.y + (screenHeight - 229 - 74);
    CGFloat rule = _ruleMin + offset*0.1/10 * 1.527;
    
    _messageLabel.text = [NSString stringWithFormat:@"%.2lf",rule];
    
    if ([_delegate respondsToSelector:@selector(ruleDidChange:)]) {
        [_delegate ruleDidChange:rule];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
