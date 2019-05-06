//
//  UserNameInputView.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/4/15.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class NameTextView: UITextView, UITextViewDelegate {
    var maxHeight: CGFloat = CGFloat.greatestFiniteMagnitude //定义最大高度
    public var placeholerLabel: UILabel = {
        let l = UILabel.init()
        l.textColor = .lightGray
        return l
    }()
    
    override var font: UIFont? {
        didSet {
            placeholerLabel.font = font
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        placeholerLabel.frame = CGRect(x: textContainerInset.left + 3, y: textContainerInset.top, width: frame.width, height: font!.lineHeight)
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.delegate = self
        addSubview(placeholerLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var getTextWhenTextViewEditComplete:((_ text: String) -> (Void))?
    public var getTextViewHeightWhenDidChange: ((_ text: String) -> Void)?
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholerLabel.isHidden = textView.text.count != 0
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholerLabel.isHidden = textView.text.count != 0
        if (getTextWhenTextViewEditComplete != nil) {
            getTextWhenTextViewEditComplete!(textView.text)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholerLabel.isHidden = textView.text.count != 0
        if getTextViewHeightWhenDidChange != nil {
            getTextViewHeightWhenDidChange!(textView.text)
        }
    }
}

class UserNameInputView: UIView {
    
    private let backView: UIView = {
        let v = UIView.init()
        v.backgroundColor = kCOLOR(R: 244, G: 244, B: 244)
        return v
    }()
    
    public let textView: NameTextView = {
        let t = NameTextView.init(frame: .zero)
        t.isScrollEnabled = false
        t.font = UIFont.systemFont(ofSize: 15)
        t.placeholerLabel.text = "请输入昵称"
        t.returnKeyType = .done
        return t
    }()
    
    private let mindTextLabel: UILabel = {
        let l = UILabel.init()
        l.text = "支持中英文、数字"
        l.textColor = kCOLOR(R: 200, G: 200, B: 200)
        l.font = UIFont.systemFont(ofSize: 12)
        return l
    }()
    
    private let sureButton: UIButton = {
        let b = UIButton.init()
        b.setTitle("确定", for: .normal)
        b.backgroundColor = kCOLOR(R: 233, G: 233, B: 233)
        b.setTitleColor(.white, for: .normal)
        b.layer.cornerRadius = 5
        b.layer.masksToBounds = true
        b.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return b
    }()
    
    private var textViewComplete: ((String) -> Void)?
    
    func showView(text: String, complete: @escaping ((String) -> Void)) {
        if text.count == 0 {
            sureButton.isEnabled = false
            sureButton.backgroundColor = kCOLOR(R: 233, G: 233, B: 233)
        } else {
            sureButton.isEnabled = true
            sureButton.backgroundColor = kCOLOR(R: 0, G: 191, B: 255)
        }

        textViewComplete = complete
        IQKeyboardManager.shared.enableAutoToolbar = false
        textView.becomeFirstResponder()
        textView.text = text
        UIApplication.shared.keyWindow?.addSubview(self)
        frame = UIScreen.main.bounds
        backgroundColor = UIColor.init(white: 0, alpha: 0)
        backView.frame = CGRect(x: 0, y: kSCREEN_HEIGHT, width: kSCREEN_WIDTH, height: 150)
        UIView.animate(withDuration: 0.5) {
            self.backgroundColor = UIColor.init(white: 0, alpha: 0.3)
            self.backView.frame = CGRect(x: 0, y: kSCREEN_HEIGHT - 150, width: kSCREEN_WIDTH, height: 150)
        }
    }
    
    @objc private func dismissView() {
        textView.resignFirstResponder()
        IQKeyboardManager.shared.enableAutoToolbar = true
        UIView.animate(withDuration: 0.5, animations: {
            self.backgroundColor = UIColor.init(white: 0, alpha: 0)
            self.backView.frame = CGRect(x: 0, y: kSCREEN_HEIGHT, width: kSCREEN_WIDTH, height: 150)
        }) { (complete) in
            self.removeFromSuperview()
            if self.textViewComplete != nil {
                self.textViewComplete!(self.textView.text)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
        }
        
        textView.getTextViewHeightWhenDidChange = {
            if $0.count == 0 {
                self.sureButton.isEnabled = false
                self.sureButton.backgroundColor = kCOLOR(R: 233, G: 233, B: 233)
            } else {
                self.sureButton.isEnabled = true
                self.sureButton.backgroundColor = kCOLOR(R: 0, G: 191, B: 255)
            }
        }
        
        backView.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(10)
            make.height.equalTo(100)
        }
        
        sureButton.addTarget(self, action: #selector(didTappedSureButton), for: .touchUpInside)
        backView.addSubview(sureButton)
        sureButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(15)
            make.top.equalTo(textView.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(8)
            make.width.equalTo(sureButton.snp.height).multipliedBy(1.5)
        }
        
        backView.addSubview(mindTextLabel)
        mindTextLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(15)
            make.centerY.equalTo(sureButton)
        }
        
        addNotification()
        addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(didGueseture)))
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@objc private extension UserNameInputView {
    
    func didGueseture() {
        textView.resignFirstResponder()
        IQKeyboardManager.shared.enableAutoToolbar = true
        UIView.animate(withDuration: 0.5, animations: {
            self.backgroundColor = UIColor.init(white: 0, alpha: 0)
            self.backView.frame = CGRect(x: 0, y: kSCREEN_HEIGHT, width: kSCREEN_WIDTH, height: 150)
        }) { (complete) in
            self.removeFromSuperview()
            if self.textViewComplete != nil {
                self.textViewComplete!("")
            }
        }
    }
    
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
    
    func didTappedSureButton() {
        dismissView()
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
        UIView.animate(withDuration: duration) {
            self.backView.snp.updateConstraints({ (make) in
                make.bottom.equalToSuperview().inset(margin)
            })
            self.backView.superview?.layoutIfNeeded()
        }
    }
    
    func keyBoardHide(sender: Notification) {
        let duration: Double = sender.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration) {
            self.backView.snp.updateConstraints({ (make) in
                make.bottom.equalToSuperview()
            })
            self.backView.superview?.layoutIfNeeded()
        }
    }
}

