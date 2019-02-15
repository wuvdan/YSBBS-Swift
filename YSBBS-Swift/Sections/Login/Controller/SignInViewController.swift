//
//  SignInViewController.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/2/15.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit
import SnapKit

let normalViewSize: CGSize = CGSize(width: kSCREEN_WIDTH - 90 * kSCREEN_RATE_WIDTH, height: kSCREEN_WIDTH - 90 * kSCREEN_RATE_WIDTH)
let showViewSize: CGSize = CGSize(width: kSCREEN_WIDTH - 60 * kSCREEN_RATE_WIDTH, height: kSCREEN_WIDTH - 60 * kSCREEN_RATE_WIDTH)
let viewOffset: CGFloat = 45 * kSCREEN_RATE_WIDTH
let textFiledCornerRadius = 3 * kSCREEN_RATE_WIDTH
let titleLableOffsetY: CGFloat = kStatusBarHeight + 44 * kSCREEN_RATE_WIDTH
let titleFontSize:CGFloat = 30 * kSCREEN_RATE_WIDTH


class SignInView: UIButton {
    
    lazy var centerTitleLabel: UILabel = {
        let l = UILabel.init()
        l.text = "登 录"
        l.textAlignment = .center
        l.font = UIFont(name: "Patriciana", size: 20 * kSCREEN_RATE_WIDTH)
        return l
    }()

    lazy var accountTextField:WDTextField = {
        let t = WDTextField.init(placeHolder: "账号")
        t.layer.borderWidth = 0.5
        t.layer.borderColor = kMain_Color_line_dark.cgColor
        t.layer.cornerRadius = textFiledCornerRadius
        t.textField.keyboardType = .asciiCapable
        return t
    }()
    
    lazy var passwordTextField:WDTextField = {
        let t = WDTextField.init(placeHolder: "密码")
        t.layer.borderWidth = 0.5
        t.layer.borderColor = kMain_Color_line_dark.cgColor
        t.layer.cornerRadius = textFiledCornerRadius
        t.textField.isSecureTextEntry = true
        t.textField.clearButtonMode = .whileEditing
        return t
    }()
    
    lazy var loginButton: UIButton = {
        let b = UIButton.init(type: .custom)
        b.setTitle("确 定", for: .normal)
        b.setTitleColor(kMain_Color_Back_White, for: .normal)
        b.backgroundColor = kMain_Color_line_dark
        b.layer.cornerRadius = 45 / 2 * kSCREEN_RATE_WIDTH
        b.titleLabel?.font = UIFont(name: "Patriciana", size: 15 * kSCREEN_RATE_WIDTH)
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(centerTitleLabel)
        centerTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(10 * kSCREEN_RATE_WIDTH)
        }
        
        addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.leading.trailing.equalTo(self).inset(titleFontSize)
            make.height.equalTo(viewOffset)
        }
        
        addSubview(accountTextField)
        accountTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(passwordTextField.snp.top).offset(-15 * kSCREEN_RATE_WIDTH)
            make.leading.trailing.equalTo(self).inset(titleFontSize)
            make.height.equalTo(viewOffset)
        }
        
       
        addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20 * kSCREEN_RATE_WIDTH)
            make.leading.trailing.equalTo(self).inset(titleFontSize)
            make.height.equalTo(viewOffset)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SignUpView: UIButton {
    lazy var emialTextField:WDTextField = {
        let t = WDTextField.init(placeHolder: "邮箱")
        t.layer.borderWidth = 0.5
        t.layer.borderColor = kMain_Color_line_dark.cgColor
        t.layer.cornerRadius = textFiledCornerRadius
        t.textField.keyboardType = .emailAddress
        return t
    }()
    
    lazy var centerTitleLabel: UILabel = {
        let l = UILabel.init()
        l.text = "注 册"
        l.textAlignment = .center
        l.font = UIFont(name: "Patriciana", size: 20 * kSCREEN_RATE_WIDTH)
        return l
    }()
    
    lazy var signUpButton: UIButton = {
        let b = UIButton.init(type: .custom)
        b.setTitle("注册账号", for: .normal)
        b.setTitleColor(kMain_Color_Back_White, for: .normal)
        b.backgroundColor = kMain_Color_line_dark
        b.layer.cornerRadius = 45 / 2 * kSCREEN_RATE_WIDTH
        b.titleLabel!.font = UIFont(name: "Patriciana", size: 15 * kSCREEN_RATE_WIDTH)
        return b
    }()
    
    lazy var forgetPwdpButton: UIButton = {
        let b = UIButton.init(type: .custom)
        b.setTitle("忘记密码", for: .normal)
        b.setTitleColor(kMain_Color_Back_White, for: .normal)
        b.backgroundColor = kMain_Color_line_dark
        b.layer.cornerRadius = 45 / 2 * kSCREEN_RATE_WIDTH
        b.titleLabel!.font = UIFont(name: "Patriciana", size: 15 * kSCREEN_RATE_WIDTH)
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(centerTitleLabel)
        centerTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(10 * kSCREEN_RATE_WIDTH)
        }
        
        addSubview(emialTextField)
        emialTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY).offset(-10 * kSCREEN_RATE_WIDTH)
            make.leading.trailing.equalTo(self).inset(titleFontSize)
            make.height.equalTo(viewOffset)
        }
        
        addSubview(signUpButton)
        signUpButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.centerY).offset(10 * kSCREEN_RATE_WIDTH)
            make.leading.equalTo(self).inset(titleFontSize)
            make.trailing.equalTo(self.snp.centerX).offset(-10 * kSCREEN_RATE_WIDTH)
            make.height.equalTo(viewOffset)
        }
        
        addSubview(forgetPwdpButton)
        forgetPwdpButton.snp.makeConstraints { (make) in
            make.top.equalTo(emialTextField.snp.bottom).offset(20 * kSCREEN_RATE_WIDTH)
            make.trailing.equalTo(self).inset(titleFontSize)
            make.leading.equalTo(self.snp.centerX).offset(10 * kSCREEN_RATE_WIDTH)
            make.height.equalTo(viewOffset)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum ShowType {
    case signIn
    case signUp
}


class SignInViewController: UIViewController {
    

    
    lazy var signInView:SignInView = {
        let v = SignInView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 10 * kSCREEN_RATE_WIDTH
        v.layer.borderWidth = 0.3
        v.layer.borderColor = kMain_Color_line_dark.cgColor
        v.addTarget(self, action: #selector(signInAction(sender:)), for: .touchUpInside)
        return v
    }()
    
    lazy var signUpView:SignUpView = {
        let v = SignUpView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 10 * kSCREEN_RATE_WIDTH
        v.layer.borderWidth = 0.3
        v.layer.borderColor = kMain_Color_line_dark.cgColor
        v.addTarget(self, action: #selector(signUpAction(sender:)), for: .touchUpInside)
        return v
    }()
    
    lazy var titleLabel: UILabel = {
        let l = UILabel.init()
        l.text = "易 社"
        l.textAlignment = .center
        l.font = kFONT_SIZE(size: titleFontSize)
        return l
    }()
    
    var showType:ShowType = .signIn
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        setupUI()
    }

    func setupUI() {
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(titleLableOffsetY)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(signUpView)
        signUpView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-viewOffset / 2)
            make.size.equalTo(normalViewSize)
        }
        
        view.addSubview(signInView)
        signInView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(viewOffset)
            make.size.equalTo(showViewSize)
        }
    }
}


// MARK: - 触摸事件
extension SignInViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


// MARK: - 点击事件
@objc extension SignInViewController {
    func signInAction(sender: UIButton) {
        view.endEditing(true)
        showType = .signIn
        UIView.animate(withDuration: 1.2) {
            
            self.signUpView.snp.remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(-viewOffset / 2)
                make.size.equalTo(normalViewSize)
            }
            
            self.signInView.snp.remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(viewOffset)
                make.size.equalTo(showViewSize)
            }

            self.view.bringSubviewToFront(sender)
            self.view.insertSubview(self.signUpView, belowSubview: sender)
            self.view.layoutIfNeeded()
        }
    }
    
    func signUpAction(sender: UIButton) {
        view.endEditing(true)
        showType = .signUp
        UIView.animate(withDuration: 1.2) {
            
            self.signInView.snp.remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(-viewOffset / 2)
                make.size.equalTo(normalViewSize)
            }
            
            self.signUpView.snp.remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(viewOffset)
                make.size.equalTo(showViewSize)
            }
          
            self.view.bringSubviewToFront(sender)
            self.view.insertSubview(self.signInView, belowSubview: sender)
            self.view.layoutIfNeeded()
        }
    }
}

