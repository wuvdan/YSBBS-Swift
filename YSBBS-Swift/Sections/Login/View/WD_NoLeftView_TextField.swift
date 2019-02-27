//
//  WD_NoLeftView_TextField.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/2/27.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit

class WD_NoLeftView_TextField: UITextField {

    var textFieldChangeHandler: ((String) -> Void)?
    var textFieldNextResponseHandler:((WD_NoLeftView_TextField) -> Void)?

    
    /// 设置为占位符
    private lazy var titleLabel: UILabel = {
        let l = UILabel.init()
        l.font = UIFont.systemFont(ofSize: 15)
        l.textColor = kMain_Color_line_dark
        return l
    }()
    
    /// 底部线条
    lazy var bottomLine: UIView = {
        let v = UIView.init()
        v.backgroundColor = kMain_Color_line_dark
        return v
    }()
    
    /// 重写 占位符文字
    private var _placeholder: String?
    override var placeholder: String? {
        get {
            return _placeholder
        } set {
            _placeholder = newValue
            titleLabel.text = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        leftViewMode = .always
        setupSubViews()
        self.addTarget(self, action: #selector(textChenge(textField:)), for: .editingChanged)
    }
    
    @objc func textChenge(textField:WD_NoLeftView_TextField) {
        if (textFieldChangeHandler != nil) {
            textFieldChangeHandler!(textField.text!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension WD_NoLeftView_TextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.titleLabel.snp.remakeConstraints({ (make) in
                make.leading.trailing.equalToSuperview()
                make.top.equalToSuperview().inset(-20 * kSCREEN_RATE_WIDTH)
            })
            self.titleLabel.font = UIFont.systemFont(ofSize: 10)
            self.titleLabel.superview!.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if (self.text?.count)! > 0 {
            self.titleLabel.font = UIFont.systemFont(ofSize: 10)
        } else {
            UIView.animate(withDuration: 0.5) {
                self.titleLabel.snp.remakeConstraints({ (make) in
                    make.top.bottom.trailing.equalToSuperview()
                    make.leading.equalToSuperview()
                })
                self.titleLabel.font = UIFont.systemFont(ofSize: 15)
                self.titleLabel.superview!.layoutIfNeeded()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textFieldNextResponseHandler != nil) {
            textFieldNextResponseHandler!(textField as! WD_NoLeftView_TextField)
        }
        return true
    }
}

extension WD_NoLeftView_TextField {
    func setupSubViews() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(self)
            make.height.equalTo(0.8)
        }
    }
}
