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
    
    @property (strong , nonatomic) UIImageView *iv;
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
        stopTime = 63 + self.stopCount;
        self.iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.iv.image = [UIImage imageNamed:@"cjbj01"];
        [self addSubview:self.iv];
        
        imageTimer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(updataImage:) userInfo:nil repeats:YES];
    }
    return self;
}
    
    
- (void)updataImage:(NSTimer *)timer {
    self.isImage = !self.isImage;
    if (self.isImage == YES) {
        self.iv.image = [UIImage imageNamed:@"cjbj02"];
    } else {
        self.iv.image = [UIImage imageNamed:@"cjbj01"];
    }
}
    
- (void)setStopCount:(int)stopCount {
    _stopCount = stopCount;
    stopTime = 63 + _stopCount;
}
    
- (void)setUrlImageArray:(NSMutableArray *)urlImageArray {
    _urlImageArray = urlImageArray;
    CGFloat yj = 15;
    CGFloat j = 20;
    CGFloat upj = 5;
    CGFloat imageW = 10;
    CGFloat btnw = (self.frame.size.width - imageW * 2 - j * 2 - upj * 2)/3;
    CGFloat ivj = 5;
    
    for (int i = 0; i < urlImageArray.count + 1; i++) {
        UIButton *btn = [[UIButton alloc] init];
        CGFloat x = j + upj * (i % 3) + (i % 3) * btnw + imageW;
        CGFloat y = yj + upj * (i / 3) + (i / 3) * btnw + imageW;
        CGFloat width = btnw;
        CGFloat height = btnw;
        btn.frame = CGRectMake(x, y, width, height);
        btn.backgroundColor = [UIColor clearColor];
        btn.layer.cornerRadius = 5;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.iv.userInteractionEnabled = YES;
        [self.iv addSubview:btn];
        
        if (i == 4) {
            [btn setTitle:@"开始" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            btn.layer.cornerRadius = 10;
            [btn setImage:[UIImage imageNamed:@"sub"] forState:UIControlStateNormal];
            btn.tag = 10;
            self.startBtn = btn;
            
            continue;
        }
        
        btn.tag = i > 4? i -1: i;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ivj, ivj, btn.frame.size.width - ivj * 2, btn.frame.size.width - ivj * 2)];
        [btn addSubview:imageView];
        [imageView sd_setImageWithURL:[_urlImageArray objectAtIndex:i > 4? i -1: i] placeholderImage:[UIImage imageNamed:@"cjbj02"]];
        
        switch (i) {
            case 0:
            btn0 = btn;
            break;
            case 1:
            btn1 = btn;
            break;
            case 2:
            btn2 = btn;
            break;
            case 3:
            btn3 = btn;
            break;
            case 5:
            btn4 = btn;
            break;
            case 6:
            btn5 = btn;
            break;
            case 7:
            btn6= btn;
            break;
            case 8:
            btn7 = btn;
            break;
            
            default:
            
            break;
        }
        
        [self.btnArray addObject:btn];
    }
    
    [self TradePlacesWithBtn1:btn3 btn2:btn4];
    [self TradePlacesWithBtn1:btn4 btn2:btn7];
    [self TradePlacesWithBtn1:btn5 btn2:btn6];
}
    
- (void)btnClick:(UIButton *)btn {
    if (btn.tag == 10) {
        //点击开始抽奖
        
        currentTime = result;
        self.time = 0.1;
        stopTime = 63 + self.stopCount;
        [self.startBtn setEnabled:NO];
        [self.startBtn setImage:[UIImage imageNamed:@"subo"] forState:UIControlStateNormal];
        
        startTimer = [NSTimer scheduledTimerWithTimeInterval:self.time target:self selector:@selector(start:) userInfo:nil repeats:YES];
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            self.stopCount = 7;
        });
        
    } else {
        if ([self.delegate respondsToSelector:@selector(luckSelectBtn:)]) {
            [self.delegate luckSelectBtn:btn];
        }
    }
}
    
- (void)start:(NSTimer *)timer {
    UIButton *oldBtn = [self.btnArray objectAtIndex:currentTime % self.btnArray.count];
    oldBtn.backgroundColor = [UIColor clearColor];
    currentTime++;
    UIButton *btn = [self.btnArray objectAtIndex:currentTime % self.btnArray.count];
    btn.backgroundColor = [UIColor orangeColor];
    
    
    if (currentTime > stopTime) {
        [timer invalidate];
        [self.startBtn setEnabled:YES];
        [self.startBtn setImage:[UIImage imageNamed:@"sub"] forState:UIControlStateNormal];
        result = currentTime%self.btnArray.count;
        [self stopWithCount:currentTime%self.btnArray.count];
        
        return;
    }
    
    if (currentTime > stopTime - 10) {
        self.time += 0.1;
        
        [timer invalidate];
        
        startTimer = [NSTimer scheduledTimerWithTimeInterval:self.time target:self selector:@selector(start:) userInfo:nil repeats:YES];
    }
}
    
    
- (void)stopWithCount:(NSInteger)count {
    if ([self.delegate respondsToSelector:@selector(luckViewDidStopWithArrayCount:)]) {
        [self.delegate luckViewDidStopWithArrayCount:count];
    }
}
    
    
- (void)TradePlacesWithBtn1:(UIButton *)firstBtn btn2:(UIButton *)secondBtn {
    CGRect frame = firstBtn.frame;
    firstBtn.frame = secondBtn.frame;
    secondBtn.frame = frame;
}
    
- (void)dealloc {
    [imageTimer invalidate];
    [startTimer invalidate];
}

@end
