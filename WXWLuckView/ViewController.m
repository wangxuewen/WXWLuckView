//
//  ViewController.m
//  WXWLuckView
//
//  Created by administrator on 2018/8/29.
//  Copyright © 2018年 xuewen.wang. All rights reserved.
//

#import "ViewController.h"
#import "WXWLuckView.h"

#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)


@interface ViewController ()<LuckViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadLuckView];
}
    
- (void)loadLuckView {
    WXWLuckView *luckView = [[WXWLuckView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    luckView.center = self.view.center;
    
    //网络图片地址
    luckView.urlImageArray = [@[@"http://oquujevnh.bkt.clouddn.com/first.jpg",
                             @"http://oquujevnh.bkt.clouddn.com/second.jpg",
                             @"http://oquujevnh.bkt.clouddn.com/third.jpg",
                             @"http://oquujevnh.bkt.clouddn.com/fourth.jpg",
                             @"http://oquujevnh.bkt.clouddn.com/fifth.jpg",
                             @"http://oquujevnh.bkt.clouddn.com/sixth.jpg",
                             @"http://oquujevnh.bkt.clouddn.com/seventh.jpg",
                             @"http://oquujevnh.bkt.clouddn.com/eighth.jpg"]mutableCopy];
    //指定抽奖结果,对应数组中的元素
    luckView.stopCount = 5;
//    luckView.borderColor = [UIColor grayColor];
    //设置代理
    luckView.delegate = self;
    [self.view addSubview:luckView];
}
   
    

#pragma mark - LuckViewDelegate
/**
 * 中奖
 *
 *@param count 返回结果数组的下标
 */
- (void)luckView:(UIView *)luckView didStopWithArrayCount:(NSInteger)count{
    NSLog(@"抽到了第%ld个",(long)count);
    WXWLuckView *luck = (WXWLuckView *)luckView;
    [luck showLotteryResults:^{
        NSLog(@"点击确认");
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
