//
//  LZRemindBar.m
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/11.
//  Copyright © 2019 com.wudan. All rights reserved.
//

#import "LZRemindBar.h"

#define bar_IsPhoneX  UIApplication.sharedApplication.statusBarFrame.size.height != 20
#define bar_topInterval  bar_IsPhoneX ? UIApplication.sharedApplication.statusBarFrame.size.height : 0

@interface LZRemindBar ()

@property (nonatomic, strong) UILabel           *contentLabel; //*! 文字Label
@property (nonatomic, assign) RemindBarPosition position;      //*! 显示位置
@property (nonatomic, assign) BOOL              isShowing;     //*! 是否正在显示
@end

@implementation LZRemindBar

+ (instancetype)remind {
    static dispatch_once_t onceToken;
    static LZRemindBar *remind;
    dispatch_once(&onceToken, ^{
        remind = [[LZRemindBar alloc] init];
    });
    return remind;
}

+ (LZRemindBar *)configurationWithStyle:(RemindBarStyle)style showPosition:(RemindBarPosition)position contentText:(NSString *)text {
    
    if ([LZRemindBar remind].isShowing) {
        return [LZRemindBar remind];
    }
    
    [LZRemindBar remind].contentLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = UIColor.clearColor;
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = UIColor.whiteColor;
        [[LZRemindBar remind] addSubview:label];
        label.translatesAutoresizingMaskIntoConstraints = false;
        [[label.leadingAnchor constraintEqualToAnchor:[LZRemindBar remind].leadingAnchor] setActive:true];
        [[label.trailingAnchor constraintEqualToAnchor:[LZRemindBar remind].trailingAnchor] setActive:true];
        [[label.topAnchor constraintEqualToAnchor:[LZRemindBar remind].topAnchor] setActive:true];
        [[label.bottomAnchor constraintEqualToAnchor:[LZRemindBar remind].bottomAnchor] setActive:true];
        label.text = text;
        label;
    });
    
    [LZRemindBar remind].isShowing = true;
    [LZRemindBar remind].position  = position;
    
    switch (style) {
        case RemindBarStyleInfo:
            [LZRemindBar remind].backgroundColor = [UIColor colorWithRed:0 green:166.0/255 blue:124.0/255 alpha:1];
            break;
        case RemindBarStyleWarn:
            [LZRemindBar remind].backgroundColor = UIColor.orangeColor;
            break;
        case RemindBarStyleError:
            [LZRemindBar remind].backgroundColor = UIColor.redColor;
            break;
        default:
            break;
    }
    
    if (position == RemindBarPositionStatusBar) {
        [[LZRemindBar remind] setupShowStatusBarBottomWithStutus:true];
    } else {
        [[LZRemindBar remind] setupShowNavigationBarBottomWithStutus:true];
    }
    
    return [LZRemindBar remind];
}

- (void)setupShowStatusBarBottomWithStutus:(BOOL)show {
    if (show) {
        UIApplication.sharedApplication.delegate.window.windowLevel = bar_IsPhoneX ? UIWindowLevelNormal : UIWindowLevelAlert;
        self.frame = CGRectMake(0, bar_topInterval, UIScreen.mainScreen.bounds.size.width, 0);
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(0, bar_topInterval, UIScreen.mainScreen.bounds.size.width, 20);
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(0, bar_topInterval, UIScreen.mainScreen.bounds.size.width, 0);
        } completion:^(BOOL finished) {
            UIApplication.sharedApplication.delegate.window.windowLevel = UIWindowLevelNormal;
            [self dismissBar];
        }];
    }
}

- (void)setupShowNavigationBarBottomWithStutus:(BOOL)show {
    if (show) {
        self.frame = CGRectMake(0, UIApplication.sharedApplication.statusBarFrame.size.height + 44, UIScreen.mainScreen.bounds.size.width, 0);
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(0, UIApplication.sharedApplication.statusBarFrame.size.height + 44, UIScreen.mainScreen.bounds.size.width, 20);
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(0, UIApplication.sharedApplication.statusBarFrame.size.height + 44, UIScreen.mainScreen.bounds.size.width, 0);
        } completion:^(BOOL finished) {
            [self dismissBar];
        }];
    }
}

- (void)showBarAfterTimeInterval:(NSTimeInterval)interval {
    [UIApplication.sharedApplication.delegate.window addSubview:self];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.position == RemindBarPositionStatusBar) {
            [self setupShowStatusBarBottomWithStutus:false];
        } else {
            [self setupShowNavigationBarBottomWithStutus:false];
        }
    });
}

- (void)dismissBar {
    self.isShowing = false;
    [self.contentLabel removeFromSuperview];
    [self removeFromSuperview];
}
@end
