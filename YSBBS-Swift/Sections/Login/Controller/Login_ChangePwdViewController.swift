//
//  Login_ChangePwdViewController.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/2/27.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit

class Login_ChangePwdViewController: UIViewController {
    
    ///  Password
    private lazy var pwdOldTextField: WD_NoLeftView_TextField = {
        let textField               = WD_NoLeftView_TextField()
        textField.placeholder       = "旧密码";
        textField.returnKeyType     = .next
        textField.isSecureTextEntry = true
        textField.clearButtonMode   = .whileEditing
        return textField
    }()

    ///  Password
    private lazy var pwdTextField: WD_NoLeftView_TextField = {
        let textField               = WD_NoLeftView_TextField()
        textField.placeholder       = "密码";
        textField.returnKeyType     = .next
        textField.isSecureTextEntry = true
        textField.clearButtonMode   = .whileEditing
        return textField
    }()
    
    ///  Password again
    private lazy var pwdAgainTextField: WD_NoLeftView_TextField = {
        let textField               = WD_NoLeftView_TextField()
        textField.placeholder       = "确认密码";
        textField.returnKeyType     = .done
        textField.isSecureTextEntry = true
        textField.clearButtonMode   = .whileEditing
        return textField
    }()
    
    /// Sure button
    private lazy var sureButton: UIButton = {
        let b = UIButton.init(type: .custom)
        let image = UIImage.init(named: "loing_btn_normal_50x50_")
        b.setImage(image, for: .normal)
        b.imageView!.tintColor = kMain_Color_line_dark.withAlphaComponent(0.5)
        b.currentImage?.withRenderingMode(.alwaysTemplate)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "修改密码"
        hx_backgroundColor = .clear
        hx_shadowHidden = false
        hx_barAlpha = 0
        setupSubViews()
        blockHandler()
    }
}


// MARK: - Touch Evevt
extension Login_ChangePwdViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func blockHandler() {
        pwdOldTextField.textFieldNextResponseHandler = { [weak self] (textField:WD_NoLeftView_TextField) in
            guard let strongSelf = self else { return }
            strongSelf.pwdOldTextField.resignFirstResponder()
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
        view.addSubview(pwdTextField)
        pwdTextField.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.centerY).offset(-15 * kSCREEN_RATE_WIDTH)
            make.leading.trailing.equalToSuperview().inset(30 * kSCREEN_RATE_WIDTH)
            make.height.equalTo(45 * kSCREEN_RATE_HEIGHT)
        }
        
        view.addSubview(pwdAgainTextField)
        pwdAgainTextField.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.centerY).offset(15 * kSCREEN_RATE_WIDTH)
            make.leading.trailing.equalToSuperview().inset(30 * kSCREEN_RATE_WIDTH)
            make.height.equalTo(45 * kSCREEN_RATE_HEIGHT)
        }
        
        view.addSubview(sureButton)
        sureButton.snp.makeConstraints { (make) in
            make.top.equalTo(pwdAgainTextField.snp.bottom).offset(30 * kSCREEN_RATE_WIDTH)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(pwdOldTextField)
        pwdOldTextField.snp.makeConstraints { (make) in
            make.bottom.equalTo(pwdTextField.snp.top).offset(-30 * kSCREEN_RATE_WIDTH)
            make.leading.trailing.equalToSuperview().inset(30 * kSCREEN_RATE_WIDTH)
            make.height.equalTo(45 * kSCREEN_RATE_HEIGHT)
        }
    }
}
