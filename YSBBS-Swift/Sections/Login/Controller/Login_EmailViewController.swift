//
//  Login_EmailViewController.swift
//  YSBBS-Swift
//
//  Created by wudan on 2019/2/27.
//  Copyright © 2019 com.wudan. All rights reserved.
//

import UIKit

class Login_EmailViewController: UIViewController {
    
    public var emailType: EmialType?
    
    /// Account name or email
    private lazy var accountTextField: WD_TextField = {
        let textField = WD_TextField()
        textField.placeholder = "邮箱地址";
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .done
        textField.leftView = UIImageView.init(image: UIImage.init(named: "login_phone number_12x16_"))
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        hx_backgroundColor = .clear
        hx_shadowHidden = true
        hx_barAlpha = 0
        setupSubViews()
        blockHanler()
    }
}

@objc
extension Login_EmailViewController {
     func buttonTouched(sender: UIButton) {
        if let type = emailType {
            switch type {
            case .register:
                navigationController?.pushViewController(Login_RegisterViewController(), animated: true)
            case .forgetPassword:
                navigationController?.pushViewController(Login_ForgetPwdViewController(), animated: true)
            }
        }
    }
}

extension Login_EmailViewController {
    
    func blockHanler() {
        accountTextField.textFieldChangeHandler = { [weak self] (text: String, textField: WD_TextField) -> Void in
            if text.count > 0 {
                self!.sureButton.imageView!.tintColor = kMain_Color_line_dark.withAlphaComponent(1)
            } else {
                self!.sureButton.imageView!.tintColor = kMain_Color_line_dark.withAlphaComponent(0.5)
            }
        }
        
        accountTextField.textFieldNextResponseHandler = { [weak self] (textField:WD_TextField) in
            self!.view.endEditing(true)
        }
    }
    
    func setupSubViews() {
        view.addSubview(accountTextField)
        accountTextField.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.centerY).offset(-15 * kSCREEN_RATE_WIDTH)
            make.leading.trailing.equalToSuperview().inset(30 * kSCREEN_RATE_WIDTH)
            make.height.equalTo(45 * kSCREEN_RATE_HEIGHT)
        }
        
        view.addSubview(sureButton)
        sureButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.centerY).offset(15 * kSCREEN_RATE_WIDTH)
            make.centerX.equalToSuperview()
        }
    }
}
