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
        
        view.endEditing(true)
                
        if let text = accountTextField.text {
            if text.count == 0 {
                HUDUtils.showWarningHUD(string: "请输入邮箱地址")
                return
            }
            
            let isValid = InputCheckUtils().checkEmial(email: accountTextField.text!)
            if !isValid {
                HUDUtils.showWarningHUD(string: "邮箱格式错误, 请检查输入")
                return
            } else {
                if let type = emailType {
                    switch type {
                    case .register:
                        YSNetWorking().registerSendCode(with: text, successComplete: { (data) -> (Void) in
                           
                            let code: Int = data["code"] as! Int
                            if code == 0 {
                                HUDUtils.showSuccessHUD(string: "验证码已发送至您的邮箱，请注意查收")
                                let vc = Login_RegisterViewController()
                                vc.emailTextField.text = text
                                self.navigationController?.pushViewController(vc, animated: true)
                            } else {
                                let msg: String = data["msg"] as! String
                                if msg.contains("重复") {
                                    let vc = Login_RegisterViewController()
                                    vc.emailTextField.text = text
                                    self.navigationController?.pushViewController(vc, animated: true)
                                } else {
                                    HUDUtils.showErrorHUD(string: msg)
                                }
                            }
                            
                        }) { (error) -> (Void) in
                            
                        }
                    case .forgetPassword:
                        YSNetWorking().forgetPasswordSendCode(with: text, successComplete: { (data) -> (Void) in
                            let code: Int = data["code"] as! Int
                            if code == 0 {
                                HUDUtils.showSuccessHUD(string: "验证码已发送至您的邮箱，请注意查收")
                                let vc = Login_ForgetPwdViewController()
                                vc.emailTextField.text = text
                                self.navigationController?.pushViewController(vc, animated: true)
                            } else {
                                
                                let msg: String = data["msg"] as! String
                                if msg.contains("重复") {
                                    let vc = Login_ForgetPwdViewController()
                                    vc.emailTextField.text = text
                                    self.navigationController?.pushViewController(vc, animated: true)
                                } else {
                                    HUDUtils.showErrorHUD(string: msg)
                                }
                            }
                        }) { (error) -> (Void) in
                            
                        }
                    }
                }
            }
        }
    }
}

extension Login_EmailViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func blockHanler() {
        accountTextField.textFieldChangeHandler = { [weak self] (text: String, textField: WD_TextField) -> Void in
            guard let strongSelf = self else { return }
            if text.count > 0 {
                strongSelf.sureButton.imageView!.tintColor = kMain_Color_line_dark.withAlphaComponent(1)
            } else {
                strongSelf.sureButton.imageView!.tintColor = kMain_Color_line_dark.withAlphaComponent(0.5)
            }
        }
        
        accountTextField.textFieldNextResponseHandler = { [weak self] (textField:WD_TextField) in
            guard let strongSelf = self else { return }
            strongSelf.view.endEditing(true)
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
