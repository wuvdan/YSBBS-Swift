//
//  LZRemindBar.h
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/11.
//  Copyright © 2019 com.wudan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RemindBarStyle) {
    RemindBarStyleInfo, // 提醒 ❇️
    RemindBarStyleWarn, // 警告 ⚠️
    RemindBarStyleError // 错误 ❌
};

typedef NS_ENUM(NSInteger, RemindBarPosition) {
    RemindBarPositionStatusBar,     // 状态栏下面
    RemindBarPositionNavigationBar, // 导航栏下面
};

@interface LZRemindBar : UIView

/**
 配置显示样式
 
 @param style 样式
 @param position 位置
 @param text 内容
 @return return value description
 */
+ (LZRemindBar *)configurationWithStyle:(RemindBarStyle)style showPosition:(RemindBarPosition)position contentText:(NSString *)text;

/**
 显示 并设置显示时间
 
 @param interval 显示时间
 */
- (void)showBarAfterTimeInterval:(NSTimeInterval)interval;

@end
NS_ASSUME_NONNULL_END
