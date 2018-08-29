//
//  WXWLuckView.h
//  WXWLuckView
//
//  Created by administrator on 2018/8/29.
//  Copyright © 2018年 xuewen.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LuckViewDelegate <NSObject>
    
- (void)luckViewDidStopWithArrayCount:(NSInteger)count;
- (void)luckSelectBtn:(UIButton *)button;
    
    @end

@interface WXWLuckView : UIView

/**
 *  图片地址，网络获取
 */
@property (strong, nonatomic) NSMutableArray *urlImageArray;
@property (strong, nonatomic) NSMutableArray *localImageArray;
@property (assign, nonatomic) int stopCount;
@property (assign, nonatomic) id<LuckViewDelegate> delegate;
    
@end
