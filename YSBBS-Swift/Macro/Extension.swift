//
//  Extension.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/2/15.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import Foundation
import UIKit

/// Mark - Screen Property
let kSCREEN_BOUNDS : CGRect = UIScreen.main.bounds
let kSCREEN_WIDTH : CGFloat = UIScreen.main.bounds.width
let kSCREEN_HEIGHT : CGFloat = UIScreen.main.bounds.height
let kSCREEN_RATE_WIDTH : CGFloat = kSCREEN_WIDTH / 375.0
let kSCREEN_RATE_HEIGHT : CGFloat = kSCREEN_HEIGHT / 667.0

/// Mark - iPhoneX Adapt
let kIS_iPhoneX : Bool = UIApplication.shared.statusBarFrame.height > 20 ? true : false
/// 状态栏高度
let kStatusBarHeight : CGFloat = UIApplication.shared.statusBarFrame.height
/// 底部安全距离
let kSafeAreaBottomHeight : CGFloat = kIS_iPhoneX ? 34.0 : 0
/// 导航栏高度
let kNavigationBarHeight : CGFloat = 44
/// 顶部导航栏高度
let kSafeAreaTopHeight : CGFloat = kStatusBarHeight + kNavigationBarHeight
/// Tabbar高度
let kTabbarHeight : CGFloat = 49.0

/// Mark - Color
func kCOLOR(R: CGFloat, G: CGFloat, B: CGFloat) -> UIColor {
    return UIColor.init(red: R / 255.0, green: G / 255.0, blue: B / 255.0, alpha: 1)
}

func kCOLORA(R: CGFloat, G: CGFloat, B: CGFloat, A: CGFloat) -> UIColor {
    return UIColor.init(red: R / 255.0, green: G / 255.0, blue: B / 255.0, alpha: A)
}

/// Mark - Font
func kFONT_SIZE(size : CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: size)
}

func kFONT_BOLD_SIZE(size : CGFloat) -> UIFont {
    return UIFont.boldSystemFont(ofSize: size)
}

func kFONT_ITALIC_SIZE(size : CGFloat) -> UIFont {
    return UIFont.italicSystemFont(ofSize: size)
}

/// Mark - Image Load
func kGetImage(imageName : String) -> UIImage {
    return UIImage.init(named: imageName)!
}

func kGetBundleImage(fileName : String, type : String) -> UIImage {
    let filePath = Bundle.main.path(forResource: fileName, ofType: type)
    return UIImage.init(contentsOfFile: filePath!)!
}


/// Mark - APP About
let kMain_Color_Back_White: UIColor = UIColor.white
let kMain_Color_line_dark: UIColor = kCOLOR(R: 48, G: 48, B: 48)


