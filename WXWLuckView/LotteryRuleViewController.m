//
//  LotteryRuleViewController.m
//  WXWLuckView
//
//  Created by administrator on 2018/10/10.
//  Copyright © 2018年 xuewen.wang. All rights reserved.
//

#import "LotteryRuleViewController.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define kDevice_Is_iPhoneX [UIScreen mainScreen].bounds.size.height == 812
#define nav_height (kDevice_Is_iPhoneX?88:64)
#define ColorFromHexValue(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]


@interface LotteryRuleViewController ()

@property (strong, nonatomic) UILabel *ruleLabel;

@end

@implementation LotteryRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.presentingViewController) {
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"v1.2.1_返回按钮"] style:UIBarButtonItemStyleDone target:self action:@selector(backToLastVCAction)]];
        self.navigationItem.leftBarButtonItem.tintColor = ColorFromHexValue(0x363636);
    }
    
    
    [self.view addSubview:self.ruleLabel];
    NSString *ruleText = self.ruleString ? : @"1.本次活动用户每天登录后既获得一次抽奖机会；\n2.A+可以根据活动的实际情况对活动规则进行变动和调整，解释权归A+所有；\n3.此活动与苹果公司无关。";
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:ruleText];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, ruleText.length)];
    [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, ruleText.length)]; NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attributeString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT) options:options context:nil];
    
    self.ruleLabel.frame = CGRectMake(15, nav_height + 15, SCREEN_WIDTH - 30, rect.size.height);
    self.ruleLabel.attributedText = attributeString;
    
    self.title = @"抽奖规则";
}

#pragma mark - method
- (void)backToLastVCAction {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:NO completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

#pragma mark - Getter
- (UILabel *)ruleLabel {
    if (!_ruleLabel) {
        _ruleLabel = [[UILabel alloc] init];
        _ruleLabel.textColor = [UIColor grayColor];
        _ruleLabel.numberOfLines = 0;
        
    }
    return _ruleLabel;
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
