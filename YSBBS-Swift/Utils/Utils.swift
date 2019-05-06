//
//  Utils.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/8.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import Foundation
import UIKit

import SnapKit
import FFToast
import SVProgressHUD

// MARK: - Utils
class ImagePickerManager: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate, LZAlterViewDelegate {
    
    static let manager = ImagePickerManager()
    
    private var getImageSuccessBlock:((_ image: UIImage) -> Void)?
    private var getImageFaildBlock:(() -> Void)?
    
    func pickerImage(pickImageComplete:((_ image: UIImage) -> Void)?, pickImageFaildBlock:(() -> Void)?) {
        getImageFaildBlock = pickImageFaildBlock
        getImageSuccessBlock = pickImageComplete
        LZAlterView.defaltManager().configure(withActionTitleArray: ["打开相机", "打开相册"], cancelActionTitle: "取消").setupDelegate(self).showAlter()
    }
    
    func alterView(_ alterView: LZAlterView, didSelectedAt index: Int) {
        if index == 0 {
            openCamera()
        } else {
            openPhotoLibrary()
        }
    }
    
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let vc: UIImagePickerController =  UIImagePickerController.init()
            vc.delegate = self
            vc.title = "拍照"
            vc.sourceType = .camera
            UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
        }
    }
    
    private func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let vc: UIImagePickerController =  UIImagePickerController.init()
            vc.delegate = self
            vc.title = "选择照片"
            vc.sourceType = .photoLibrary
            UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            let image: UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            if self.getImageSuccessBlock != nil {
                self.getImageSuccessBlock!(image)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            if self.getImageFaildBlock != nil {
                self.getImageFaildBlock!()
            }
        }
    }
}

class HUDUtils: NSObject {
    
    static func showWarningHUD(string: String) -> Void {
        let hud = FFToast.init(toastWithTitle: nil, message: string, iconImage: nil)
        hud!.toastType = .warning
        hud!.toastPosition = .belowStatusBarWithFillet
        hud?.show()
    }
    
    static func showSuccessHUD(string: String) -> Void {
        let hud = FFToast.init(toastWithTitle: nil, message: string, iconImage: nil)
        hud!.toastType = .success
        hud!.toastPosition = .belowStatusBarWithFillet
        hud?.show()
    }
    
    static func showErrorHUD(string: String) -> Void {
        let hud = FFToast.init(toastWithTitle: nil, message: string, iconImage: nil)
        hud!.toastType = .error
        hud!.toastPosition = .belowStatusBarWithFillet
        hud?.show()
    }
}

class DateUtils: NSObject {
  class func handleStringDate_YYMMDDTHHmmss(dateString: String) -> TimeInterval {
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dfmatter.date(from: dateString)
        let dateStamp:TimeInterval = date!.timeIntervalSince1970 * 1000
        return dateStamp
    }
}

class InputCheckUtils: NSObject {
    
    func checkEmial(email: String) ->  Bool {
        if email.count == 0 {
            return false
        }
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
}

class CleanUtils: NSObject {
    ///获取APP缓存
   static func getCacheSize()-> String {
        
        // 取出cache文件夹目录
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
    
        // 取出文件夹下所有文件数组
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
    
        //快速枚举出所有文件名 计算文件大小
        var size = 0
        for file in fileArr! {
            
            // 把文件名拼接到路径中
            let path = cachePath! + ("/\(file)")
            // 取出文件属性
            let floder = try! FileManager.default.attributesOfItem(atPath: path)
            // 用元组取出文件大小属性
            for (key, fileSize) in floder {
                // 累加文件大小
                if key == FileAttributeKey.size {
                    size += (fileSize as AnyObject).integerValue
                }
            }
        }
    
        let totalCache = Double(size) / 1024.00 / 1024.00
        return String(format: "%.2fM", totalCache)
    }
    
    static func clearCache() {
        SVProgressHUD.show()
        // 取出cache文件夹目录
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        // 遍历删除
        for file in fileArr! {
            let path = (cachePath! as NSString).appending("/\(file)")
            if FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch {
                }
            }
        }
        SVProgressHUD.dismiss(withDelay: 1.2)
    }
}


