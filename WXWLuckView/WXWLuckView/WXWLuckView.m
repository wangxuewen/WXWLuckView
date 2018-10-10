//
//  WXWLuckView.m
//  WXWLuckView
//
//  Created by administrator on 2018/8/29.
//  Copyright © 2018年 xuewen.wang. All rights reserved.
//

#import "WXWLuckView.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "WXWTimer.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define kDevice_Is_iPhoneX [UIScreen mainScreen].bounds.size.height == 812
#define nav_height (kDevice_Is_iPhoneX?88:64)

@interface WXWLuckView () {
    NSTimer *imageTimer;
    NSTimer *startTimer;
    
    int currentTime;
    int stopTime;
    int result;
    
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
    UIButton *btn4;
    UIButton *btn5;
    UIButton *btn6;
    UIButton *btn7;
    UIButton *btn0;
}
    
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIImageView *borderImageView;
@property (assign, nonatomic) BOOL isImage;
@property (strong, nonatomic) NSMutableArray * btnArray;
@property (strong, nonatomic) UIButton * startBtn;
@property (assign, nonatomic) CGFloat time;

@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UILabel *lotteryNumberLabel;
@property (assign, nonatomic) BOOL TimeoutFlag;

@property (strong, nonatomic) UIButton *lotteryRuleButton;

@end

@implementation WXWLuckView

- (NSMutableArray *)btnArray {
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}
    
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        currentTime = 0;
        self.isImage = YES;
        self.time = 0.1;
        _stopCount = 7; //默认为7
        self.lotteryNumber = 1; //默认次数为1
        self.timeoutInterval = 10;
        stopTime = 8 * (self.timeoutInterval + 2) - 1 + self.stopCount; //默认多转10圈+2圈（10*8-1=79）
        self.lotteryBgColor = [UIColor grayColor];
        self.failureMessage = @"网络异常，请连接网络";
        self.networkStatus = NetworkStatusUnknown; //默认未知网络
        
        self.backgroundImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

        [self addSubview:self.backgroundImageView];
        
        self.backButton.frame = CGRectMake(SCREEN_WIDTH - 5 - 40, nav_height - 20 -40, 40, 40);
        [self.backButton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [self.backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.backButton];
        [self bringSubviewToFront:self.backButton];

        self.borderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT / 3, SCREEN_WIDTH - 40, (SCREEN_WIDTH - 40) * 19 / 16)];
        self.borderImageView.image = [UIImage imageNamed:@"v1.2.1_框"];
        self.borderImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.backgroundImageView addSubview:self.borderImageView];

        CGFloat margeLeft = (SCREEN_WIDTH - 40) / 7;
        self.lotteryNumberLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.backgroundImageView addSubview:self.lotteryNumberLabel];
        [self.backgroundImageView bringSubviewToFront:self.lotteryNumberLabel];

        self.lotteryRuleButton.frame = CGRectMake(SCREEN_WIDTH / 2 - 50, SCREEN_HEIGHT / 3 - 45, 100, 30);
        self.lotteryRuleButton.userInteractionEnabled = YES;
        [self.lotteryRuleButton addTarget:self action:@selector(touchRuleAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.lotteryRuleButton];
        [self bringSubviewToFront:self.lotteryRuleButton];

        NSMutableArray *constraints = [NSMutableArray array];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.lotteryNumberLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.borderImageView attribute:NSLayoutAttributeHeight multiplier:0.059 constant:0.0]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.lotteryNumberLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.borderImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:margeLeft]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.lotteryNumberLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.borderImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-55]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.lotteryNumberLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.borderImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-margeLeft]];
        [self.backgroundImageView addConstraints:constraints];
        
        imageTimer = [WXWTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(updataImage:) userInfo:nil repeats:YES];
    }
    return self;
}
    

//背景图切换
- (void)updataImage:(NSTimer *)timer {
    self.isImage = !self.isImage;
    if (self.isImage == YES) {
        self.borderImageView.image = [UIImage imageNamed:@"v1.2.1_框1"];
    } else {
        self.borderImageView.image = [UIImage imageNamed:@"v1.2.1_框"];
    }
}


#pragma mark -Setter
- (void)setNetworkStatus:(NetworkStatus)networkStatus {
    if (_networkStatus != networkStatus) {
        _networkStatus = networkStatus;
    }
}

- (void)setStopCount:(int)stopCount {
    _stopCount = stopCount;
    int turns = currentTime / 8; //圈数
    if(turns > 3) {
        stopTime = turns * 8 - 1 + _stopCount;
    } else { //小于3圈的时候默认三圈
        stopTime = 23 + _stopCount;
    }

    NSLog(@"计算出来的停止时间：%d, 当前时间：%d", stopTime, currentTime);
}

