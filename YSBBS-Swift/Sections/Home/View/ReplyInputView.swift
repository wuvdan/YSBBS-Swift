//
//  ReplyInputView.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/4.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit

class ReplyInputView: UIView {

    let textView: UITextView = {
        let t = UITextView.init()
        t.layer.borderColor = UIColor.lightGray.cgColor
        t.layer.borderWidth = 0.5
        t.returnKeyType = .send
        return t
    }()
    
    let replyButton: UIButton = {
        let b = UIButton.init(type: .custom)
        b.setTitle("回复", for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        b.setTitleColor(.lightGray, for: .normal)
        b.isEnabled = false
        b.addTarget(self, action: #selector(didTappedRelayButton), for: .touchUpInside)
        return b
    }()
    
    
    /// 键盘显示
    var keyBordShowBlock:((_ y: CGFloat, _ duration: Double) -> Void)?
    
    /// 键盘消失
    var keyBordHidenBlock:((_ y: CGFloat, _ duration: Double) -> Void)?
    
    /// 键盘文字输入
    var textViewChangeText:((_ text: String) -> Void)?
    
    /// 回车按钮点击和回复按钮点击
    var textViewEndEditing:((_ text: String) -> Void)?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        addNotification()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = kCOLOR(R: 244, G: 244, B: 244)
        textView.delegate = self
        addSubview(textView)
        addSubview(replyButton)
        
        replyButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        textView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview().inset(10)
            make.trailing.equalTo(replyButton.snp.leading).offset(-15)
        }
    }
}

extension ReplyInputView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        replyButton.isEnabled = textView.text.count > 0
        replyButton.setTitleColor(textView.text.count > 0 ? .black : .lightGray, for: .normal)
        if (textViewChangeText != nil) {
            textViewChangeText!(textView.text)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.elementsEqual("\n") {
            textView.resignFirstResponder()
            if (textViewEndEditing != nil && textView.text.count > 0) {
                textViewEndEditing!(textView.text)
            }
            return false
        } else {
            return true
        }
    }
}

@objc private extension ReplyInputView {
    
    func addNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBordShow(sender:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardHide(sender:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func didTappedRelayButton() {
        textView.resignFirstResponder()
        if (textViewEndEditing != nil && textView.text.count > 0) {
            textViewEndEditing!(textView.text)
        }
    }
    
     func keyBordShow(sender: Notification) {
        var duration: Double = 0.0
        var endFrame: NSValue?
        if let userInfo = sender.userInfo {
            duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
            endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue)
        }
        
        let y = endFrame?.cgRectValue.origin.y
        let margin: CGFloat = UIScreen.main.bounds.height - y!
        if (keyBordShowBlock != nil) {
            keyBordShowBlock!(margin, duration)
        }
    }
    
    func keyBoardHide(sender: Notification) {
        let duration: Double = sender.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        if (keyBordHidenBlock != nil) {
            keyBordHidenBlock!(0, duration)
        }
    }
}