// MARK: - Extension
extension UIViewController {
    func showLoginController() {
        self.present(HXNavigationController.init(rootViewController: LoginViewController()), animated: true, completion: nil)
    }
}

extension UIButton {
    /// UIButton选择和取消动画
    open func shakeAniamtion() {
        let animationScale1 = self.isSelected ? NSNumber.init(value: 1.15) : NSNumber.init(value: 0.5)
        let animationScale2 = self.isSelected ? NSNumber.init(value: 0.92) : NSNumber.init(value: 1.15)
        UIView.animate(withDuration: 0.15, delay: 0, options: [.beginFromCurrentState, .curveEaseOut] , animations: {
            self.layer.setValue(animationScale1, forKeyPath: "transform.scale")
        }) { (finished) in
            UIView.animate(withDuration: 0.15, delay: 0, options: [.beginFromCurrentState, .curveEaseOut] , animations: {
                self.layer.setValue(animationScale2, forKeyPath: "transform.scale")
            }) { (finished) in
                UIView.animate(withDuration: 1, delay: 0, options: [.beginFromCurrentState, .curveEaseOut], animations: {
                    self.layer.setValue( NSNumber.init(value: 1), forKeyPath: "transform.scale")
                }, completion: nil)
            }
        }
    }
}


extension Date {
    // 传入的时间戳精确到毫秒
    static func created_at(date: Double) -> String {
        
        let myDate = NSDate.init(timeIntervalSince1970: date / 1000 )
        
        let fmt  = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        fmt.locale = NSLocale(localeIdentifier: "en_US") as Locale?
    
        // 获得当前时间
        let now = NSDate()
        
        // 计算时间差
        let interval = now.timeIntervalSince(myDate as Date)
        // 处理小于一分钟的时间
        if interval < 60 {
            return "刚刚"
        }
        // 处理小于一小时的时间
        if interval < 60 * 60 {
            return "\(Int(interval / 60))分钟前"
        }
        // 处理小于一天的时间
        if interval < 60 * 60 * 24 {
            return "\(Int(interval / (60 * 60)))小时前"
        }
        // 处理昨天时间
        let calendar = Calendar.current
        if calendar.isDateInYesterday(myDate as Date) {
            fmt.dateFormat = "昨天 HH:mm"
            let timeStr  = fmt.string(from: myDate as Date)
            return timeStr
        }
        
        // 处理一年之内的时间
        let cmp  = calendar.dateComponents([.year,.month,.day], from: myDate as Date, to: now as Date)
        if cmp.year! < 1 {
            fmt.dateFormat = "MM-dd HH:mm"
            let timeStr  = fmt.string(from: myDate as Date)
            return timeStr
        }
        
        // 超过一年的时间
        fmt.dateFormat = "yyyy-MM-dd HH:mm"
        let timeStr = fmt.string(from: myDate as Date)
        return timeStr
    }
}

extension UIFont {
    
