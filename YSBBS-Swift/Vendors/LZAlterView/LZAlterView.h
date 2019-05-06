//
//  LZAlterView.h
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/11.
//  Copyright © 2019 com.wudan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LZAlterView;

@protocol LZAlterViewDelegate <NSObject>

- (void)alterView:(LZAlterView *)alterView didSelectedAtIndex:(NSInteger)index;

@end

@interface LZAlterView : UIView

+ (instancetype)defaltManager;

/**
 显示样式一
 
 @param mainTitle 主标题
 @param subTitle 副标题
 @param actionTitleArray 事件按钮数组
 @param cancelTitle 取消按钮
 @return return value description
 */
- (LZAlterView *)configureWithMainTitle:(NSString *)mainTitle subTitle:(NSString *)subTitle actionTitleArray:(NSArray<NSString *> *)actionTitleArray cancelActionTitle:(NSString *)cancelTitle;

/**
 显示样式二
 
 @param mainTitle 主标题
 @param subTitle 副标题
 @param actionTitleArray 事件按钮组数
 @return return value description
 */
- (LZAlterView *)configureWithMainTitle:(NSString *)mainTitle subTitle:(NSString *)subTitle actionTitleArray:(NSArray<NSString *> *)actionTitleArray;

/**
 显示样式三
 
 @param actionTitleArray 事件按钮数组
 @param cancelTitle 取消按钮
 @return return value description
 */
- (LZAlterView *)configureWithActionTitleArray:(NSArray<NSString *> *)actionTitleArray cancelActionTitle:(NSString *)cancelTitle;

/**
 显示样式四
 
 @param actionTitleArray 事件按钮数组
 @return return value description
 */
- (LZAlterView *)configureWithActionTitleArray:(NSArray<NSString *> *)actionTitleArray;

/**
 设置代理
 
 @param delegate 代理
 @return return value description
 */
- (LZAlterView *)setupDelegate:(id<LZAlterViewDelegate>)delegate;

- (void)showAlter;

@end

NS_ASSUME_NONNULL_END