- (void)setTimeoutInterval:(int)timeoutInterval {
    if (_timeoutInterval != timeoutInterval) {
        _timeoutInterval = timeoutInterval;
        stopTime = 8 * (timeoutInterval + 2) - 1 + self.stopCount; //默认多转10圈（10*8-1=79）
    }
}

- (void)setLocalImageArray:(NSMutableArray *)localImageArray {
    _urlImageArray = nil;
    _localImageArray = localImageArray;
    [self initLuckViewSubViews];
}
    
- (void)setUrlImageArray:(NSMutableArray *)urlImageArray {
    _localImageArray = nil;
    _urlImageArray = urlImageArray;
    [self initLuckViewSubViews];
}


- (void)setLotteryNumber:(int)lotteryNumber {
    if (_lotteryNumber != lotteryNumber) {
        _lotteryNumber = lotteryNumber;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.lotteryNumberLabel.text = [NSString stringWithFormat:@"当前剩余抽奖次数:%d次",  self.lotteryNumber];
        });
    }
}

- (void)setLotteryBgColor:(UIColor *)lotteryBgColor {
    if (_lotteryBgColor != lotteryBgColor) {
        _lotteryBgColor = lotteryBgColor;
        _lotteryNumberLabel.backgroundColor = lotteryBgColor;
    }
}

- (void)setLotteryArray:(NSArray *)lotteryArray {
    if (_lotteryArray != lotteryArray) {
        _lotteryArray = [lotteryArray copy];
    }
}

- (void)setFailureMessage:(NSString *)failureMessage {
    if (![_failureMessage isEqualToString:failureMessage]) {
        _failureMessage = failureMessage;
    }
}


- (void)initLuckViewSubViews {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[self.borderImageView subviews] count]) {
            [self.borderImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat topMarge = (SCREEN_WIDTH - 40) * 3 / 28 + 3; //button距离顶部边距, 2为btn到黑边框距离
        CGFloat leftMarge = (SCREEN_WIDTH - 40) / 7 + 2; //button距离左边距, 2为btn到黑边框距离
        CGFloat btnSpace = 1.5f; //button之间的距离
        CGFloat btnw = (SCREEN_WIDTH - 20 * 2 - leftMarge * 2 - btnSpace * 2)/3;
        CGFloat margeW = 0; // imageView与button的边框宽度
        
        NSArray *prizeImageArr = self.localImageArray ? : self.urlImageArray;
        
        for (int i = 0; i < prizeImageArr.count + 1; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(margeW, margeW, margeW, margeW)];

            CGFloat x = leftMarge + btnSpace * (i % 3) + (i % 3) * btnw;
            CGFloat y = topMarge + btnSpace * (i / 3) + (i / 3) * btnw;
            CGFloat width = btnw;
            CGFloat height = btnw;
            btn.frame = CGRectMake(x, y, width, height);
            [btn setImage:[UIImage imageNamed:@"v1.2.1_抽奖高亮"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            self.borderImageView.userInteractionEnabled = YES;
            [self.borderImageView addSubview:btn];
            
            if (i == 4) {
                [btn setTitle:@"" forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"v1.2.1_抽奖按钮"] forState:UIControlStateNormal];
                btn.tag = 10;
                self.startBtn = btn;
                
                continue;
            }
            
            btn.tag = i > 4? i -1: i;
            if (self.urlImageArray) {
                [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:[prizeImageArr objectAtIndex:i > 4? i -1: i]] forState:UIControlStateNormal];
            } else {
                [btn setBackgroundImage:[UIImage imageNamed:[prizeImageArr objectAtIndex:i > 4? i -1: i]] forState:UIControlStateNormal];
            }
        
            switch (i) {
                case 0:
                    self->btn0 = btn;
                    break;
                case 1:
                    self->btn1 = btn;
                    break;
                case 2:
                    self->btn2 = btn;
                    break;
                case 3:
                    self->btn3 = btn;
                    break;
                case 5:
                    self->btn4 = btn;
                    break;
                case 6:
                    self->btn5 = btn;
                    break;
                case 7:
                    self->btn6= btn;
                    break;
                case 8:
                    self->btn7 = btn;
                    break;
                    
                default:
                    
                    break;
            }
            
            [self.btnArray addObject:btn];
        }
        
        [self TradePlacesWithBtn1:self->btn3 btn2:self->btn4];
        [self TradePlacesWithBtn1:self->btn4 btn2:self->btn7];
        [self TradePlacesWithBtn1:self->btn5 btn2:self->btn6];
    });
    
}
    