    static func wd_swizzleFunc(systemFunc: Selector, cumstomFunc: Selector) {
        guard let methodSystem = class_getInstanceMethod(self, systemFunc) else { return  }
        guard let methodCustom = class_getInstanceMethod(self, cumstomFunc) else { return  }
        if (class_addMethod(self, #selector(wd_systemFont(ofSize:)), method_getImplementation(methodCustom), method_getTypeEncoding(methodCustom))) {
            class_replaceMethod(self, #selector(wd_systemFont(ofSize:)), method_getImplementation(methodSystem), method_getTypeEncoding(methodSystem))
        } else {
            method_exchangeImplementations(methodSystem, methodCustom)
        }
    }
    
    static func wd_swizzle() {
        wd_swizzleFunc(systemFunc: #selector(systemFont(ofSize:)), cumstomFunc: #selector(wd_systemFont(ofSize:)))
    }
    
    @objc private func wd_systemFont(ofSize: CGFloat) -> UIFont {
        return self.wd_systemFont(ofSize: ofSize * UIScreen.main.bounds.width / 375.0 )
    }
}

extension UIImage {
    func loadTemplateImage(name: String)  -> UIImage {
        let image = UIImage.init(named: name)
        image?.withRenderingMode(.alwaysTemplate)
        return image!
    }
    
    public func roundImage(byRoundingCorners: UIRectCorner = UIRectCorner.allCorners, cornerRadi: CGFloat) -> UIImage? {
        return roundImage(byRoundingCorners: byRoundingCorners, cornerRadii: CGSize(width: cornerRadi, height: cornerRadi))
    }
    
    public func roundImage(byRoundingCorners: UIRectCorner = UIRectCorner.allCorners, cornerRadii: CGSize) -> UIImage? {
        
        let imageRect = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        let context = UIGraphicsGetCurrentContext()
        guard context != nil else {
            return nil
        }
        context?.setShouldAntialias(true)
        let bezierPath = UIBezierPath(roundedRect: imageRect,
                                      byRoundingCorners: byRoundingCorners,
                                      cornerRadii: cornerRadii)
        bezierPath.close()
        bezierPath.addClip()
        self.draw(in: imageRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}

extension String {
    func ga_widthForComment(fontSize: CGFloat, height: CGFloat = 15) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.width)
    }
    
    func ga_heightForComment(fontSize: CGFloat, width: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.height)
    }
    
    func ga_heightForComment(fontSize: CGFloat, width: CGFloat, maxHeight: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.height)>maxHeight ? maxHeight : ceil(rect.height)
    }
}

extension UIButton {
    
}

public extension Array {
    
    @available(*, deprecated:3.0, message:"Use newer snp.* syntax.")
    public func snp_prepareConstraints(_ closure: (_ make: ConstraintMaker) -> Void) -> [Constraint] {
        return self.snp.prepareConstraints(closure)
    }
    
    @available(*, deprecated:3.0, message:"Use newer snp.* syntax.")
    public func snp_makeConstraints(_ closure: (_ make: ConstraintMaker) -> Void) {
        self.snp.makeConstraints(closure)
    }
    
    @available(*, deprecated:3.0, message:"Use newer snp.* syntax.")
    public func snp_remakeConstraints(_ closure: (_ make: ConstraintMaker) -> Void) {
        self.snp.remakeConstraints(closure)
    }
    
    @available(*, deprecated:3.0, message:"Use newer snp.* syntax.")
    public func snp_updateConstraints(_ closure: (_ make: ConstraintMaker) -> Void) {
        self.snp.updateConstraints(closure)
    }
    
    @available(*, deprecated:3.0, message:"Use newer snp.* syntax.")
    public func snp_removeConstraints() {
        self.snp.removeConstraints()
    }
    
    @available(*, deprecated:3.0, message:"Use newer snp.* syntax.")
    public func snp_distributeViewsAlong(axisType: NSLayoutConstraint.Axis,
                                         fixedSpacing: CGFloat,
                                         leadSpacing: CGFloat = 0,
                                         tailSpacing: CGFloat = 0) {
        
        self.snp.distributeViewsAlong(axisType: axisType,
                                      fixedSpacing: fixedSpacing,
                                      leadSpacing: leadSpacing,
                                      tailSpacing: tailSpacing)
    }
    
    
    @available(*, deprecated:3.0, message:"Use newer snp.* syntax.")
    public func snp_distributeViewsAlong(axisType: NSLayoutConstraint.Axis,
                                         fixedItemLength: CGFloat,
                                         leadSpacing: CGFloat = 0,
                                         tailSpacing: CGFloat = 0) {
        
        self.snp.distributeViewsAlong(axisType: axisType,
                                      fixedItemLength: fixedItemLength,
                                      leadSpacing: leadSpacing,
                                      tailSpacing: tailSpacing)
    }
    
    @available(*, deprecated:3.0, message:"Use newer snp.* syntax.")
    public func snp_distributeSudokuViews(fixedItemWidth: CGFloat,
                                          fixedItemHeight: CGFloat,
                                          warpCount: Int,
                                          edgeInset: UIEdgeInsets = UIEdgeInsets.zero) {
        
        self.snp.distributeSudokuViews(fixedItemWidth: fixedItemWidth,
                                       fixedItemHeight: fixedItemHeight,
                                       warpCount: warpCount,
                                       edgeInset: edgeInset)
    }
    
