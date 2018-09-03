//
//  WXWLuckView.h
//  WXWLuckView
//
//  Created by administrator on 2018/8/29.
//  Copyright © 2018年 xuewen.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXWLuckView.h"

@protocol LuckViewDelegate <NSObject>
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
 *  图片地址，网络获取
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

@property (assign, nonatomic) id<LuckViewDelegate> delegate;
/**
 * 奖项边框颜色，不设置默认无边框
 */
@property (strong, nonatomic) UIColor *borderColor;

/**
 *抽奖结果提示
 */
- (void)showLotteryResults:(void(^)(void))clickSure;


@end
