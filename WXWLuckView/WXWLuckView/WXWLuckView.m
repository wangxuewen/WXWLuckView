//
//  WXWLuckView.m
//  WXWLuckView
//
//  Created by administrator on 2018/8/29.
//  Copyright © 2018年 xuewen.wang. All rights reserved.
//

#import "WXWLuckView.h"

#import "UIImageView+WebCache.h"

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
    
@property (strong , nonatomic) UIImageView *backgroundImageView;
@property (assign, nonatomic) BOOL isImage;
@property (strong, nonatomic) NSMutableArray * btnArray;
@property (strong, nonatomic) UIButton * startBtn;
@property (assign, nonatomic) CGFloat time;

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
        currentTime = 0;
        self.isImage = YES;
        self.time = 0.1;
        _stopCount = 8; //默认为8
        stopTime = 79 + self.stopCount; //默认多转10圈（10*8-1=79）
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.backgroundImageView.image = [UIImage imageNamed:@"cjbj01"];
        [self addSubview:self.backgroundImageView];
        self.backgroundColor = [UIColor clearColor];
        
        imageTimer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(updataImage:) userInfo:nil repeats:YES];
    }
    return self;
}
    
    
- (void)updataImage:(NSTimer *)timer {
    self.isImage = !self.isImage;
    if (self.isImage == YES) {
        self.backgroundImageView.image = [UIImage imageNamed:@"cjbj02"];
    } else {
        self.backgroundImageView.image = [UIImage imageNamed:@"cjbj01"];
    }
}
    
- (void)setStopCount:(int)stopCount {
    if(_stopCount != stopCount) {
        _stopCount = stopCount;
        int turns = currentTime / 8; //圈数
        if(turns > 3) {
            stopTime = turns * 8 - 1 + _stopCount;
        } else { //小于3圈的时候默认三圈
            stopTime = 23 + _stopCount;
        }
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

- (void)initLuckViewSubViews {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[self.backgroundImageView subviews] count]) {
            [self.backgroundImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat topMarge = 15; //button距离顶部边距
        CGFloat leftMarge = 20; //button距离左边距
        CGFloat btnSpace = 0; //button之间的距离
        CGFloat imageW = 10; //button比较imageView的宽度差（边框的2倍）
        CGFloat btnw = (self.frame.size.width - imageW * 2 - leftMarge * 2 - btnSpace * 2)/3;
        CGFloat margeW = 5; // imageView与button的边框宽度
        
        NSArray *prizeImageArr = self.localImageArray ? : self.urlImageArray;
        
        for (int i = 0; i < prizeImageArr.count + 1; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
            shapeLayer.fillColor = [UIColor clearColor].CGColor;
            [btn.layer addSublayer:shapeLayer];
            
            CGFloat x = leftMarge + btnSpace * (i % 3) + (i % 3) * btnw + imageW;
            CGFloat y = topMarge + btnSpace * (i / 3) + (i / 3) * btnw + imageW;
            CGFloat width = btnw;
            CGFloat height = btnw;
            btn.frame = CGRectMake(x, y, width, height);
            btn.backgroundColor = [UIColor clearColor];
            btn.layer.cornerRadius = 5;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            self.backgroundImageView.userInteractionEnabled = YES;
            [self.backgroundImageView addSubview:btn];
            
            if (i == 4) {
                [btn setTitle:@"" forState:UIControlStateNormal];
                btn.frame = CGRectMake(btn.frame.origin.x + 5, btn.frame.origin.y + 5, btn.frame.size.width - 10, btn.frame.size.height - 10);
                [btn setBackgroundImage:[UIImage imageNamed:@"sub"] forState:UIControlStateNormal];
                btn.tag = 10;
                self.startBtn = btn;
                
                continue;
            }
            
            btn.tag = i > 4? i -1: i;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(margeW, margeW, btn.frame.size.width - margeW * 2, btn.frame.size.width - margeW * 2)];
            imageView.backgroundColor = [UIColor grayColor];
            [btn addSubview:imageView];
            if (self.localImageArray) {
                [imageView setImage:[UIImage imageNamed:[prizeImageArr objectAtIndex:i > 4? i -1: i]]];
            } else {
                [imageView sd_setImageWithURL:[prizeImageArr objectAtIndex:i > 4? i -1: i] placeholderImage:[UIImage imageNamed:@"cjbj02"]];
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
    if (btn.tag == 10) {
        //点击开始抽奖
        currentTime = result;
        self.time = 0.1;
        [self.startBtn setEnabled:NO];
        [self.startBtn setBackgroundImage:[UIImage imageNamed:@"subo"] forState:UIControlStateNormal];

        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            self->startTimer = [NSTimer scheduledTimerWithTimeInterval:self.time target:self selector:@selector(start:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] run];
        });
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
        oldBtn.backgroundColor = [UIColor clearColor];
        oldBtn.layer.opacity = 1;
        if(self.borderColor) {
            btn.layer.backgroundColor = self.borderColor.CGColor;
        } else {
            btn.layer.opacity = 0.3;
        }
    });

    if (currentTime > stopTime) {
        [timer invalidate];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.startBtn setEnabled:YES];
            [self.startBtn setImage:[UIImage imageNamed:@"sub"] forState:UIControlStateNormal];
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
    if ([self.delegate respondsToSelector:@selector(luckView:didStopWithArrayCount:)]) {
        [self.delegate luckView:self didStopWithArrayCount:count];
    }
}


- (void)showLotteryResults:(void (^)(void))clickSure {
    NSString *title;
    NSString *message;
    NSString *sureTitle;
    if (_stopCount == 8) {
        title = @"提示";
        message = [NSString stringWithFormat:@"%@", @"网络异常，请连接网络"];
    } else if (_stopCount == 7) {
        title = @"提示";
        message = @"大吉大利，明天再来";
    } else {
        title = @"中奖了";
        message = [NSString stringWithFormat:@"恭喜你获得了:“%@等奖”", [self translation:_stopCount]];
    }
    sureTitle = @"确定";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(alert) wAlert = alert;
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [wAlert dismissViewControllerAnimated:NO completion:nil];
        if (clickSure) {
            clickSure();
        }
    }];
    
    [alert addAction:sureAction];
    
    [[self viewController] presentViewController:alert animated:YES completion:nil];
}

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
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
    [startTimer invalidate];
}

@end