    @available(*, deprecated:3.0, message:"Use newer snp.* syntax.")
    public func snp_distributeSudokuViews(fixedLineSpacing: CGFloat,
                                          fixedInteritemSpacing: CGFloat,
                                          warpCount: Int,
                                          edgeInset: UIEdgeInsets = UIEdgeInsets.zero) {
        
        self.snp.distributeSudokuViews(fixedLineSpacing: fixedLineSpacing,
                                       fixedInteritemSpacing: fixedInteritemSpacing,
                                       warpCount: warpCount,
                                       edgeInset: edgeInset)
    }
    
    
    
    
    public var snp: ConstraintArrayDSL {
        return ConstraintArrayDSL(array: self as! Array<ConstraintView>)
    }
    
}


public struct ConstraintArrayDSL {
    @discardableResult
    public func prepareConstraints(_ closure: (_ make: ConstraintMaker) -> Void) -> [Constraint] {
        var constraints = Array<Constraint>()
        for view in self.array {
            constraints.append(contentsOf: view.snp.prepareConstraints(closure))
        }
        return constraints
    }
    
    public func makeConstraints(_ closure: (_ make: ConstraintMaker) -> Void) {
        for view in self.array {
            view.snp.makeConstraints(closure)
        }
    }
    
    public func remakeConstraints(_ closure: (_ make: ConstraintMaker) -> Void) {
        for view in self.array {
            view.snp.remakeConstraints(closure)
        }
    }
    
    public func updateConstraints(_ closure: (_ make: ConstraintMaker) -> Void) {
        for view in self.array {
            view.snp.updateConstraints(closure)
        }
    }
    
    public func removeConstraints() {
        for view in self.array {
            view.snp.removeConstraints()
        }
    }
    
    /// distribute with fixed spacing
    ///
    /// - Parameters:
    ///   - axisType: which axis to distribute items along
    ///   - fixedSpacing: the spacing between each item
    ///   - leadSpacing: the spacing before the first item and the container
    ///   - tailSpacing: the spacing after the last item and the container
    public func distributeViewsAlong(axisType:NSLayoutConstraint.Axis,
                                     fixedSpacing:CGFloat,
                                     leadSpacing:CGFloat = 0,
                                     tailSpacing:CGFloat = 0) {
        
        guard self.array.count > 1, let tempSuperView = commonSuperviewOfViews() else {
            return
        }
        
        if axisType == .horizontal {
            var prev : ConstraintView?
            for (i, v) in self.array.enumerated() {
                v.snp.makeConstraints({ (make) in
                    if prev != nil {
                        make.width.equalTo(prev!)
                        make.left.equalTo((prev?.snp.right)!).offset(fixedSpacing)
                        if (i == self.array.count - 1) {//last one
                            make.right.equalTo(tempSuperView).offset(-tailSpacing);
                        }
                    }else {
                        make.left.equalTo(tempSuperView).offset(leadSpacing);
                    }
                })
                prev = v;
            }
        }else {
            var prev : ConstraintView?
            for (i, v) in self.array.enumerated() {
                v.snp.makeConstraints({ (make) in
                    if prev != nil {
                        make.height.equalTo(prev!)
                        make.top.equalTo((prev?.snp.bottom)!).offset(fixedSpacing)
                        if (i == self.array.count - 1) {//last one
                            make.bottom.equalTo(tempSuperView).offset(-tailSpacing);
                        }
                    }else {
                        make.top.equalTo(tempSuperView).offset(leadSpacing);
                    }
                })
                prev = v;
            }
        }
    }
    
