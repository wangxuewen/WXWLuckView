//
//  WXWLuckView.h
//  WXWLuckView
//
//  Created by administrator on 2018/8/29.
//  Copyright © 2018年 xuewen.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXWLuckView.h"

typedef NS_ENUM(NSInteger, NetworkStatus) {
    NetworkStatusUnknown = -1, //未知网络
    NetworkStatusNotReachable = 0, //无网络
    NetworkStatusReachableViaWWAN = 1, //运营商网络
    NetworkStatusReachableViaWiFi = 2, //无线网络

};

@protocol LuckViewDelegate <NSObject>
/**
 * 开始抽奖
 */
- (void)startDrawLottery;

/**
 * 奖项停止的位置
 */
- (void)luckView:(UIView *)luckView didStopWithArrayCount:(NSInteger)count;
/**
 * 点击了奖项
 */
- (void)luckSelectBtn:(UIButton *)button;
    
@end

@interface WXWLuckView : UIView

/**
 * 网络状态，无网络直接提示相应信息
 */
@property (assign, nonatomic) NetworkStatus networkStatus;
/**
 * 图片地址，网络获取
 */
@property (strong, nonatomic) NSMutableArray *urlImageArray;
/**
 * 本地图片数组
 */
@property (strong, nonatomic) NSMutableArray *localImageArray;
/**
 * 停止位置，默认第一个
 */
@property (assign, nonatomic) int stopCount;
/**
 * 抽奖视图超时时间,默认10秒（以网络请求的超时为主，超时间默认加2以上，用于选中之后的延时弹出提示框带来的影响）
 */
@property (assign, nonatomic) int timeoutInterval;

@property (assign, nonatomic) id<LuckViewDelegate> delegate;
/**
 * 抽奖次数
 */
@property (assign, nonatomic) int lotteryNumber;
/**
 * 抽奖次数背景色
 */
@property (strong, nonatomic) UIColor *lotteryBgColor;
/**
 * 奖品, 抽奖完成后提示信息
 */
@property (copy, nonatomic) NSArray *lotteryArray;
/**
 * 抽奖失败后提示信息
 */
@property (copy, nonatomic) NSString *failureMessage;
/**
 *抽奖结果提示
 */
- (void)showLotteryResults:(void(^)(NSInteger remainTime))clickSure;


@end
