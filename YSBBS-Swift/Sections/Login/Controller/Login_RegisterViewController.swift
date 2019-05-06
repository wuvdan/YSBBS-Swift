//
//  Login_RegisterViewController.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/2/27.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit


class Login_RegisterViewController: UIViewController {
    
    ///  E-mail
    
    lazy var emailTextField: UILabel = {
        let l       = UILabel.init()
        l.textColor = kMain_Color_line_dark
        l.font      = UIFont.systemFont(ofSize: 15)
        return l
    }()
    
    ///  E-mail Code
    private lazy var emailCodeTextField: WD_NoLeftView_TextField = {
        let textField           = WD_NoLeftView_TextField()
        textField.placeholder   = "验证码";
        textField.keyboardType  = .numberPad
        textField.returnKeyType = .next
        return textField
    }()
    
    ///  User name
    private lazy var userNameTextField: WD_NoLeftView_TextField = {
        let textField           = WD_NoLeftView_TextField()
        textField.placeholder   = "用户名";
        textField.returnKeyType = .next
        return textField
    }()

    ///  Password
    private lazy var pwdTextField: WD_NoLeftView_TextField = {
        let textField               = WD_NoLeftView_TextField()
        textField.placeholder       = "密码";
        textField.isSecureTextEntry = true
        textField.clearButtonMode   = .whileEditing
        textField.returnKeyType     = .next
        return textField
    }()
    
    ///  Password again
    private lazy var pwdAgainTextField: WD_NoLeftView_TextField = {
        let textField               = WD_NoLeftView_TextField()
        textField.placeholder       = "确认密码";
        textField.isSecureTextEntry = true
        textField.clearButtonMode   = .whileEditing
        textField.returnKeyType     = .done
        return textField
    }()
    
    /// Sure button
    private lazy var sureButton: UIButton = {
        let b = UIButton.init(type: .custom)
        let image = UIImage.init(named: "loing_btn_normal_50x50_")
        b.setImage(image, for: .normal)
        b.imageView!.tintColor = kMain_Color_line_dark.withAlphaComponent(0.5)
        b.currentImage?.withRenderingMode(.alwaysTemplate)
        b.addTarget(self, action: #selector(buttonTouched(sender:)), for: .touchUpInside)
        return b
    }()
    
    public var emailType: EmialType?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        hx_backgroundColor   = .clear
        hx_shadowHidden      = true
        hx_barAlpha          = 0
        title                = "注册"
        setupSubViews()
        blockHandler()
    }
}

@objc extension Login_RegisterViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func buttonTouched(sender: UIButton) {
        
        if emailCodeTextField.text?.count == 0 {
            HUDUtils.showWarningHUD(string: "请输入验证码")
        } else if userNameTextField.text?.count == 0 {
            HUDUtils.showWarningHUD(string: "请输入用户名")
        } else if (userNameTextField.text?.count)! <= 6 || (userNameTextField.text?.count)! > 12 {
            HUDUtils.showWarningHUD(string: "用户名长度在6至12个字符之间")
        } else if pwdTextField.text?.count == 0 {
            HUDUtils.showWarningHUD(string: "请输入密码")
        } else if (pwdTextField.text?.count)! < 6 {
            HUDUtils.showWarningHUD(string: "密码长度不能小于6位字符")
        } else if pwdAgainTextField.text?.count == 0 {
            HUDUtils.showWarningHUD(string: "请再次输入密码")
        } else if pwdAgainTextField.text != pwdTextField.text {
            HUDUtils.showWarningHUD(string: "两次输入的密码不同")
        } else {
            YSNetWorking().register(with: emailTextField.text!, code: emailCodeTextField.text!, userName: userNameTextField.text!, password: pwdAgainTextField.text!, successComplete: { (data) -> (Void) in
                let code: Int = data["code"] as! Int
                if code == 0 {
                    HUDUtils.showSuccessHUD(string: "注册成功~")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2, execute: {
                        self.navigationController?.popToRootViewController(animated: true)
                    })
                } else {
                    HUDUtils.showErrorHUD(string: (data["msg"] as! String))
                }
                
            }) { (error) -> (Void) in
                
            }
        }
    }
}

extension Login_RegisterViewController {
    
    func blockHandler() {

        emailCodeTextField.textFieldNextResponseHandler = { [weak self] (textField:WD_NoLeftView_TextField) in
            guard let strongSelf = self else { return }
            strongSelf.emailCodeTextField.resignFirstResponder()
            strongSelf.userNameTextField.becomeFirstResponder()
        }
        
        userNameTextField.textFieldNextResponseHandler = { [weak self] (textField:WD_NoLeftView_TextField) in
            guard let strongSelf = self else { return }
            strongSelf.userNameTextField.resignFirstResponder()
            strongSelf.pwdTextField.becomeFirstResponder()
        }
        
        pwdTextField.textFieldNextResponseHandler = { [weak self] (textField:WD_NoLeftView_TextField) in
            guard let strongSelf = self else { return }
            strongSelf.pwdTextField.resignFirstResponder()
            strongSelf.pwdAgainTextField.becomeFirstResponder()
        }
        
        pwdAgainTextField.textFieldNextResponseHandler = { [weak self] (textField:WD_NoLeftView_TextField) in
            guard let strongSelf = self else { return }
            strongSelf.view.endEditing(true)
        }
    }
    
    func setupSubViews() {
        view.addSubview(userNameTextField)
        userNameTextField.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.centerY).offset(-15 * kSCREEN_RATE_WIDTH)
            make.leading.trailing.equalToSuperview().inset(30 * kSCREEN_RATE_WIDTH)
            make.height.equalTo(45 * kSCREEN_RATE_HEIGHT)
        }
        
        view.addSubview(pwdTextField)
        pwdTextField.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.centerY).offset(15 * kSCREEN_RATE_WIDTH)
            make.leading.trailing.equalToSuperview().inset(30 * kSCREEN_RATE_WIDTH)
            make.height.equalTo(45 * kSCREEN_RATE_HEIGHT)
        }
        
        view.addSubview(pwdAgainTextField)
        pwdAgainTextField.snp.makeConstraints { (make) in
            make.top.equalTo(pwdTextField.snp.bottom).offset(30 * kSCREEN_RATE_WIDTH)
            make.leading.trailing.equalToSuperview().inset(30 * kSCREEN_RATE_WIDTH)
            make.height.equalTo(45 * kSCREEN_RATE_HEIGHT)
        }

        view.addSubview(sureButton)
        sureButton.snp.makeConstraints { (make) in
            make.top.equalTo(pwdAgainTextField.snp.bottom).offset(30 * kSCREEN_RATE_WIDTH)
            make.centerX.equalToSuperview()
        }


        view.addSubview(emailCodeTextField)
        emailCodeTextField.snp.makeConstraints { (make) in
            make.bottom.equalTo(userNameTextField.snp.top).offset(-30 * kSCREEN_RATE_WIDTH)
            make.leading.trailing.equalToSuperview().inset(30 * kSCREEN_RATE_WIDTH)
            make.height.equalTo(45 * kSCREEN_RATE_HEIGHT)
        }

        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { (make) in
            make.bottom.equalTo(emailCodeTextField.snp.top).offset(-30 * kSCREEN_RATE_WIDTH)
            make.leading.trailing.equalToSuperview().inset(30 * kSCREEN_RATE_WIDTH)
            make.height.equalTo(45 * kSCREEN_RATE_HEIGHT)
        }
    }
}