- (void)btnClick:(UIButton *)btn {
    if (_networkStatus == NetworkStatusNotReachable) {
        self.stopCount = 8;
        [self showLotteryResults:^(NSInteger remainTime) {
            
        }];
        return;
    }
    if (btn.tag == 10) {
        //点击开始抽奖
        currentTime = result;
        self.time = 0.1;
        [self.startBtn setEnabled:NO];
        [self.backButton setEnabled:NO];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            self->startTimer = [NSTimer scheduledTimerWithTimeInterval:self.time target:self selector:@selector(start:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] run];
        });
        if ([self.delegate respondsToSelector:@selector(startDrawLottery)]) {
            [self.delegate startDrawLottery];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(luckSelectBtn:)]) {
            [self.delegate luckSelectBtn:btn];
        }
    }
}
    
- (void)start:(NSTimer *)timer {
    UIButton *oldBtn = [self.btnArray objectAtIndex:currentTime % self.btnArray.count];
    currentTime++;
    UIButton *btn = [self.btnArray objectAtIndex:currentTime % self.btnArray.count];
    dispatch_async(dispatch_get_main_queue(), ^{
        oldBtn.selected = NO;
        btn.selected = YES;
    });

    NSLog(@"当前时间：%d, 停止时间：%d", currentTime, stopTime);
    if (currentTime > stopTime) { //抽奖结果
        NSLog(@"抽到的位置：%d， stopTime：%d", self.stopCount, stopTime);
        self.TimeoutFlag = (stopTime == 8 * (self.timeoutInterval + 2) - 1 + self.stopCount) ? YES : NO;
        [timer invalidate];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.startBtn setEnabled:YES];
            [self.backButton setEnabled:YES];
        });
        result = currentTime%self.btnArray.count;
        [self stopWithCount:currentTime%self.btnArray.count];
        
        return;
    }
    
    if (currentTime > stopTime - 10) {
        self.time += 0.01 * (currentTime + 10 - stopTime); //动画效果由快变慢
        [timer invalidate];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            self->startTimer = [NSTimer scheduledTimerWithTimeInterval:self.time target:self selector:@selector(start:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] run];
        });
    }
}
    
    
- (void)stopWithCount:(NSInteger)count {
    WXWLuckView *luckSelf = self;
    if ([luckSelf.delegate respondsToSelector:@selector(luckView:didStopWithArrayCount:)]) {
        if (!luckSelf.TimeoutFlag) {
            luckSelf.lotteryNumber = luckSelf.lotteryNumber - 1;
        }
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [luckSelf.delegate luckView:luckSelf didStopWithArrayCount:count];
        });
    }
}


- (void)showLotteryResults:(void(^)(NSInteger remainTime))clickSure {
    NSString *title;
    NSString *message;
    NSString *sureTitle;
    if (_stopCount == 8) {
        title = @"提示";
        message = self.failureMessage;
    } else if (_stopCount == 7) {
        title = @"提示";
        message = [NSString stringWithFormat:@"%@", self.TimeoutFlag ? self.failureMessage : @"大吉大利，明天再来"];
    } else {
        title = @"中奖了";
        if (self.lotteryArray) {
            message = [NSString stringWithFormat:@"恭喜你获得了:“%@”", _lotteryArray[_stopCount]];
        } else {
            message = [NSString stringWithFormat:@"恭喜你获得了:“%@等奖”", [self translation:_stopCount]];
        }
    }
    sureTitle = @"确定";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(alert) wAlert = alert;
    __weak typeof(self) wSelf = self;
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [wAlert dismissViewControllerAnimated:NO completion:nil];
        if (clickSure) {
            clickSure(wSelf.lotteryNumber);
        }
    }];
    
    [alert addAction:sureAction];
    
    [[self viewController] presentViewController:alert animated:YES completion:nil];
}

#pragma mark -method
- (void)backAction {
    if ([self viewController].presentingViewController) {
        [[self viewController] dismissViewControllerAnimated:NO completion:nil];
    } else {
        [[self viewController].navigationController popViewControllerAnimated:NO];
    }
}

- (void)touchRuleAction {
    if ([self.delegate respondsToSelector:@selector(touchLotteryRule)]) {
        [self.delegate touchLotteryRule];
    }
}

#pragma mark - Getter
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.userInteractionEnabled = YES;
        _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
//        _backgroundImageView.image = [UIImage imageNamed:@"v1.2.1_全面屏背景"];
        NSString *path = [NSString stringWithFormat:@"%@@%@x", @"v1.2.1_全面屏背景", @([UIScreen mainScreen].scale)];
        _backgroundImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:path ofType:@"png"]];

    }
    return _backgroundImageView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"v1.2.1_关闭"] forState:UIControlStateNormal];
    }
    return _backButton;
}

