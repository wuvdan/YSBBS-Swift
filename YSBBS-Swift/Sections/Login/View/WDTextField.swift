//
//  WDTextFile.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/2/15.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit
import SnapKit

class WDTextField: UIView {

    lazy var textField: UITextField = {
        let t = UITextField.init()
        t.font = kFONT_SIZE(size: 15)
        t.textColor = kMain_Color_line_dark
        return t
    }()
    
    lazy var mindLabel: UILabel = {
        let l = UILabel.init()
        l.font = kFONT_SIZE(size: 8)
        l.textColor = kMain_Color_line_dark
        return l
    }()
    
    convenience init(placeHolder: String) {
        self.init()
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldStart), name: UITextField.textDidBeginEditingNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldEnd), name: UITextField.textDidEndEditingNotification, object: nil)
        
        textField.placeholder = placeHolder
        mindLabel.text = placeHolder
        addSubview(textField)
        addSubview(mindLabel)
        
        textField.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.top.equalToSuperview().inset(5)
        }
        
        mindLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self).offset(15)
            make.top.equalTo(self)
            make.height.equalTo(0)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func textFieldStart() {
        UIView.animate(withDuration: 0.3) {
            self.mindLabel.snp.remakeConstraints { (make) in
                make.leading.equalTo(self).offset(15)
                make.top.equalTo(self)
            }
            self.textField.snp.remakeConstraints { (make) in
                make.top.equalTo(self.mindLabel.snp.bottom).offset(10 * kSCREEN_RATE_WIDTH)
                make.leading.trailing.equalToSuperview().inset(10 * kSCREEN_RATE_WIDTH)
                make.bottom.equalToSuperview()
            }
            self.layoutIfNeeded()
        }
    }
    
    @objc func textFieldEnd() {
        UIView.animate(withDuration: 0.3) {
            self.mindLabel.snp.remakeConstraints { (make) in
                make.leading.equalTo(self).offset(15 * kSCREEN_RATE_WIDTH)
                make.top.equalTo(self)
                make.height.equalTo(0)
            }
            self.textField.snp.remakeConstraints { (make) in
                make.leading.trailing.equalToSuperview().inset(10 * kSCREEN_RATE_WIDTH)
                make.bottom.top.equalToSuperview().inset(5 * kSCREEN_RATE_WIDTH)
            }
            self.layoutIfNeeded()
        }
    }
}
