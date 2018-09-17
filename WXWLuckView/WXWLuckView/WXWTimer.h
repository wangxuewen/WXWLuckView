//
//  WXWTimer.h
//  WXWLuckView
//
//  Created by administrator on 2018/9/17.
//  Copyright © 2018年 xuewen.wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^WXWTimerBlock)(id userInfo);

@interface WXWTimer : NSObject

+ (NSTimer *) scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      target:(id)aTarget
                                    selector:(SEL)aSelector
                                    userInfo:(id)userInfo
                                     repeats:(BOOL)repeats;

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      block:(WXWTimerBlock)block
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)repeats;


@end
