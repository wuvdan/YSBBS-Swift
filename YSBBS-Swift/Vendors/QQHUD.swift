//
//  QQHUD.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/2/28.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit

enum QQHUDStyle {
    case Success
    case Warn
    case Error
}

enum QQHUDShowDirection {
    case fromLeft
    case fromRight
    case fromTop
}

class QQHUDManager: NSObject {
    static func showHUD(withTitle: String, style: QQHUDStyle, direction: QQHUDShowDirection = .fromTop, afterDelay: TimeInterval) {
        let hud = QQHUD()
        hud.showHUD(withTitle: withTitle, style: style, direction: direction, afterDelay: afterDelay)
        hud.showHUD()
    }
}

private class QQHUD: UIView {
    private let viewHeight = UIApplication.shared.statusBarFrame.height + 44
    private let viewWidth = UIScreen.main.bounds.width
    private let statusBarHeight = UIApplication.shared.statusBarFrame.height
    private var afterDelay = 1.2
    private var direction:QQHUDShowDirection = .fromTop

    private lazy var logo: UIImageView = {
        let l = UIImageView.init()
        l.contentMode = .scaleAspectFit
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private lazy var titleLabel: UILabel = {
        let l = UILabel.init()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
        addGestureRecognizer(UITapGestureRecognizer.init(target: self,
                                                         action: #selector(dismissView)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showHUD(withTitle: String, style: QQHUDStyle, direction: QQHUDShowDirection = .fromTop, afterDelay: TimeInterval) {
        self.afterDelay = afterDelay

        switch style {
        case .Success:
            logo.image = UIImage.init(named: "fftoast_success_highlight")!
        case .Warn:
            logo.image = UIImage.init(named: "fftoast_warning_highlight")!
        case .Error:
            logo.image = UIImage.init(named: "fftoast_error_highlight")!
        }
        titleLabel.text = withTitle
        titleLabel.textColor = UIColor.black
        backgroundColor = UIColor.white
    }
    
    private func setupSubViews() {
        addSubview(logo)
        logo.frame = CGRect(x: 15, y: statusBarHeight, width: 25, height: 44)
        
        addSubview(titleLabel)
        titleLabel.frame = CGRect(x: logo.frame.maxX + 10,
                                  y: statusBarHeight,
                                  width: viewWidth - 15 - logo.frame.maxX - 10,
                                  height: 44)
        
        UIApplication.shared.delegate?.window!!.addSubview(self)
    }
    
    func showHUD() {
        switch direction {
        case .fromTop:
            frame = CGRect(x: 0, y: -viewHeight * 2, width: viewWidth, height: viewHeight)
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
                self.frame = CGRect(x: 0, y: 0, width: self.viewWidth, height: self.viewHeight)
            }, completion: { complete in
                self.perform(#selector(self.dismissView), with: nil, afterDelay: self.afterDelay)
            })
        case .fromLeft:
            frame = CGRect(x: -viewWidth, y: 0, width: viewWidth, height: viewHeight)
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
                self.frame = CGRect(x: 0, y: 0, width: self.viewWidth, height: self.viewHeight)
            }, completion: { complete in
                self.perform(#selector(self.dismissView), with: nil, afterDelay: self.afterDelay)
            })
            
        case .fromRight:
            frame = CGRect(x: viewWidth, y: 0, width: viewWidth, height: viewHeight)
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
                self.frame = CGRect(x: 0, y: 0, width: self.viewWidth, height: self.viewHeight)
            }, completion: { complete in
                self.perform(#selector(self.dismissView), with: nil, afterDelay: self.afterDelay)
            })
        }
    }
    
    @objc func dismissView() {
        
        switch self.direction {
        case .fromTop:
            UIView.animate(withDuration: 0.2, animations: {
                self.frame = CGRect(x: 0, y: -self.viewHeight, width: self.viewWidth, height: 0)
            }, completion: { complete in
                self.removeFromSuperview()
            })
        case .fromLeft:
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                self.frame = CGRect(x: -self.viewWidth, y: 0, width: self.viewWidth, height: self.viewHeight)
            }, completion: { complete in
                self.removeFromSuperview()
            })
        case .fromRight:
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                self.frame = CGRect(x: self.viewWidth, y: 0, width: self.viewWidth, height: self.viewHeight)
            }, completion: { complete in
                self.removeFromSuperview()
            })
        }
    }
}