    /// distribute with fixed item size
    ///
    /// - Parameters:
    ///   - axisType: which axis to distribute items along
    ///   - fixedItemLength: the fixed length of each item
    ///   - leadSpacing: the spacing before the first item and the container
    ///   - tailSpacing: the spacing after the last item and the container
    public func distributeViewsAlong(axisType:NSLayoutConstraint.Axis,
                                     fixedItemLength:CGFloat,
                                     leadSpacing:CGFloat = 0,
                                     tailSpacing:CGFloat = 0) {
        
        guard self.array.count > 1, let tempSuperView = commonSuperviewOfViews() else {
            return
        }
        
        if axisType == .horizontal {
            var prev : ConstraintView?
            for (i, v) in self.array.enumerated() {
                v.snp.makeConstraints({ (make) in
                    make.width.equalTo(fixedItemLength)
                    if prev != nil {
                        if (i == self.array.count - 1) {//last one
                            make.right.equalTo(tempSuperView).offset(-tailSpacing);
                        }else {
                            let offset = (CGFloat(1) - (CGFloat(i) / CGFloat(self.array.count - 1))) *
                                (fixedItemLength + leadSpacing) - CGFloat(i) *
                                tailSpacing /
                                CGFloat(self.array.count - 1)
                            make.right
                                .equalTo(tempSuperView)
                                .multipliedBy(CGFloat(i) / CGFloat(self.array.count - 1))
                                .offset(offset)
                        }
                    }else {
                        make.left.equalTo(tempSuperView).offset(leadSpacing);
                    }
                })
                prev = v;
            }
        }else {
            var prev : ConstraintView?
            for (i, v) in self.array.enumerated() {
                v.snp.makeConstraints({ (make) in
                    make.height.equalTo(fixedItemLength)
                    if prev != nil {
                        if (i == self.array.count - 1) {//last one
                            make.bottom.equalTo(tempSuperView).offset(-tailSpacing);
                        }else {
                            let offset = (CGFloat(1) - (CGFloat(i) / CGFloat(self.array.count - 1))) *
                                (fixedItemLength + leadSpacing) - CGFloat(i) *
                                tailSpacing /
                                CGFloat(self.array.count - 1)
                            
                            make.bottom
                                .equalTo(tempSuperView)
                                .multipliedBy(CGFloat(i) / CGFloat(self.array.count-1))
                                .offset(offset)
                        }
                    }else {
                        make.top.equalTo(tempSuperView).offset(leadSpacing);
                    }
                })
                prev = v;
            }
        }
    }
    
    public func distributeSudokuViews(fixedItemWidth: CGFloat,
                                      fixedItemHeight: CGFloat,
                                      warpCount: Int,
                                      edgeInset: UIEdgeInsets = UIEdgeInsets.zero) {
        
        guard self.array.count > 1, warpCount >= 1, let tempSuperView = commonSuperviewOfViews() else {
            return
        }
        
        let rowCount = self.array.count % warpCount == 0 ? self.array.count / warpCount : self.array.count / warpCount + 1;
        let columnCount = warpCount
        
        for (i,v) in self.array.enumerated() {
            
            let currentRow = i / warpCount
            let currentColumn = i % warpCount
            
            v.snp.makeConstraints({ (make) in
                make.width.equalTo(fixedItemWidth)
                make.height.equalTo(fixedItemHeight)
                if currentRow == 0 {//fisrt row
                    make.top.equalTo(tempSuperView).offset(edgeInset.top)
                }
                if currentRow == rowCount - 1 {//last row
                    make.bottom.equalTo(tempSuperView).offset(-edgeInset.bottom)
                }
                
                if currentRow != 0 && currentRow != rowCount - 1 {//other row
                    let offset = (CGFloat(1) - CGFloat(currentRow) / CGFloat(rowCount - 1)) * (fixedItemHeight + edgeInset.top) - CGFloat(currentRow) * edgeInset.bottom / CGFloat(rowCount - 1)
                    make.bottom
                        .equalTo(tempSuperView)
                        .multipliedBy(CGFloat(currentRow) / CGFloat(rowCount - 1))
                        .offset(offset);
                }
                
                if currentColumn == 0 {//first col
                    make.left.equalTo(tempSuperView).offset(edgeInset.left)
                }
                if currentColumn == columnCount - 1 {//last col
                    make.right.equalTo(tempSuperView).offset(-edgeInset.right)
                }
                
                if currentColumn != 0 && currentColumn != columnCount - 1 {//other col
                    let offset = (CGFloat(1) - CGFloat(currentColumn) / CGFloat(columnCount - 1)) * (fixedItemWidth + edgeInset.left) - CGFloat(currentColumn) * edgeInset.right / CGFloat(columnCount - 1)
                    make.right
                        .equalTo(tempSuperView)
                        .multipliedBy(CGFloat(currentColumn) / CGFloat(columnCount - 1))
                        .offset(offset);
                }
            })
        }
    }
    