-(UILabel *)lotteryNumberLabel {
    if (!_lotteryNumberLabel) {
        _lotteryNumberLabel = [[UILabel alloc] init];
        _lotteryNumberLabel.font = [UIFont systemFontOfSize:15];
        _lotteryNumberLabel.textAlignment = NSTextAlignmentCenter;
        _lotteryNumberLabel.text = [NSString stringWithFormat:@"当前剩余抽奖次数:%d次",  self.lotteryNumber];
        _lotteryNumberLabel.textColor = [UIColor whiteColor];
        _lotteryNumberLabel.backgroundColor = self.lotteryBgColor;
    }
    return _lotteryNumberLabel;
}

- (UIButton *)lotteryRuleButton {
    if (!_lotteryRuleButton) {
        _lotteryRuleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSMutableAttributedString *ruleStr = [[NSMutableAttributedString alloc] initWithString:@"抽奖规则"];
        [ruleStr addAttribute:NSUnderlineStyleAttributeName
                          value:@(NSUnderlineStyleSingle)
                          range:(NSRange){0,[ruleStr length]}];
        [ruleStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(0, [ruleStr length])];
        //此时如果设置字体颜色要这样
        [ruleStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]  range:NSMakeRange(0,[ruleStr length])];
        
        //设置下划线颜色...
        [ruleStr addAttribute:NSUnderlineColorAttributeName value:[UIColor whiteColor] range:(NSRange){0,[ruleStr length]}];
        [_lotteryRuleButton setAttributedTitle:ruleStr forState:UIControlStateNormal];
    }
    return _lotteryRuleButton;
}
    
- (void)TradePlacesWithBtn1:(UIButton *)firstBtn btn2:(UIButton *)secondBtn {
    CGRect frame = firstBtn.frame;
    firstBtn.frame = secondBtn.frame;
    secondBtn.frame = frame;
}

-(NSString*)translation:(int)arebic{
    if ([self isCurrentLanguageChinese]) {
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        nf.numberStyle = NSNumberFormatterSpellOutStyle;
        NSString *str = [nf stringFromNumber:[NSNumber numberWithInt:arebic]];
        return str;
    } else {
        NSString *str = [NSString stringWithFormat:@"%d", arebic];
        NSArray *arabic_numerals = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
        NSArray *chinese_numerals = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
        NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chinese_numerals forKeys:arabic_numerals];
        
        NSMutableArray *sums = [NSMutableArray array];
        
        for (int i = 0; i < str.length; i ++) {
            NSString *substr = [str substringWithRange:NSMakeRange(i, 1)];
            NSString *a = [dictionary objectForKey:substr];
            NSString *b = digits[str.length -i-1];
            NSString *sum = [a stringByAppendingString:b];
            
            if ([a isEqualToString:chinese_numerals[9]]) {
                if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]]) {
                    sum = b;
                    if ([[sums lastObject] isEqualToString:chinese_numerals[9]]) {
                        [sums removeLastObject];
                    }
                }else {
                    sum = chinese_numerals[9];
                }
                if ([[sums lastObject] isEqualToString:sum]) {
                    continue;
                }
            }
            [sums addObject:sum];
        }
        NSString *sumStr = [sums  componentsJoinedByString:@""];
        NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
        NSLog(@"%@ to %@",str,chinese);
        return chinese;
    }
}

-(NSString *)getCurrentLabguage {
    NSArray *languages = [NSLocale preferredLanguages];
    
    if(languages == nil){
        return nil;
    }else{
        if([languages count] == 0){
            return nil;
        }else{
            NSString *currentLanguage = [languages objectAtIndex:0];
            return currentLanguage;
        }
    }
}


/*
 *判断当前是否为中文
 zh-Hans-CN,
 zh-Hant-CN,
 en-CN,
 ko-CN
 */
-(BOOL)isCurrentLanguageChinese {
    NSString *currentLanguage = [self getCurrentLabguage];
    if(currentLanguage == nil){
        return NO;
    }else if([currentLanguage isEqualToString:@""]){
        return NO;
    }

    
    NSRange subStrRange = [currentLanguage rangeOfString:@"zh-Hans"];
    if(subStrRange.length >0){
        //简体中文
        return YES;
    }

    subStrRange = [currentLanguage rangeOfString:@"zh-Hant"];
    if(subStrRange.length >0){
        //繁体中文
        return YES;
    }
    //其他语言
    return NO;
}

    
- (void)dealloc {
    [imageTimer invalidate];
    imageTimer = nil;
    [startTimer invalidate];
    startTimer = nil;
}

@end
