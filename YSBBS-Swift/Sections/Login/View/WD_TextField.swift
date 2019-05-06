//
//  WD_TextField.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/2/25.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit

class WD_TextField: UITextField {
    
    var textFieldChangeHandler: ((String, WD_TextField) -> Void)?
    var textFieldNextResponseHandler:((WD_TextField) -> Void)?

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
    
    /// 修改文字的位置
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.textRect(forBounds: bounds)
        rect.origin.x += 10 * kSCREEN_RATE_WIDTH
        return rect
    }
    
    /// 修改编辑时的位置
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.editingRect(forBounds: bounds)
        rect.origin.x += 10 * kSCREEN_RATE_WIDTH
        return rect
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        leftViewMode = .always
        setupSubViews()
        addTarget(self, action: #selector(textChenge(textField:)), for: .editingChanged)
    }
    
    @objc func textChenge(textField:WD_TextField) {
        if (textFieldChangeHandler != nil) {
            textFieldChangeHandler!(textField.text!, textField)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WD_TextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.titleLabel.snp.remakeConstraints({ (make) in
                make.leading.trailing.equalToSuperview()
                make.top.equalToSuperview().inset(-20 * kSCREEN_RATE_WIDTH)
            })
            strongSelf.titleLabel.font = UIFont.systemFont(ofSize: 10)
            strongSelf.titleLabel.superview!.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if (self.text?.count)! > 0 {
            self.titleLabel.font = UIFont.systemFont(ofSize: 10)
        } else {
          UIView.animate(withDuration: 0.5) { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.titleLabel.snp.remakeConstraints({ (make) in
                    make.top.bottom.trailing.equalToSuperview()
                    make.leading.equalToSuperview().inset(28 * kSCREEN_RATE_WIDTH)
                })
                strongSelf.titleLabel.font = UIFont.systemFont(ofSize: 15)
                strongSelf.titleLabel.superview!.layoutIfNeeded()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textFieldNextResponseHandler != nil) {
            textFieldNextResponseHandler!(textField as! WD_TextField)
        }
        return true
    }
}

extension WD_TextField {
    func setupSubViews() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalToSuperview().inset(28 * kSCREEN_RATE_WIDTH)
        }
        
        addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(self)
            make.height.equalTo(0.8)
        }
    }
}
