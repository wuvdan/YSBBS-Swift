//
//  LZAlterView.m
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/11.
//  Copyright © 2019 com.wudan. All rights reserved.
//

#import "LZAlterView.h"
#define alter_ScreenWidth       UIScreen.mainScreen.bounds.size.width
#define alter_ScreenHeight      UIScreen.mainScreen.bounds.size.height

#define alter_actionHeight      45 * alter_ScreenWidth/375.0
#define alter_cancelSpece       5 * alter_ScreenWidth/375.0
#define alter_mainTitleHeight   alter_actionHeight + alter_cancelSpece
#define alter_FontSize(s)       [UIFont systemFontOfSize:s * alter_ScreenWidth/375.0]

@interface LZAlterView ()

@property (nonatomic) CGRect                         conterViewRect;
@property (nonatomic, strong) UIView                *contanerView;
@property (nonatomic, weak) id <LZAlterViewDelegate> delegate;

@end

@implementation LZAlterView

+ (instancetype)defaltManager {
    static dispatch_once_t onceToken;
    static LZAlterView *alter;
    dispatch_once(&onceToken, ^{
        alter = [[LZAlterView alloc] init];
    });
    return alter;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - Configuration method
/** 代理  */
- (LZAlterView *)setupDelegate:(id<LZAlterViewDelegate>)delegate {
    self.delegate = delegate;
    return self;
}

/** Set title, subtitle, events and cancel */
- (LZAlterView *)configureWithMainTitle:(NSString *)mainTitle subTitle:(NSString *)subTitle actionTitleArray:(NSArray<NSString *> *)actionTitleArray cancelActionTitle:(NSString *)cancelTitle {
    CGFloat width           = alter_actionHeight * (actionTitleArray.count + 1) + alter_cancelSpece + alter_mainTitleHeight;
    self.contanerView.frame = CGRectMake(0, [self safeScreenHeight] - width, alter_ScreenWidth, width);
    [self addSubview:self.contanerView];
    
    UILabel *titleLabel     = [self setupMainTitle:mainTitle subTitle:subTitle];
    titleLabel.frame        = CGRectMake(0, 0, alter_ScreenWidth, alter_mainTitleHeight);
    [self.contanerView addSubview:titleLabel];
    
    UIButton *cancelButton  = [self cancelButtonWithTitle:cancelTitle];
    cancelButton.frame      = CGRectMake(0, self.contanerView.frame.size.height - alter_actionHeight, alter_ScreenWidth, alter_actionHeight);
    [self.contanerView addSubview:cancelButton];
    
    for (NSString *name in actionTitleArray) {
        UIButton *button = [self setupActionWithTitle:name];
        NSInteger index  = [actionTitleArray indexOfObject:name];
        button.tag       = 1000 + index;
        button.frame     = CGRectMake(0, titleLabel.frame.size.height + 0.5 + alter_actionHeight * index, alter_ScreenWidth, alter_actionHeight - 0.5);
        [self.contanerView addSubview:button];
    }
    self.conterViewRect = self.contanerView.frame;
    
    return self;
}

/** Set title, subtitle and events */
- (LZAlterView *)configureWithMainTitle:(NSString *)mainTitle subTitle:(NSString *)subTitle actionTitleArray:(NSArray<NSString *> *)actionTitleArray {
    CGFloat width           = alter_actionHeight * actionTitleArray.count + alter_mainTitleHeight;
    self.contanerView.frame = CGRectMake(0, [self safeScreenHeight] - width, alter_ScreenWidth, width);
    [self addSubview:self.contanerView];
    
    UILabel *titleLabel     = [self setupMainTitle:mainTitle subTitle:subTitle];
    titleLabel.frame        = CGRectMake(0, 0, alter_ScreenWidth, alter_mainTitleHeight);
    [self.contanerView addSubview:titleLabel];
    
    for (NSString *name in actionTitleArray) {
        UIButton *button = [self setupActionWithTitle:name];
        NSInteger index  = [actionTitleArray indexOfObject:name];
        button.tag       = 1000 + index;
        button.frame     = CGRectMake(0, titleLabel.frame.size.height + 0.5 + alter_actionHeight * index, alter_ScreenWidth, alter_actionHeight - 0.5);
        [self.contanerView addSubview:button];
    }
    self.conterViewRect = self.contanerView.frame;
    return self;
}

/** Set events and cancel */
- (LZAlterView *)configureWithActionTitleArray:(NSArray<NSString *> *)actionTitleArray cancelActionTitle:(NSString *)cancelTitle {
    CGFloat width           = alter_actionHeight * (actionTitleArray.count + 1) + alter_cancelSpece;
    self.contanerView.frame = CGRectMake(0, [self safeScreenHeight] - width, alter_ScreenWidth, width);
    [self addSubview:self.contanerView];
    
    UIButton *cancelButton  = [self cancelButtonWithTitle:cancelTitle];
    cancelButton.frame      = CGRectMake(0, self.contanerView.frame.size.height - alter_actionHeight, alter_ScreenWidth, alter_actionHeight);
    [self.contanerView addSubview:cancelButton];
    
    for (NSString *name in actionTitleArray) {
        UIButton *button = [self setupActionWithTitle:name];
        NSInteger index  = [actionTitleArray indexOfObject:name];
        button.tag       = 1000 + index;
        button.frame     = CGRectMake(0, alter_actionHeight * index, alter_ScreenWidth, alter_actionHeight-0.5);
        [self.contanerView addSubview:button];
    }
    self.conterViewRect = self.contanerView.frame;
    return self;
}

/** Set events */
- (LZAlterView *)configureWithActionTitleArray:(NSArray<NSString *> *)actionTitleArray {
    CGFloat width           = alter_actionHeight * actionTitleArray.count;
    self.contanerView.frame = CGRectMake(0, [self safeScreenHeight] - width, alter_ScreenWidth, width);
    [self addSubview:self.contanerView];
    
    for (NSString *name in actionTitleArray) {
        UIButton *button = [self setupActionWithTitle:name];
        NSInteger index  = [actionTitleArray indexOfObject:name];
        button.tag       = 1000 + index;
        button.frame     = CGRectMake(0, alter_actionHeight * index, alter_ScreenWidth, alter_actionHeight-0.5);
        [self.contanerView addSubview:button];
    }
    self.conterViewRect = self.contanerView.frame;
    return self;
}

/** Event button style */
- (UIButton *)setupActionWithTitle:(NSString *)title {
    UIButton *button       = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    button.titleLabel.font = alter_FontSize(15);
    [button addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

/** Cancel button style */
- (UIButton *)cancelButtonWithTitle:(NSString *)title {
    UIButton *button       = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.9 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    button.titleLabel.font = alter_FontSize(15);
    [button addTarget:self action:@selector(hidenAlter) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

/** Title style */
- (UILabel *)setupMainTitle:(NSString *)title subTitle:(NSString *)subTitle {
    NSString *titleString;
    
    if (subTitle.length == 0) {
        titleString = [NSString stringWithFormat:@"%@",title];
    } else {
        titleString = [NSString stringWithFormat:@"%@\n%@",title,subTitle];
    }
    
    UILabel *label                         = [[UILabel alloc] init];
    label.backgroundColor                  = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    label.textColor                        = UIColor.blackColor;
    label.font                             = alter_FontSize(15);
    NSMutableAttributedString *muAttribute = [[NSMutableAttributedString alloc] initWithString:titleString];
    
    [muAttribute addAttribute:NSFontAttributeName value:alter_FontSize(12) range:NSMakeRange(titleString.length - subTitle.length, subTitle.length)];
    [muAttribute addAttribute:NSForegroundColorAttributeName value:UIColor.grayColor range:NSMakeRange(titleString.length - subTitle.length, subTitle.length)];
    
    label.textAlignment                    = NSTextAlignmentCenter;
    label.numberOfLines                    = 2;
    label.attributedText                   = muAttribute;
    return label;
}

#pragma mark - Button click events and delegate

- (void)buttonTouched:(UIButton *)sender {
    [self hidenAlter];
    if (self.delegate && [self.delegate respondsToSelector:@selector(alterView:didSelectedAtIndex:)]) {
        [self.delegate alterView:self didSelectedAtIndex:sender.tag - 1000];
    }
}

/** iOS 11 safeArea bottom space */
- (CGFloat)safeScreenHeight {
    CGFloat safeAreaInsetsBottom = 0;
    if (@available(iOS 11.0, *)) {
        safeAreaInsetsBottom = UIApplication.sharedApplication.delegate.window.safeAreaInsets.bottom;
    } else {
        safeAreaInsetsBottom = 0;
    }
    return alter_ScreenHeight - safeAreaInsetsBottom;
}

#pragma mark - Show alter And hiden alter
/** Show alter from bottom */
- (void)showAlter {
    [UIApplication.sharedApplication.delegate.window addSubview:self];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.frame           = CGRectMake(0, 0, alter_ScreenWidth, alter_ScreenHeight);
    self.alpha           = 0;
    self.contanerView.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height, UIScreen.mainScreen.bounds.size.height, 0);
    
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha              = 1;
        self.contanerView.frame = self.conterViewRect;
    }];
}

/** Hiden alter and remove subViews from superview */
- (void)hidenAlter {
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha              = 0;
        self.contanerView.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height, UIScreen.mainScreen.bounds.size.height, 0);
    } completion:^(BOOL finished) {
        for (UIView *view in self.contanerView.subviews) {
            [view removeFromSuperview];
        }
        [self removeFromSuperview];
    }];
}

#pragma mark - Getter

- (UIView *)contanerView {
    if (!_contanerView) {
        _contanerView                 = [[UIView alloc] init];
        _contanerView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.5];
    }
    return _contanerView;
}

#pragma mark - TapGestureRecognizer event

- (void)tapGestureRecognizer:(id)sender {
    [self hidenAlter];
}

@end