    public func distributeSudokuViews(fixedLineSpacing: CGFloat,
                                      fixedInteritemSpacing: CGFloat,
                                      warpCount: Int,
                                      edgeInset: UIEdgeInsets = UIEdgeInsets.zero) {
        
        guard self.array.count > 1, warpCount >= 1, let tempSuperView = commonSuperviewOfViews() else {
            return
        }
        
        let columnCount = warpCount
        let rowCount = self.array.count % warpCount == 0 ? self.array.count / warpCount : self.array.count / warpCount + 1;
        
        var prev : ConstraintView?
        
        for (i,v) in self.array.enumerated() {
            
            let currentRow = i / warpCount
            let currentColumn = i % warpCount
            
            v.snp.makeConstraints({ (make) in
                if prev != nil {
                    make.width.height.equalTo(prev!)
                }
                if currentRow == 0 {//fisrt row
                    make.top.equalTo(tempSuperView).offset(edgeInset.top)
                }
                if currentRow == rowCount - 1 {//last row
                    if currentRow != 0 && i - columnCount >= 0 {
                        make.top.equalTo(self.array[i-columnCount].snp.bottom).offset(fixedLineSpacing)
                    }
                    make.bottom.equalTo(tempSuperView).offset(-edgeInset.bottom)
                }
                
                if currentRow != 0 && currentRow != rowCount - 1 {//other row
                    make.top.equalTo(self.array[i-columnCount].snp.bottom).offset(fixedLineSpacing);
                }
                
                if currentColumn == 0 {//first col
                    make.left.equalTo(tempSuperView).offset(edgeInset.left)
                }
                if currentColumn == warpCount - 1 {//last col
                    if currentColumn != 0 {
                        make.left.equalTo(prev!.snp.right).offset(fixedInteritemSpacing)
                    }
                    make.right.equalTo(tempSuperView).offset(-edgeInset.right)
                }
                
                if currentColumn != 0 && currentColumn != warpCount - 1 {//other col
                    make.left.equalTo(prev!.snp.right).offset(fixedInteritemSpacing);
                }
            })
            prev = v
        }
    }
    public var target: AnyObject? {
        return self.array as AnyObject
    }
    
    internal let array: Array<ConstraintView>
    
    internal init(array: Array<ConstraintView>) {
        self.array = array
        
    }
    
}

private extension ConstraintArrayDSL {
    func commonSuperviewOfViews() -> ConstraintView? {
        var commonSuperview : ConstraintView?
        var previousView : ConstraintView?
        for view in self.array {
            if previousView != nil {
                commonSuperview = view.closestCommonSuperview(commonSuperview)
            }else {
                commonSuperview = view
            }
            previousView = view
        }
        
        return commonSuperview
    }
}

private extension ConstraintView {
    func closestCommonSuperview(_ view : ConstraintView?) -> ConstraintView? {
        var closestCommonSuperview: ConstraintView?
        var secondViewSuperview: ConstraintView? = view
        while closestCommonSuperview == nil && secondViewSuperview != nil {
            var firstViewSuperview: ConstraintView? = self
            while closestCommonSuperview == nil && firstViewSuperview != nil {
                if secondViewSuperview == firstViewSuperview {
                    closestCommonSuperview = secondViewSuperview
                }
                firstViewSuperview = firstViewSuperview?.superview
            }
            secondViewSuperview = secondViewSuperview?.superview
        }
        return closestCommonSuperview
        
    }
}
