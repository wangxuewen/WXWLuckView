//
//  TestViewController.m
//  WXWLuckView
//
//  Created by administrator on 2018/9/13.
//  Copyright © 2018年 xuewen.wang. All rights reserved.
//

#import "TestViewController.h"
#import "WXWLuckView.h"
#import "LotteryRuleViewController.h"

#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)

@interface TestViewController ()<LuckViewDelegate>

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    if (@available(iOS 11.0, *)) {
//        self.view.contentInsetAdjustmentBehavior =     UIScrollViewContentInsetAdjustmentNever;
//    } else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
        
    [self settingLuckView];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)settingLuckView {
    WXWLuckView *luckView = [[WXWLuckView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    luckView.center = self.view.center;
    
    //网络图片地址
    //    luckView.urlImageArray = [@[@"http://oquujevnh.bkt.clouddn.com/first.jpg",
    //                             @"http://oquujevnh.bkt.clouddn.com/second.jpg",
    //                             @"http://oquujevnh.bkt.clouddn.com/third.jpg",
    //                             @"http://oquujevnh.bkt.clouddn.com/fourth.jpg",
    //                             @"http://oquujevnh.bkt.clouddn.com/fifth.jpg",
    //                             @"http://oquujevnh.bkt.clouddn.com/sixth.jpg",
    //                             @"http://oquujevnh.bkt.clouddn.com/seventh.jpg",
    //                             @"http://oquujevnh.bkt.clouddn.com/eighth.jpg"]mutableCopy];
    //本地图片
    luckView.localImageArray = [@[@"v1.2.1_1天",
                                  @"v1.2.1_5天",
                                  @"v1.2.1_7天",
                                  @"v1.2.1_月卡",
                                  @"v1.2.1_季卡",
                                  @"v1.2.1_年卡",
                                  @"v1.2.1_永久",
                                  @"v1.2.1_大吉大利"] mutableCopy];
    //抽奖结果提示信息
    luckView.lotteryArray = @[@"加速器 1天",
                              @"加速器 5天",
                              @"加速器 7天",
                              @"加速器 月卡",
                              @"加速器 季卡",
                              @"加速器 年卡",
                              @"永久免费卡",
                              @"大吉大利，明天再来",];
    //超时时间
    luckView.timeoutInterval = 11;
    //指定抽奖结果,对应数组中的元素
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        luckView.stopCount = 1;
    });
//    luckView.networkStatus = 0; //无网络
    //设置抽奖次数
    luckView.lotteryNumber = 5;
    //设置代理
    luckView.delegate = self;
    [self.view addSubview:luckView];
}



#pragma mark - LuckViewDelegate
/**
 * 开始抽奖
 */
- (void)startDrawLottery {
    NSLog(@"开始抽奖");
}

/**
 * 中奖
 *
 *@param count 返回结果数组的下标
 */
- (void)luckView:(UIView *)luckView didStopWithArrayCount:(NSInteger)count{
    NSLog(@"抽到了第%ld个",(long)count);
    WXWLuckView *luck = (WXWLuckView *)luckView;
    
    __weak typeof(self)weakSelf = self;
    [luck showLotteryResults:^(NSInteger remainTime) {
        NSLog(@"点击确认");
        if (remainTime == 0) { //次数用完啦，少年赶快去充值吧
            [weakSelf dismissViewControllerAnimated:NO completion:nil];
        }
    }];
    
}


/**
 * 点击了数组中的第几个元素
 *
 * @param button 点击了第几个奖品
 */
- (void)luckSelectBtn:(UIButton *)button {
    NSLog(@"点击了数组中的第%ld个元素",(long)button.tag);
    
}

/**
 * 点击了抽奖规则
 */
- (void)touchLotteryRule {
    [self.navigationController pushViewController:[LotteryRuleViewController new] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
