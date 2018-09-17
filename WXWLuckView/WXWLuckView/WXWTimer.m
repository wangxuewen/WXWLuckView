//
//  WXWTimer.m
//  WXWLuckView
//
//  Created by administrator on 2018/9/17.
//  Copyright © 2018年 xuewen.wang. All rights reserved.
//

#import "WXWTimer.h"

@interface WXWTimerTarget : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) NSTimer* timer;

@end

@implementation WXWTimerTarget

- (void)timeAction:(NSTimer *)timer {
    if(self.target) {
        
        [self.target performSelector:self.selector withObject:timer.userInfo afterDelay:0.0f];
        
    } else {
        [self.timer invalidate];
    }
}

@end


@implementation WXWTimer

+ (NSTimer *) scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      target:(id)aTarget
                                    selector:(SEL)aSelector
                                    userInfo:(id)userInfo
                                     repeats:(BOOL)repeats {
    WXWTimerTarget* timerTarget = [[WXWTimerTarget alloc] init];
    timerTarget.target = aTarget;
    timerTarget.selector = aSelector;
    timerTarget.timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                         target:timerTarget
                                                       selector:@selector(timeAction:)
                                                       userInfo:userInfo
                                                        repeats:repeats];
    return timerTarget.timer;
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      block:(WXWTimerBlock)block
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)repeats {
    NSMutableArray *userInfoArray = [NSMutableArray arrayWithObject:[block copy]];
    if (userInfo != nil) {
        [userInfoArray addObject:userInfo];
    }
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(timerBlock:)
                                       userInfo:[userInfoArray copy]
                                        repeats:repeats];
}

+ (void)timerBlock:(NSArray*)userInfo {
    WXWTimerBlock block = userInfo[0];
    id info = nil;
    if (userInfo.count == 2) {
        info = userInfo[1];
    }
    
    if (block) {
        block(info);
    }
}


@end
